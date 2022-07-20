import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/src/CryptoUtils.dart';
import 'package:basic_utils/src/IterableUtils.dart';
import 'package:basic_utils/src/StringUtils.dart';
import 'package:basic_utils/src/model/crl/CertificateListData.dart';
import 'package:basic_utils/src/model/crl/CertificateRevokeListData.dart';
import 'package:basic_utils/src/model/crl/CrlEntryExtensionsData.dart';
import 'package:basic_utils/src/model/crl/CrlReason.dart';
import 'package:basic_utils/src/model/crl/RevokedCertificate.dart';
import 'package:basic_utils/src/model/csr/CertificateSigningRequestData.dart';
import 'package:basic_utils/src/model/csr/CertificateSigningRequestExtensions.dart';
import 'package:basic_utils/src/model/csr/SubjectPublicKeyInfo.dart';
import 'package:basic_utils/src/model/ocsp/BasicOCSPResponse.dart';
import 'package:basic_utils/src/model/ocsp/OCSPCertStatus.dart';
import 'package:basic_utils/src/model/ocsp/OCSPCertStatusValues.dart';
import 'package:basic_utils/src/model/ocsp/OCSPResponse.dart';
import 'package:basic_utils/src/model/ocsp/OCSPResponseData.dart';
import 'package:basic_utils/src/model/ocsp/OCSPResponseStatus.dart';
import 'package:basic_utils/src/model/ocsp/OCSPSingleResponse.dart';
import 'package:basic_utils/src/model/pkcs7/Pkcs7CertificateData.dart';
import 'package:basic_utils/src/model/x509/ExtendedKeyUsage.dart';
import 'package:basic_utils/src/model/x509/VmcData.dart';
import 'package:basic_utils/src/model/x509/X509CertificateData.dart';
import 'package:basic_utils/src/model/x509/X509CertificateDataExtensions.dart';
import 'package:basic_utils/src/model/x509/X509CertificatePublicKeyData.dart';
import 'package:basic_utils/src/model/x509/X509CertificateValidity.dart';

import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';

///
/// Helper class for certificate operations.
///
class X509Utils {
  static const BEGIN_PRIVATE_KEY = '-----BEGIN PRIVATE KEY-----';
  static const END_PRIVATE_KEY = '-----END PRIVATE KEY-----';

  static const BEGIN_PUBLIC_KEY = '-----BEGIN PUBLIC KEY-----';
  static const END_PUBLIC_KEY = '-----END PUBLIC KEY-----';

  static const BEGIN_CSR = '-----BEGIN CERTIFICATE REQUEST-----';
  static const END_CSR = '-----END CERTIFICATE REQUEST-----';

  static const BEGIN_NEW_CSR = '-----BEGIN NEW CERTIFICATE REQUEST-----';
  static const END_NEW_CSR = '-----END NEW CERTIFICATE REQUEST-----';

  static const BEGIN_EC_PRIVATE_KEY = '-----BEGIN EC PRIVATE KEY-----';
  static const END_EC_PRIVATE_KEY = '-----END EC PRIVATE KEY-----';

  static const BEGIN_EC_PUBLIC_KEY = '-----BEGIN PUBLIC KEY-----';
  static const END_EC_PUBLIC_KEY = '-----END PUBLIC KEY-----';

  static const BEGIN_PKCS7 = '-----BEGIN PKCS7-----';
  static const END_PKCS7 = '-----END PKCS7-----';

  static const BEGIN_CERT = '-----BEGIN CERTIFICATE-----';
  static const END_CERT = '-----END CERTIFICATE-----';

  static const BEGIN_CRL = '-----BEGIN X509 CRL-----';
  static const END_CRL = '-----END X509 CRL-----';

  static const OCSP_REQUEST_MEDIATYPE = 'application/ocsp-request';

  static const OCSP_RESPONSE_MEDIATYPE = 'application/ocsp-response';

  static const DN = {
    'cn': '2.5.4.3',
    'sn': '2.5.4.4',
    'c': '2.5.4.6',
    'l': '2.5.4.7',
    'st': '2.5.4.8',
    's': '2.5.4.8',
    'o': '2.5.4.10',
    'ou': '2.5.4.11',
    'title': '2.5.4.12',
    'registeredAddress': '2.5.4.26',
    'member': '2.5.4.31',
    'owner': '2.5.4.32',
    'roleOccupant': '2.5.4.33',
    'seeAlso': '2.5.4.34',
    'givenName': '2.5.4.42',
    'initials': '2.5.4.43',
    'generationQualifier': '2.5.4.44',
    'dmdName': '2.5.4.54',
    'alias': '2.5.6.1',
    'country': '2.5.6.2',
    'locality': '2.5.6.3',
    'organization': '2.5.6.4',
    'organizationalUnit': '2.5.6.5',
    'person': '2.5.6.6',
    'organizationalPerson': '2.5.6.7',
    'organizationalRole': '2.5.6.8',
    'groupOfNames': '2.5.6.9',
    'residentialPerson': '2.5.6.10',
    'applicationProcess': '2.5.6.11',
    'applicationEntity': '2.5.6.12',
    'dSA': '2.5.6.13',
    'device': '2.5.6.14',
    'strongAuthenticationUser': '2.5.6.15',
    'certificationAuthority': '2.5.6.16',
    'groupOfUniqueNames': '2.5.6.17',
    'userSecurityInformation': '2.5.6.18',
    'certificationAuthority-V2': '2.5.6.16.2',
    'cRLDistributionPoint': '2.5.6.19',
    'dmd': '2.5.6.20',
    'md5WithRSAEncryption': '1.2.840.113549.1.1.4',
    'rsaEncryption': '1.2.840.113549.1.1.1',
    'organizationalUnitName': '2.5.4.11',
    'organizationName': '2.5.4.10',
    'stateOrProvinceName': '2.5.4.8',
    'commonName': '2.5.4.3',
    'surname': '2.5.4.4',
    'countryName': '2.5.4.6',
    'localityName': '2.5.4.7',
    'streetAddress': '2.5.4.9'
  };

  static final _validRsaSigner = [
    'SHA-1',
    'SHA-224',
    'SHA-256',
    'SHA-384',
    'SHA-512'
  ];

  ///
  /// Formats the given [key] by chunking the [key] and adding the [begin] and [end] to the [key].
  ///
  /// The line length will be defined by the given [chunkSize]. The default value is 64.
  ///
  /// Each line will be delimited by the given [lineDelimiter]. The default value is '\n'.w
  ///
  static String formatKeyString(String key, String begin, String end,
      {int chunkSize = 64, String lineDelimiter = '\n'}) {
    var sb = StringBuffer();
    var chunks = StringUtils.chunk(key, chunkSize);
    sb.write(begin + lineDelimiter);
    for (var s in chunks) {
      sb.write(s + lineDelimiter);
    }
    sb.write(end);
    return sb.toString();
  }

  ///
  /// Generates a Certificate Signing Request with the given [attributes] using the given [privateKey] and [publicKey].
  ///
  /// The parameter [san] defines the list of subject alternative names to be placed within the CSR.
  ///
  /// [signingAlgorithm] defines the algorithm to use to sign the distinguished names. Supported values are
  /// * SHA-1
  /// * SHA-224
  /// * SHA-256 (default)
  /// * SHA-384
  /// * SHA-512
  ///
  static String generateRsaCsrPem(Map<String, String> attributes,
      RSAPrivateKey privateKey, RSAPublicKey publicKey,
      {List<String>? san, String signingAlgorithm = 'SHA-256'}) {
    if (!_validRsaSigner.contains(signingAlgorithm)) {
      ArgumentError('Signingalgorithm $signingAlgorithm not supported!');
    }
    var encodedDN = encodeDN(attributes);

    var blockDN = ASN1Sequence();
    blockDN.add(ASN1Integer(BigInt.from(0)));
    blockDN.add(encodedDN);
    blockDN.add(_makePublicKeyBlock(publicKey));

    // Check if extensions are needed
    if (san != null && san.isNotEmpty) {
      var outerBlockExt = ASN1Sequence();
      outerBlockExt.add(ASN1ObjectIdentifier.fromName('extensionRequest'));

      var setExt = ASN1Set();

      var innerBlockExt = ASN1Sequence();

      var sanExtSeq = ASN1Sequence();
      sanExtSeq.add(ASN1ObjectIdentifier.fromName('subjectAltName'));
      var sanSeq = ASN1Sequence();
      for (var s in san) {
        var sanIa5 = ASN1IA5String(stringValue: s, tag: 0x82);
        sanSeq.add(sanIa5);
      }
      var octet = ASN1OctetString(octets: sanSeq.encode());
      sanExtSeq.add(octet);

      innerBlockExt.add(sanExtSeq);

      setExt.add(innerBlockExt);

      outerBlockExt.add(setExt);

      var asn1Null = ASN1OctetString(tag: 0xA0, octets: outerBlockExt.encode());
      //asn1Null.valueBytes = outerBlockExt.encode();
      blockDN.add(asn1Null);
    } else {
      blockDN.add(ASN1Null(tag: 0xA0)); // let's call this WTF
    }

    var blockProtocol = ASN1Sequence();
    blockProtocol.add(ASN1ObjectIdentifier.fromName(
        _getOiForSigningAlgorithm(signingAlgorithm)));
    blockProtocol.add(ASN1Null());

    var outer = ASN1Sequence();
    outer.add(blockDN);
    outer.add(blockProtocol);
    outer.add(ASN1BitString(
        stringValues:
            _rsaSign(blockDN.encode(), privateKey, signingAlgorithm)));
    var chunks = StringUtils.chunk(base64.encode(outer.encode()), 64);
    return '$BEGIN_CSR\n${chunks.join('\r\n')}\n$END_CSR';
  }

  static Uint8List _rsaSign(
      Uint8List inBytes, RSAPrivateKey privateKey, String signingAlgorithm) {
    var signer = Signer('$signingAlgorithm/RSA');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    var signature = signer.generateSignature(inBytes) as RSASignature;

    return signature.bytes;
  }

  static String _getOiForSigningAlgorithm(String algorithm,
      {bool ecc = false}) {
    switch (algorithm) {
      case 'SHA-1':
        return ecc ? 'ecdsaWithSHA1' : 'sha1WithRSAEncryption';
      case 'SHA-224':
        return ecc ? 'ecdsaWithSHA224' : 'sha224WithRSAEncryption';
      case 'SHA-256':
        return ecc ? 'ecdsaWithSHA256' : 'sha256WithRSAEncryption';
      case 'SHA-384':
        return ecc ? 'ecdsaWithSHA384' : 'sha384WithRSAEncryption';
      case 'SHA-512':
        return ecc ? 'ecdsaWithSHA512' : 'sha512WithRSAEncryption';
      default:
        return ecc ? 'ecdsaWithSHA256' : 'sha256WithRSAEncryption';
    }
  }

  static String _getSigningAlgorithmFromOi(String oi) {
    switch (oi) {
      case 'ecdsaWithSHA1':
      case 'sha1WithRSAEncryption':
        return 'SHA-1';
      case 'ecdsaWithSHA224':
      case 'sha224WithRSAEncryption':
        return 'SHA-224';
      case 'ecdsaWithSHA256':
      case 'sha256WithRSAEncryption':
        return 'SHA-256';
      case 'ecdsaWithSHA384':
      case 'sha384WithRSAEncryption':
        return 'SHA-384';
      case 'ecdsaWithSHA512':
      case 'sha512WithRSAEncryption':
        return 'SHA-512';
      default:
        return 'SHA-256';
    }
  }

  ///
  /// Generates a self signed certificate
  ///
  /// * [privateKey] = The private key used for signing
  /// * [csr] = The CSR containing the DN an public key
  /// * [days] = The validity in days
  /// * [sans] = Subject alternative names to place within the certificate
  /// * [extKeyUsage] = The key usage definition
  /// * [serialNumber] = The serialnumber. If not set the default will be 1.
  ///
  static String generateSelfSignedCertificate(
    PrivateKey privateKey,
    String csr,
    int days, {
    List<String>? sans,
    List<ExtendedKeyUsage>? extKeyUsage,
    String serialNumber = '1',
  }) {
    var csrData = csrFromPem(csr);

    var data = ASN1Sequence();

    // Add version
    var version = ASN1Object(tag: 0xA0);
    version.valueBytes = ASN1Integer.fromtInt(2).encode();
    data.add(version);

    // Add serial number
    data.add(ASN1Integer(BigInt.parse(serialNumber)));

    // Add protocoll
    var blockProtocol = ASN1Sequence();
    blockProtocol.add(
        ASN1ObjectIdentifier.fromIdentifierString(csrData.signatureAlgorithm));
    blockProtocol.add(ASN1Null());
    data.add(blockProtocol);

    // Add Issuer
    var issuerSeq = ASN1Sequence();
    for (var k in csrData.subject!.keys) {
      var value = csrData.subject![k];
      var pString;
      if (StringUtils.isAscii(value!)) {
        pString = ASN1PrintableString(stringValue: value);
      } else {
        pString = ASN1UTF8String(utf8StringValue: value);
      }
      var oIdentifier = ASN1ObjectIdentifier.fromIdentifierString(k);
      var innerSequence = ASN1Sequence(elements: [oIdentifier, pString]);
      var s = ASN1Set(elements: [innerSequence]);
      issuerSeq.add(s);
    }
    data.add(issuerSeq);

    // Add Validity
    var validitySeq = ASN1Sequence();
    validitySeq.add(ASN1UtcTime(DateTime.now()));
    validitySeq.add(ASN1UtcTime(DateTime.now().add(Duration(days: days))));
    data.add(validitySeq);

    // Add Subject
    var subjectSeq = ASN1Sequence();
    for (var k in csrData.subject!.keys) {
      var value = csrData.subject![k];
      var pString;
      if (StringUtils.isAscii(value!)) {
        pString = ASN1PrintableString(stringValue: value);
      } else {
        pString = ASN1UTF8String(utf8StringValue: value);
      }
      var oIdentifier = ASN1ObjectIdentifier.fromIdentifierString(k);
      var innerSequence = ASN1Sequence(elements: [oIdentifier, pString]);
      var s = ASN1Set(elements: [innerSequence]);
      subjectSeq.add(s);
    }
    data.add(subjectSeq);

    // Add Public Key
    if (privateKey.runtimeType == RSAPrivateKey) {
      data.add(_makePublicKeyBlock(CryptoUtils.rsaPublicKeyFromDERBytes(
          _stringAsBytes(csrData.publicKeyInfo!.bytes!))));
    } else {
      data.add(_makeEccPublicKeyBlock(CryptoUtils.ecPublicKeyFromDerBytes(
          _stringAsBytes(csrData.publicKeyInfo!.bytes!))));
    }

    // Add Extensions
    if (IterableUtils.isNotNullOrEmpty(sans) ||
        IterableUtils.isNotNullOrEmpty(extKeyUsage)) {
      var extensionTopSequence = ASN1Sequence();

      if (IterableUtils.isNotNullOrEmpty(extKeyUsage)) {
        var extKeyUsageList = ASN1Sequence();
        for (var s in extKeyUsage!) {
          var oi = <int>[];
          switch (s) {
            case ExtendedKeyUsage.SERVER_AUTH:
              oi = [1, 3, 6, 1, 5, 5, 7, 3, 1];
              break;
            case ExtendedKeyUsage.CLIENT_AUTH:
              oi = [1, 3, 6, 1, 5, 5, 7, 3, 2];
              break;
            case ExtendedKeyUsage.CODE_SIGNING:
              oi = [1, 3, 6, 1, 5, 5, 7, 3, 3];
              break;
            case ExtendedKeyUsage.EMAIL_PROTECTION:
              oi = [1, 3, 6, 1, 5, 5, 7, 3, 4];
              break;
            case ExtendedKeyUsage.TIME_STAMPING:
              oi = [1, 3, 6, 1, 5, 5, 7, 3, 8];
              break;
            case ExtendedKeyUsage.OCSP_SIGNING:
              oi = [1, 3, 6, 1, 5, 5, 7, 3, 9];
              break;
            case ExtendedKeyUsage.BIMI:
              oi = [1, 3, 6, 1, 5, 5, 7, 3, 31];
              break;
          }
          extKeyUsageList.add(ASN1ObjectIdentifier(oi));
        }
        var octetString = ASN1OctetString(octets: extKeyUsageList.encode());

        var extKeyUsageSequence = ASN1Sequence();
        extKeyUsageSequence
            .add(ASN1ObjectIdentifier.fromIdentifierString('2.5.29.37'));
        extKeyUsageSequence.add(octetString);
        extensionTopSequence.add(extKeyUsageSequence);
      }

      if (IterableUtils.isNotNullOrEmpty(sans)) {
        var sanList = ASN1Sequence();
        for (var s in sans!) {
          sanList.add(ASN1PrintableString(stringValue: s, tag: 0x82));
        }
        var octetString = ASN1OctetString(octets: sanList.encode());

        var sanSequence = ASN1Sequence();
        sanSequence.add(ASN1ObjectIdentifier.fromIdentifierString('2.5.29.17'));
        sanSequence.add(octetString);
        extensionTopSequence.add(sanSequence);
      }
      var extObj = ASN1Object(tag: 0xA3);
      extObj.valueBytes = extensionTopSequence.encode();

      data.add(extObj);
    }

    var outer = ASN1Sequence();
    outer.add(data);
    outer.add(blockProtocol);
    if (privateKey.runtimeType == RSAPrivateKey) {
      outer.add(ASN1BitString(
          stringValues: _rsaSign(data.encode(), privateKey as RSAPrivateKey,
              _getSigningAlgorithmFromOi(csrData.signatureAlgorithm!))));
    } else {
      var ecSignature = eccSign(data.encode(), privateKey as ECPrivateKey,
          _getSigningAlgorithmFromOi(csrData.signatureAlgorithm!));
      var bitStringSequence = ASN1Sequence();
      bitStringSequence.add(ASN1Integer(ecSignature.r));
      bitStringSequence.add(ASN1Integer(ecSignature.s));
      var blockSignatureValue =
          ASN1BitString(stringValues: bitStringSequence.encode());
      outer.add(blockSignatureValue);
    }

    var chunks = StringUtils.chunk(base64.encode(outer.encode()), 64);
    return '$BEGIN_CERT\n${chunks.join('\r\n')}\n$END_CERT';
  }

  ///
  /// Generates a eliptic curve Certificate Signing Request with the given [attributes] using the given [privateKey] and [publicKey].
  ///
  /// The parameter [san] defines the list of subject alternative names to be placed within the CSR.
  ///
  /// [signingAlgorithm] defines the algorithm to use to sign the distinguished names. Supported values are
  /// * SHA-1
  /// * SHA-224
  /// * SHA-256 (default)
  /// * SHA-384
  /// * SHA-512
  ///
  static String generateEccCsrPem(Map<String, String> attributes,
      ECPrivateKey privateKey, ECPublicKey publicKey,
      {List<String>? san, String signingAlgorithm = 'SHA-256'}) {
    if (!_validRsaSigner.contains(signingAlgorithm)) {
      ArgumentError('Signingalgorithm $signingAlgorithm not supported!');
    }
    var encodedDN = encodeDN(attributes);
    var publicKeySequence = _makeEccPublicKeyBlock(publicKey);

    var blockDN = ASN1Sequence();
    blockDN.add(ASN1Integer(BigInt.from(0)));
    blockDN.add(encodedDN);
    blockDN.add(publicKeySequence);
    // Check if extensions are needed
    if (san != null && san.isNotEmpty) {
      var outerBlockExt = ASN1Sequence();
      outerBlockExt.add(ASN1ObjectIdentifier.fromName('extensionRequest'));

      var setExt = ASN1Set();

      var innerBlockExt = ASN1Sequence();

      var sanExtSeq = ASN1Sequence();
      sanExtSeq.add(ASN1ObjectIdentifier.fromName('subjectAltName'));
      var sanSeq = ASN1Sequence();
      for (var s in san) {
        var sanIa5 = ASN1IA5String(stringValue: s, tag: 0x82);
        sanSeq.add(sanIa5);
      }
      var octet = ASN1OctetString(octets: sanSeq.encode());
      sanExtSeq.add(octet);

      innerBlockExt.add(sanExtSeq);

      setExt.add(innerBlockExt);

      outerBlockExt.add(setExt);

      var asn1Null = ASN1OctetString(tag: 0xA0, octets: outerBlockExt.encode());
      //asn1Null.valueBytes = outerBlockExt.encode();
      blockDN.add(asn1Null);
    } else {
      blockDN.add(ASN1Null(tag: 0xA0)); // let's call this WTF
    }

    var blockSignatureAlgorithm = ASN1Sequence();
    blockSignatureAlgorithm.add(ASN1ObjectIdentifier.fromName(
        _getOiForSigningAlgorithm(signingAlgorithm, ecc: true)));

    var ecSignature = eccSign(blockDN.encode(), privateKey, signingAlgorithm);

    var bitStringSequence = ASN1Sequence();
    bitStringSequence.add(ASN1Integer(ecSignature.r));
    bitStringSequence.add(ASN1Integer(ecSignature.s));
    var blockSignatureValue =
        ASN1BitString(stringValues: bitStringSequence.encode());

    var outer = ASN1Sequence();
    outer.add(blockDN);
    outer.add(blockSignatureAlgorithm);
    outer.add(blockSignatureValue);
    var chunks = StringUtils.chunk(base64.encode(outer.encode()), 64);
    return '$BEGIN_CSR\n${chunks.join('\r\n')}\n$END_CSR';
  }

  static ECSignature eccSign(
      Uint8List inBytes, ECPrivateKey privateKey, String signingAlgorithm) {
    var signer = Signer('$signingAlgorithm/ECDSA');
    var privParams = PrivateKeyParameter<ECPrivateKey>(privateKey);
    var signParams = ParametersWithRandom(
      privParams,
      _getSecureRandom(),
    );
    signer.init(true, signParams);

    return signer.generateSignature(inBytes) as ECSignature;
  }

  static SecureRandom _getSecureRandom() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    var seeds = <int>[];
    for (var i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  ///
  /// Encode the given [asn1Object] to PEM format and adding the [begin] and [end].
  ///
  static String encodeASN1ObjectToPem(
      ASN1Object asn1Object, String begin, String end,
      {String newLine = '\n'}) {
    var bytes = asn1Object.encode();
    var chunks = StringUtils.chunk(base64.encode(bytes), 64);
    return '$begin$newLine${chunks.join(newLine)}$newLine$end';
  }

  ///
  /// Parses the given PEM
  ///
  static Pkcs7CertificateData pkcs7fromPem(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var x509List = <X509CertificateData>[];
    var version = 0;
    var type = '';
    if (topLevelSeq.elements != null) {
      var oi = topLevelSeq.elements!.elementAt(0) as ASN1ObjectIdentifier;
      type = oi.objectIdentifierAsString!;
      var obj = topLevelSeq.elements!.elementAt(1);
      var seq = ASN1Sequence.fromBytes(obj.valueBytes!);
      var integer = seq.elements!.elementAt(0) as ASN1Integer;
      version = integer.integer!.toInt();
      var obj1 = seq.elements!.elementAt(3);
      var seq1 = ASN1Sequence.fromBytes(obj1.encodedBytes!);

      for (var el in seq1.elements!) {
        var x509 = _x509FromAsn1Sequence(el as ASN1Sequence);
        var plain = encodeASN1ObjectToPem(el, BEGIN_CERT, END_CERT);
        x509.plain = plain;
        x509List.add(x509);
      }
    }

    return Pkcs7CertificateData(
        certificates: x509List, version: version, contentType: type);
  }

  static X509CertificateData _x509FromAsn1Sequence(ASN1Sequence topLevelSeq) {
    var dataSequence = topLevelSeq.elements!.elementAt(0) as ASN1Sequence;
    int version;
    var element = 0;
    var serialInteger;
    if (dataSequence.elements!.elementAt(0) is ASN1Integer) {
      // The version ASN1Object ist missing use version
      version = 1;
      // Serialnumber
      serialInteger = dataSequence.elements!.elementAt(element) as ASN1Integer;
      element = -1;
    } else {
      // Version
      var versionObject = dataSequence.elements!.elementAt(element + 0);
      version = versionObject.valueBytes!.elementAt(2);
      // Serialnumber
      serialInteger =
          dataSequence.elements!.elementAt(element + 1) as ASN1Integer;
    }
    BigInt serialNumber = serialInteger.integer;

    // Signature
    var signatureSequence =
        dataSequence.elements!.elementAt(element + 2) as ASN1Sequence;
    var o = signatureSequence.elements!.elementAt(0) as ASN1ObjectIdentifier;
    var signatureAlgorithm = o.objectIdentifierAsString!;

    // Issuer
    var issuerSequence =
        dataSequence.elements!.elementAt(element + 3) as ASN1Sequence;
    var issuer = <String, String?>{};
    for (var s in issuerSequence.elements as dynamic) {
      var setSequence = s.elements!.elementAt(0) as ASN1Sequence;
      var o = setSequence.elements!.elementAt(0) as ASN1ObjectIdentifier;
      var object = setSequence.elements!.elementAt(1);
      String? value = '';
      if (object is ASN1UTF8String) {
        var objectAsUtf8 = object;
        value = objectAsUtf8.utf8StringValue;
      } else if (object is ASN1PrintableString) {
        var objectPrintable = object;
        value = objectPrintable.stringValue;
      } else if (object is ASN1TeletextString) {
        var objectTeletext = object;
        value = objectTeletext.stringValue;
      }
      issuer.putIfAbsent(o.objectIdentifierAsString!, () => value);
    }

    // Validity
    var validitySequence =
        dataSequence.elements!.elementAt(element + 4) as ASN1Sequence;
    var asn1FromDateTime;
    var asn1ToDateTime;
    if (validitySequence.elements!.elementAt(0) is ASN1UtcTime) {
      var asn1From = validitySequence.elements!.elementAt(0) as ASN1UtcTime;
      asn1FromDateTime = asn1From.time;
    } else {
      var asn1From =
          validitySequence.elements!.elementAt(0) as ASN1GeneralizedTime;
      asn1FromDateTime = asn1From.dateTimeValue;
    }
    if (validitySequence.elements!.elementAt(1) is ASN1UtcTime) {
      var asn1To = validitySequence.elements!.elementAt(1) as ASN1UtcTime;
      asn1ToDateTime = asn1To.time;
    } else {
      var asn1To =
          validitySequence.elements!.elementAt(1) as ASN1GeneralizedTime;
      asn1ToDateTime = asn1To.dateTimeValue;
    }

    var validity = X509CertificateValidity(
        notBefore: asn1FromDateTime, notAfter: asn1ToDateTime);

    // Subject
    var subjectSequence =
        dataSequence.elements!.elementAt(element + 5) as ASN1Sequence;
    var subject = <String, String?>{};
    for (var s in subjectSequence.elements as dynamic) {
      var setSequence = s.elements!.elementAt(0) as ASN1Sequence;
      var o = setSequence.elements!.elementAt(0) as ASN1ObjectIdentifier;
      var object = setSequence.elements!.elementAt(1);
      String? value = '';
      if (object is ASN1UTF8String) {
        var objectAsUtf8 = object;
        value = objectAsUtf8.utf8StringValue;
      } else if (object is ASN1PrintableString) {
        var objectPrintable = object;
        value = objectPrintable.stringValue;
      }
      var identifier = o.objectIdentifierAsString ?? 'unknown';
      subject.putIfAbsent(identifier, () => value);
    }

    // Public Key
    var pubKeySequence =
        dataSequence.elements!.elementAt(element + 6) as ASN1Sequence;

    var algoSequence = pubKeySequence.elements!.elementAt(0) as ASN1Sequence;
    var pubKeyOid = algoSequence.elements!.elementAt(0) as ASN1ObjectIdentifier;
    var asn1AlgParameters = algoSequence.elements!.elementAt(1);
    var algParameters = '';
    var algParametersReadable = '';
    if (asn1AlgParameters is ASN1ObjectIdentifier) {
      algParameters = asn1AlgParameters.objectIdentifierAsString!;
      algParametersReadable = asn1AlgParameters.readableName!;
    }

    var pubKey = pubKeySequence.elements!.elementAt(1) as ASN1BitString;
    var asn1PubKeyParser = ASN1Parser(pubKey.stringValues as Uint8List?);
    var next;
    try {
      next = asn1PubKeyParser.nextObject();
    } catch (e) {
      // continue
    }
    var pubKeyLength = 0;

    Uint8List? pubKeyAsBytes;
    int? exponent;
    if (next != null && next is ASN1Sequence) {
      var s = next;
      var key = s.elements!.elementAt(0) as ASN1Integer;
      if (s.elements!.length == 2 && s.elements!.elementAt(1) is ASN1Integer) {
        var asn1Exponent = s.elements!.elementAt(1) as ASN1Integer;
        exponent = asn1Exponent.integer!.toInt();
      }
      pubKeyLength = key.integer!.bitLength;
      pubKeyAsBytes = s.encodedBytes;
    } else {
      pubKeyAsBytes = pubKey.valueBytes;
      pubKeyLength = pubKey.valueBytes!.length * 8;
    }
    var pubKeyThumbprint = CryptoUtils.getHash(pubKeySequence.encodedBytes!,
        algorithmName: 'SHA-1');
    var plainSha1 = CryptoUtils.getHashPlain(pubKeySequence.encodedBytes!,
        algorithmName: 'SHA-1');
    var pubKeySha256Thumbprint = CryptoUtils.getHash(
        pubKeySequence.encodedBytes!,
        algorithmName: 'SHA-256');
    var publicKeyData = X509CertificatePublicKeyData(
      algorithm: pubKeyOid.objectIdentifierAsString,
      algorithmReadableName: pubKeyOid.readableName,
      bytes: _bytesAsString(pubKeyAsBytes!),
      length: pubKeyLength,
      sha1Thumbprint: pubKeyThumbprint,
      sha256Thumbprint: pubKeySha256Thumbprint,
      plainSha1: plainSha1,
      exponent: exponent,
      parameter: algParameters != '' ? algParameters : null,
      parameterReadableName:
          algParametersReadable != '' ? algParametersReadable : null,
    );
    List<String>? sans;
    List<ExtendedKeyUsage>? extKeyUsage;
    var extensions = X509CertificateDataExtensions();
    if (version > 1) {
      // Extensions
      if (dataSequence.elements!.length == 8) {
        var extensionObject = dataSequence.elements!.elementAt(element + 7);
        var extParser = ASN1Parser(extensionObject.valueBytes);
        var extSequence = extParser.nextObject() as ASN1Sequence;

        extSequence.elements!.forEach((ASN1Object subseq) {
          var seq = subseq as ASN1Sequence;
          var oi = seq.elements!.elementAt(0) as ASN1ObjectIdentifier;
          if (oi.objectIdentifierAsString == '2.5.29.17') {
            if (seq.elements!.length == 3) {
              sans = _fetchSansFromExtension(seq.elements!.elementAt(2));
            } else {
              sans = _fetchSansFromExtension(seq.elements!.elementAt(1));
            }
            extensions.subjectAlternativNames = sans;
          }
          if (oi.objectIdentifierAsString == '2.5.29.37') {
            if (seq.elements!.length == 3) {
              extKeyUsage = _fetchExtendedKeyUsageFromExtension(
                  seq.elements!.elementAt(2));
            } else {
              extKeyUsage = _fetchExtendedKeyUsageFromExtension(
                  seq.elements!.elementAt(1));
            }
            extensions.extKeyUsage = extKeyUsage;
          }
          if (oi.objectIdentifierAsString == '1.3.6.1.5.5.7.1.12') {
            var vmcData = _fetchVmcLogo(seq.elements!.elementAt(1));
            extensions.vmc = vmcData;
          }
          if (oi.objectIdentifierAsString == '2.5.29.31') {
            var cRLDistributionPoints =
                _fetchCrlDistributionPoints(seq.elements!.elementAt(1));
            extensions.cRLDistributionPoints = cRLDistributionPoints;
          }
        });
      }
    }

    return X509CertificateData(
      version: version,
      serialNumber: serialNumber,
      signatureAlgorithm: signatureAlgorithm,
      issuer: issuer,
      validity: validity,
      subject: subject,
      publicKeyData: publicKeyData,
      subjectAlternativNames: sans,
      extKeyUsage: extKeyUsage,
      extensions: extensions,
    );
  }

  ///
  /// Parses the given PEM to a [X509CertificateData] object.
  ///
  /// Throws an [ASN1Exception] if the pem could not be read by the [ASN1Parser].
  ///
  static X509CertificateData x509CertificateFromPem(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    var x509 = _x509FromAsn1Sequence(topLevelSeq);

    var sha1String = CryptoUtils.getHash(bytes, algorithmName: 'SHA-1');
    var md5String = CryptoUtils.getHash(bytes, algorithmName: 'MD5');
    var sha256String = CryptoUtils.getHash(bytes, algorithmName: 'SHA-256');

    x509.plain = pem;
    x509.sha1Thumbprint = sha1String;
    x509.md5Thumbprint = md5String;
    x509.sha256Thumbprint = sha256String;
    return x509;
  }

  ///
  /// Decode the given [asnSequence] into an [RSAPrivateKey].
  ///
  static RSAPrivateKey privateKeyFromASN1Sequence(ASN1Sequence asnSequence) {
    var objects = asnSequence.elements!;

    var asnIntegers = objects.take(9).map((o) => o as ASN1Integer).toList();

    var version = asnIntegers.first;
    if (version.integer != BigInt.zero) {
      throw ArgumentError('Expected version 0, got: ${version.integer}.');
    }

    var key = RSAPrivateKey(asnIntegers[1].integer!, asnIntegers[2].integer!,
        asnIntegers[4].integer, asnIntegers[5].integer);

    var bitLength = key.n!.bitLength;
    if (bitLength != 1024 && bitLength != 2048 && bitLength != 4096) {
      throw ArgumentError('The RSA modulus has a bit length of $bitLength. '
          'Only 1024, 2048 and 4096 are supported.');
    }
    return key;
  }

  ///
  /// Encode the given [dn] (Distinguished Name) to a [ASN1Object].
  ///
  /// For supported DN see the rf at <https://tools.ietf.org/html/rfc2256>
  ///
  static ASN1Object encodeDN(Map<String, String> dn) {
    var distinguishedName = ASN1Sequence();
    dn.forEach((name, value) {
      var oid = ASN1ObjectIdentifier.fromName(name);

      ASN1Object ovalue;
      switch (name.toUpperCase()) {
        case 'C':
          ovalue = ASN1PrintableString(stringValue: value);
          break;
        case 'CN':
        case 'O':
        case 'L':
        case 'S':
        default:
          ovalue = ASN1UTF8String(utf8StringValue: value);
          break;
      }

      var pair = ASN1Sequence();
      pair.add(oid);
      pair.add(ovalue);

      var pairset = ASN1Set();
      pairset.add(pair);

      distinguishedName.add(pairset);
    });

    return distinguishedName;
  }

  ///
  /// Create  the public key ASN1Sequence for the csr.
  ///
  static ASN1Sequence _makePublicKeyBlock(RSAPublicKey publicKey) {
    var blockEncryptionType = ASN1Sequence();
    blockEncryptionType.add(ASN1ObjectIdentifier.fromName('rsaEncryption'));
    blockEncryptionType.add(ASN1Null());

    var publicKeySequence = ASN1Sequence();
    publicKeySequence.add(ASN1Integer(publicKey.modulus));
    publicKeySequence.add(ASN1Integer(publicKey.exponent));

    var blockPublicKey =
        ASN1BitString(stringValues: publicKeySequence.encode());

    var outer = ASN1Sequence();
    outer.add(blockEncryptionType);
    outer.add(blockPublicKey);

    return outer;
  }

  ///
  /// Create  the public key ASN1Sequence for the ECC csr.
  ///
  static ASN1Sequence _makeEccPublicKeyBlock(ECPublicKey publicKey) {
    var algorithm = ASN1Sequence();
    algorithm.add(ASN1ObjectIdentifier.fromName('ecPublicKey'));
    algorithm
        .add(ASN1ObjectIdentifier.fromName(publicKey.parameters!.domainName));

    var subjectPublicKey =
        ASN1BitString(stringValues: publicKey.Q!.getEncoded(false));

    var outer = ASN1Sequence();
    outer.add(algorithm);
    outer.add(subjectPublicKey);

    return outer;
  }

  ///
  /// Fetches a list of subject alternative names from the given [extData]
  ///
  static List<String> _fetchSansFromExtension(ASN1Object extData) {
    var sans = <String>[];
    var octet = extData as ASN1OctetString;
    var sanParser = ASN1Parser(octet.valueBytes);
    var sanSeq = sanParser.nextObject() as ASN1Sequence;
    sanSeq.elements!.forEach((ASN1Object san) {
      if (san.tag == 135) {
        var sb = StringBuffer();
        if (san.valueByteLength == 16) {
          //IPv6
          for (var i = 0; i < (san.valueByteLength ?? 0); i++) {
            if (sb.isNotEmpty && i % 2 == 0) {
              sb.write(':');
            }
            sb.write(san.valueBytes![i].toRadixString(16).padLeft(2, '0'));
          }
        } else {
          //IPv4 and others
          san.valueBytes!.forEach((int b) {
            if (sb.isNotEmpty) {
              sb.write('.');
            }
            sb.write(b);
          });
        }
        sans.add(sb.toString());
      } else if (san.tag == 164) {
        // WE HAVE CONSTRUCTED SAN
        var constructedParser = ASN1Parser(san.valueBytes);
        var seq = constructedParser.nextObject() as ASN1Sequence;
        var sanValue = 'DirName:';
        seq.elements!.forEach((ASN1Object san) {
          var set = san as ASN1Set;
          var seq = set.elements!.elementAt(0) as ASN1Sequence;
          var oid = seq.elements!.elementAt(0) as ASN1ObjectIdentifier;
          var object = seq.elements!.elementAt(1);
          var value = '';
          sanValue = sanValue + '/';
          if (object is ASN1UTF8String) {
            var objectAsUtf8 = object;
            value = objectAsUtf8.utf8StringValue!;
          } else if (object is ASN1PrintableString) {
            var objectPrintable = object;
            value = objectPrintable.stringValue!;
          }
          sanValue = sanValue + '${oid.readableName}=$value';
        });
        sans.add(sanValue);
      } else {
        var s = String.fromCharCodes(san.valueBytes!);
        sans.add(s);
      }
    });
    return sans;
  }

  ///
  /// Fetches the base64 encoded VMC logo from the given [extData]
  ///
  static VmcData _fetchVmcLogo(ASN1Object extData) {
    var octet = extData as ASN1OctetString;
    var vmcParser = ASN1Parser(octet.valueBytes);
    var topSeq = vmcParser.nextObject() as ASN1Sequence;
    var obj1 = topSeq.elements!.elementAt(0);
    var obj1Parser = ASN1Parser(obj1.valueBytes);
    var obj2 = obj1Parser.nextObject();
    var obj2Parser = ASN1Parser(obj2.valueBytes);
    var obj2Seq = obj2Parser.nextObject() as ASN1Sequence;
    var nextSeq = obj2Seq.elements!.elementAt(0) as ASN1Sequence;
    var finalSeq = nextSeq.elements!.elementAt(0) as ASN1Sequence;

    var data = VmcData();
    // Parse fileType
    var ia5 = finalSeq.elements!.elementAt(0) as ASN1IA5String;
    var fileType = ia5.stringValue!;

    // Parse hash
    var hashSeq = finalSeq.elements!.elementAt(1) as ASN1Sequence;
    var hasFinalSeq = hashSeq.elements!.elementAt(0) as ASN1Sequence;
    var algSeq = hasFinalSeq.elements!.elementAt(0) as ASN1Sequence;
    var oi = algSeq.elements!.elementAt(0) as ASN1ObjectIdentifier;
    data.hashAlgorithm = oi.objectIdentifierAsString;
    data.hashAlgorithmReadable = oi.readableName;
    var octetString = hasFinalSeq.elements!.elementAt(1) as ASN1OctetString;
    var hash = _bytesAsString(octetString.octets!);
    data.hash = hash;

    // Parse base64 logo
    var logoSeq = finalSeq.elements!.elementAt(2) as ASN1Sequence;
    var ia5Logo = logoSeq.elements!.elementAt(0) as ASN1IA5String;
    var base64LogoGzip = ia5Logo.stringValue;
    var gzip = base64LogoGzip!.substring(base64LogoGzip.indexOf(',') + 1);
    final decoded_data = GZipCodec().decode(base64.decode(gzip));
    var base64Logo = base64.encode(decoded_data);

    data.base64Logo = base64Logo;
    data.type = fileType;

    return data;
  }

  ///
  /// Converts the bytes to a hex string
  ///
  static String _bytesAsString(Uint8List bytes) {
    var b = StringBuffer();
    bytes.forEach((v) {
      var s = v.toRadixString(16);
      if (s.length == 1) {
        b.write('0$s');
      } else {
        b.write(s);
      }
    });
    return b.toString().toUpperCase();
  }

  ///
  /// Converts the hex string to bytes
  ///
  static Uint8List _stringAsBytes(String s) {
    var list = StringUtils.chunk(s, 2);
    var bytes = <int>[];
    for (var e in list) {
      bytes.add(int.parse(e, radix: 16));
    }
    return Uint8List.fromList(bytes);
  }

  ///
  /// Parses the given CSR [pem] to [CertificateSigningRequestData] object
  ///
  static CertificateSigningRequestData csrFromPem(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    var infoSeq = topLevelSeq.elements!.elementAt(0) as ASN1Sequence;
    var sigSeq = topLevelSeq.elements!.elementAt(1) as ASN1Sequence;
    var sig = topLevelSeq.elements!.elementAt(2) as ASN1BitString;

    // Get version
    var asn1Version = infoSeq.elements!.elementAt(0) as ASN1Integer;

    // Get Subject
    var subjectSequence = infoSeq.elements!.elementAt(1) as ASN1Sequence;
    var subject = <String, String>{};
    for (var s in subjectSequence.elements as dynamic) {
      var setSequence = s.elements!.elementAt(0) as ASN1Sequence;
      var o = setSequence.elements!.elementAt(0) as ASN1ObjectIdentifier;
      var object = setSequence.elements!.elementAt(1);
      String? value = '';
      if (object is ASN1UTF8String) {
        var objectAsUtf8 = object;
        value = objectAsUtf8.utf8StringValue;
      } else if (object is ASN1PrintableString) {
        var objectPrintable = object;
        value = objectPrintable.stringValue;
      }
      var identifier = o.objectIdentifierAsString ?? 'unknown';
      subject.putIfAbsent(identifier, () => value!);
    }

    // Get Public Key Data
    var pubSeq = infoSeq.elements!.elementAt(2) as ASN1Sequence;
    var algSeq = pubSeq.elements!.elementAt(0) as ASN1Sequence;
    var algOi = algSeq.elements!.elementAt(0) as ASN1ObjectIdentifier;
    var asn1AlgParameters = algSeq.elements!.elementAt(1);
    var algParameters = '';
    var algParametersReadable = '';
    if (asn1AlgParameters is ASN1ObjectIdentifier) {
      algParameters = asn1AlgParameters.objectIdentifierAsString!;
      algParametersReadable = asn1AlgParameters.readableName!;
    }

    var pubBitString = pubSeq.elements!.elementAt(1) as ASN1BitString;
    var asn1PubKeyParser = ASN1Parser(pubBitString.stringValues as Uint8List?);
    var next;
    try {
      next = asn1PubKeyParser.nextObject();
    } catch (e) {
      // continue
    }
    int pubKeyLength;
    int? exponent;
    var pubKeyAsBytes = pubSeq.encodedBytes;
    if (next != null && next is ASN1Sequence) {
      var s = next;
      var key = s.elements!.elementAt(0) as ASN1Integer;
      if (s.elements!.length == 2 && s.elements!.elementAt(1) is ASN1Integer) {
        var asn1Exponent = s.elements!.elementAt(1) as ASN1Integer;
        exponent = asn1Exponent.integer!.toInt();
      }
      pubKeyLength = key.integer!.bitLength;
      //pubKeyAsBytes = s.encodedBytes;
    } else {
      //pubKeyAsBytes = pubBitString.valueBytes;
      var length = pubBitString.valueBytes!.elementAt(0) == 0
          ? (pubBitString.valueByteLength! - 1)
          : pubBitString.valueByteLength;
      pubKeyLength = length! * 8;
    }

    var pubKeyThumbprint =
        CryptoUtils.getHash(pubSeq.encodedBytes!, algorithmName: 'SHA-1');
    var pubKeySha256Thumbprint =
        CryptoUtils.getHash(pubSeq.encodedBytes!, algorithmName: 'SHA-256');

    var pubInfo = SubjectPublicKeyInfo(
      algorithm: algOi.objectIdentifierAsString,
      algorithmReadableName: algOi.readableName,
      parameter: algParameters != '' ? algParameters : null,
      parameterReadableName:
          algParametersReadable != '' ? algParametersReadable : null,
      length: pubKeyLength,
      bytes: _bytesAsString(pubKeyAsBytes!),
      sha1Thumbprint: pubKeyThumbprint,
      sha256Thumbprint: pubKeySha256Thumbprint,
      exponent: exponent,
    );

    // Get Signature Algorithm
    var pubKeyOid = sigSeq.elements!.elementAt(0) as ASN1ObjectIdentifier;

    // Get Signature
    var sigAsString = _bytesAsString(sig.valueBytes!);

    // Get Extensions
    var extensions;
    if (infoSeq.elements!.length == 4) {
      var extensionObject = infoSeq.elements!.elementAt(3);
      if (extensionObject.valueByteLength != 0) {
        List<String>? sans;
        extensions = CertificateSigningRequestExtensions();
        var extParser = ASN1Parser(extensionObject.valueBytes);
        while (extParser.hasNext()) {
          var outerExtSequence = extParser.nextObject() as ASN1Sequence;
          var oid =
              outerExtSequence.elements!.elementAt(0) as ASN1ObjectIdentifier;
          // Search for extensionRequest OID
          if (oid.objectIdentifierAsString == '1.2.840.113549.1.9.14') {
            var extSet = outerExtSequence.elements!.elementAt(1) as ASN1Set;
            var extSequence = extSet.elements!.elementAt(0) as ASN1Sequence;
            extSequence.elements!.forEach((ASN1Object subseq) {
              var seq = subseq as ASN1Sequence;
              var oi = seq.elements!.elementAt(0) as ASN1ObjectIdentifier;
              if (oi.objectIdentifierAsString == '2.5.29.17') {
                if (seq.elements!.length == 3) {
                  sans = _fetchSansFromExtension(seq.elements!.elementAt(2));
                } else {
                  sans = _fetchSansFromExtension(seq.elements!.elementAt(1));
                }
                extensions.subjectAlternativNames = sans;
              }
            });
          }
        }
      }
    }

    return CertificateSigningRequestData(
      version: asn1Version.integer!.toInt(),
      subject: subject,
      signatureAlgorithm: pubKeyOid.objectIdentifierAsString,
      signatureAlgorithmReadableName: pubKeyOid.readableName,
      signature: sigAsString,
      publicKeyInfo: pubInfo,
      plain: pem,
      extensions: extensions,
    );
  }

  ///
  /// Builds a OCSPRquest out of the given [pem] and [intermediate].
  ///
  /// If the given [pem] represents a PKCS7 certificate, the [intermediate] is not needed.
  ///
  /// Will return an ASN1Sequence that represents the OCSPRquest.
  ///
  /// ```
  /// OCSPRequest     ::=     SEQUENCE {
  ///     tbsRequest                  TBSRequest
  /// }
  ///
  /// TBSRequest      ::=     SEQUENCE {
  ///     version             [0]     EXPLICIT Version DEFAULT v1,
  ///     requestList                 SEQUENCE OF Request
  /// }
  ///
  /// Request         ::=     SEQUENCE {
  ///     reqCert                     CertID
  /// }
  ///
  /// CertID          ::=     SEQUENCE {
  ///     hashAlgorithm       AlgorithmIdentifier,
  ///     issuerNameHash      OCTET STRING, -- Hash of issuer's DN
  ///     issuerKeyHash       OCTET STRING, -- Hash of issuer's public key
  ///     serialNumber        CertificateSerialNumber
  /// }
  /// ```
  ///
  static ASN1Sequence buildOCSPRequest(String pem, {String? intermediate}) {
    var x509Sequence;
    var x509;
    var x509SequenceIssuer;
    if (pem.startsWith(BEGIN_PKCS7)) {
      // We have a PKCS7 PEM, parse END and INTERMEDIATE certificate
      var bytes = CryptoUtils.getBytesFromPEMString(pem);
      var asn1Parser = ASN1Parser(bytes);
      var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
      if (topLevelSeq.elements != null) {
        var obj = topLevelSeq.elements!.elementAt(1);
        var seq = ASN1Sequence.fromBytes(obj.valueBytes!);
        var obj1 = seq.elements!.elementAt(3);
        var seq1 = ASN1Sequence.fromBytes(obj1.encodedBytes!);
        x509Sequence = seq1.elements!.elementAt(0) as ASN1Sequence;
        x509 = _x509FromAsn1Sequence(x509Sequence);
        x509SequenceIssuer = seq1.elements!.elementAt(1) as ASN1Sequence;
      }
    } else {
      if (intermediate == null) {
        throw ArgumentError('Argument intermediate is missing');
      }
      x509Sequence = _getASN1SequenceFromPem(pem);
      x509 = x509CertificateFromPem(pem);
      x509SequenceIssuer = _getASN1SequenceFromPem(intermediate);
    }

    var tbsRequest = ASN1Sequence();
    var requestList = ASN1Sequence();

    var request = ASN1Sequence();
    var certID = ASN1Sequence();

    // AlgorithmIdentifier
    var hashAlgorithm = ASN1Sequence();
    hashAlgorithm
        .add(ASN1ObjectIdentifier.fromIdentifierString('1.3.14.3.2.26'));
    hashAlgorithm.add(ASN1Null());
    certID.add(hashAlgorithm);

    // OCTET STRING, -- Hash of issuer's DN
    var issuer = _getIssuerSequence(x509Sequence);
    var isserHashString = Digest('SHA-1').process(issuer.encode());
    var issuerHash = ASN1OctetString(octets: isserHashString);
    certID.add(issuerHash);

    // OCTET STRING, -- Hash of issuer's public key
    var pubBit = _getPublicKeyBitString(x509SequenceIssuer);
    var bitsToUse = pubBit.valueBytes!.first == 0
        ? pubBit.valueBytes!.sublist(1)
        : pubBit.valueBytes!;
    var pubHashString = Digest('SHA-1').process(bitsToUse);
    var issuerKeyHash = ASN1OctetString(octets: pubHashString);
    certID.add(issuerKeyHash);

    // CertificateSerialNumber
    certID.add(ASN1Integer(x509.serialNumber));

    request.add(certID);
    requestList.add(request);

    //tbsRequest.add(ASN1Integer.fromtInt(0));
    tbsRequest.add(requestList);

    var ocspRequest = ASN1Sequence();
    ocspRequest.add(tbsRequest);
    return ocspRequest;
  }

  ///
  /// Converts the given [pem] to ASN1Sequence;
  ///
  static ASN1Sequence _getASN1SequenceFromPem(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    return topLevelSeq;
  }

  ///
  /// Fetches the issuer ASN1Sequence
  ///
  static ASN1Sequence _getIssuerSequence(ASN1Sequence topLevelSeq) {
    var dataSequence = topLevelSeq.elements!.elementAt(0) as ASN1Sequence;
    var element = 0;
    if (dataSequence.elements!.elementAt(0) is ASN1Integer) {
      // The version ASN1Object is missing use version
      element = -1;
    }
    var issuerSequence =
        dataSequence.elements!.elementAt(element + 3) as ASN1Sequence;
    return issuerSequence;
  }

  ///
  /// Fetches the public key ASN1BitString
  ///
  static ASN1BitString _getPublicKeyBitString(ASN1Sequence topLevelSeq) {
    var dataSequence = topLevelSeq.elements!.elementAt(0) as ASN1Sequence;
    var element = 0;
    if (dataSequence.elements!.elementAt(0) is ASN1Integer) {
      // The version ASN1Object is missing use version
      element = -1;
    }
    // Public Key
    var pubKeySequence =
        dataSequence.elements!.elementAt(element + 6) as ASN1Sequence;

    var pubKey = pubKeySequence.elements!.elementAt(1) as ASN1BitString;
    return pubKey;
  }

  ///
  /// Fetches the OSCP url for the given certificate as [pem]. Supporting X509 and PKCS7 PEMs.
  ///
  /// Will return an empty string if no url is found
  ///
  static String getOCSPUrl(String pem) {
    var topLevelSeq;

    if (pem.startsWith(BEGIN_PKCS7)) {
      // We have a PKCS7 PEM, parse END certificate
      var bytes = CryptoUtils.getBytesFromPEMString(pem);
      var asn1Parser = ASN1Parser(bytes);
      var top = asn1Parser.nextObject() as ASN1Sequence;
      if (top.elements != null) {
        var obj = top.elements!.elementAt(1);
        var seq = ASN1Sequence.fromBytes(obj.valueBytes!);
        var obj1 = seq.elements!.elementAt(3);
        var seq1 = ASN1Sequence.fromBytes(obj1.encodedBytes!);
        topLevelSeq = seq1.elements!.elementAt(0) as ASN1Sequence;
      }
    } else {
      topLevelSeq = _getASN1SequenceFromPem(pem);
    }
    var dataSequence = topLevelSeq.elements!.elementAt(0) as ASN1Sequence;

    var element = 0;
    if (dataSequence.elements!.elementAt(0) is ASN1Integer) {
      // The version ASN1Object is missing
      element = -1;
    }
    if (dataSequence.elements!.length == 8) {
      var extensionObject = dataSequence.elements!.elementAt(element + 7);
      var extParser = ASN1Parser(extensionObject.valueBytes);
      var extSequence = extParser.nextObject() as ASN1Sequence;

      for (var subseq in extSequence.elements!) {
        var seq = subseq as ASN1Sequence;
        var oi = seq.elements!.elementAt(0) as ASN1ObjectIdentifier;
        if (oi.objectIdentifierAsString == '1.3.6.1.5.5.7.1.1') {
          var octet = seq.elements!.elementAt(1) as ASN1OctetString;
          var sanParser = ASN1Parser(octet.valueBytes);
          var authorityInfoAccessSeq = sanParser.nextObject() as ASN1Sequence;
          for (var sub in authorityInfoAccessSeq.elements!) {
            var seq = sub as ASN1Sequence;
            var oi = seq.elements!.elementAt(0) as ASN1ObjectIdentifier;
            if (oi.objectIdentifierAsString == '1.3.6.1.5.5.7.48.1') {
              var asn1 = seq.elements!.elementAt(1);
              var bit = ASN1IA5String.fromBytes(asn1.encodedBytes!);
              return bit.stringValue!;
            }
          }
        }
      }
    }

    return '';
  }

  ///
  /// Parses an OCSPResponse from the given [bytes] received by an OCSP responder.
  ///
  /// Will return [OCSPResponse]
  ///
  static OCSPResponse parseOCSPResponse(Uint8List bytes) {
    var parser = ASN1Parser(bytes);
    var topLevel = parser.nextObject() as ASN1Sequence;
    var responseStatus = topLevel.elements!.elementAt(0) as ASN1Integer;
    var v = responseStatus.integer!.toInt();

    var ocspResponseStatus = _getOCSPResponseStatus(v);
    var basicOcspResponse;
    if (topLevel.elements!.length == 2) {
      basicOcspResponse =
          _getBasicOCSPResponse(topLevel.elements!.elementAt(1));
    }

    return OCSPResponse(
      ocspResponseStatus,
      basicOCSPResponse: basicOcspResponse,
    );
  }

  static OCSPResponseStatus _getOCSPResponseStatus(int i) {
    switch (i) {
      case 0:
        return OCSPResponseStatus.SUCCESSFUL;
      case 1:
        return OCSPResponseStatus.MALFORMED_REQUEST;
      case 2:
        return OCSPResponseStatus.INTERNAL_ERROR;
      case 3:
        return OCSPResponseStatus.TRY_LATER;
      case 5:
        return OCSPResponseStatus.SIG_REQUIRED;
      case 6:
        return OCSPResponseStatus.UNAUTHORIZED;
    }
    return OCSPResponseStatus.TRY_LATER;
  }

  static BasicOCSPResponse _getBasicOCSPResponse(ASN1Object elementAt) {
    var parser = ASN1Parser(elementAt.valueBytes);
    var topLevel = parser.nextObject() as ASN1Sequence;
    var octet = topLevel.elements!.elementAt(1) as ASN1OctetString;

    parser = ASN1Parser(octet.valueBytes);
    topLevel = parser.nextObject() as ASN1Sequence;
    var tbsResponseDataSeq = topLevel.elements!.elementAt(0) as ASN1Sequence;

    ASN1Sequence singleResponseDataSeq;

    if (tbsResponseDataSeq.elements!.length == 3) {
      singleResponseDataSeq =
          tbsResponseDataSeq.elements!.elementAt(2) as ASN1Sequence;
    } else {
      singleResponseDataSeq =
          tbsResponseDataSeq.elements!.elementAt(3) as ASN1Sequence;
    }
    var singleResponses = <OCSPSingleResponse>[];
    // Loop over each singleResponseData
    for (var el in singleResponseDataSeq.elements!) {
      var element = el as ASN1Sequence;
      var certStatus = element.elements!.elementAt(1);
      var ocspCertStatus = OCSPCertStatus();
      if (certStatus.valueByteLength == 0) {
        ocspCertStatus.status = OCSPCertStatusValues.GOOD;
      } else if (certStatus.tag == 161) {
        ocspCertStatus.status = OCSPCertStatusValues.REVOKED;
        var time = ASN1GeneralizedTime.fromBytes(certStatus.valueBytes!);
        ocspCertStatus.revocationTime = time.dateTimeValue;
      } else {
        ocspCertStatus.status = OCSPCertStatusValues.UNKNOWN;
      }
      var updateTime = element.elements!.elementAt(2) as ASN1GeneralizedTime;
      var single =
          OCSPSingleResponse(ocspCertStatus, updateTime.dateTimeValue!);
      singleResponses.add(single);
    }

    var responseData = OCSPResponseData(singleResponses);

    return BasicOCSPResponse(responseData: responseData);
  }

  ///
  /// Returns the modulus of the given [pem] that represents an RSA CSR.
  ///
  /// This equals the following openssl command:
  /// ```
  /// openssl req -noout -modulus -in FILE.csr
  /// ```
  ///
  static BigInt getModulusFromRSACsrPem(String pem) {
    var data = csrFromPem(pem);
    var bytesString = data.publicKeyInfo!.bytes;

    var bytes = _stringAsBytes(bytesString!);
    var rsaPublicKey = CryptoUtils.rsaPublicKeyFromDERBytes(bytes);

    return rsaPublicKey.modulus!;
  }

  ///
  /// Returns the modulus of the given [pem] that represents an RSA X509 certificate.
  ///
  /// This equals the following openssl command:
  /// ```
  /// openssl x509 -noout -modulus -in FILE.cer
  /// ```
  ///
  static BigInt getModulusFromRSAX509Pem(String pem) {
    var data = x509CertificateFromPem(pem);
    var bytesString = data.publicKeyData.bytes;

    var bytes = _stringAsBytes(bytesString!);
    var parser = ASN1Parser(bytes);
    var next = parser.nextObject() as ASN1Sequence;
    var integer = next.elements!.elementAt(0) as ASN1Integer;
    return integer.integer!;
  }

  ///
  /// Converts the given single [pems] to a PKCS7 pem string according to
  /// <https://datatracker.ietf.org/doc/html/rfc2315>
  ///
  static String pemToPkcs7(List<String> certPems) {
    var outer = ASN1Sequence();
    outer.add(ASN1ObjectIdentifier([1, 2, 840, 113549, 1, 7, 2]));

    var inner = ASN1Sequence();
    inner.add(ASN1Integer.fromtInt(1));
    inner.add(ASN1Set());
    inner.add(
      ASN1Sequence(
        elements: [
          ASN1ObjectIdentifier([1, 2, 840, 113549, 1, 7, 1])
        ],
      ),
    );
    var certs = ASN1Sequence(tag: 0xA0);
    for (var pem in certPems) {
      var bytes = CryptoUtils.getBytesFromPEMString(pem);
      var asn1Parser = ASN1Parser(bytes);
      var top = asn1Parser.nextObject() as ASN1Sequence;
      certs.add(top);
    }
    inner.add(certs);
    var a1 = ASN1Null(tag: 0xA1);
    inner.add(a1);
    inner.add(ASN1Set());
    outer.add(ASN1Sequence(elements: [inner], tag: 0xA0));
    var plain =
        encodeASN1ObjectToPem(outer, BEGIN_PKCS7, END_PKCS7, newLine: '\n');
    return plain;
  }

  ///
  /// Parses the given object identifier values to the internal enum
  ///
  static List<ExtendedKeyUsage> _fetchExtendedKeyUsageFromExtension(
      ASN1Object extData) {
    var extKeyUsage = <ExtendedKeyUsage>[];
    var octet = extData as ASN1OctetString;
    var keyUsageParser = ASN1Parser(octet.valueBytes);
    var keyUsageSeq = keyUsageParser.nextObject() as ASN1Sequence;
    keyUsageSeq.elements!.forEach((ASN1Object oi) {
      if (oi is ASN1ObjectIdentifier) {
        var s = oi.objectIdentifierAsString;
        switch (s) {
          case '1.3.6.1.5.5.7.3.1':
            extKeyUsage.add(ExtendedKeyUsage.SERVER_AUTH);
            break;
          case '1.3.6.1.5.5.7.3.2':
            extKeyUsage.add(ExtendedKeyUsage.CLIENT_AUTH);
            break;
          case '1.3.6.1.5.5.7.3.3':
            extKeyUsage.add(ExtendedKeyUsage.CODE_SIGNING);
            break;
          case '1.3.6.1.5.5.7.3.4':
            extKeyUsage.add(ExtendedKeyUsage.EMAIL_PROTECTION);
            break;
          case '1.3.6.1.5.5.7.3.8':
            extKeyUsage.add(ExtendedKeyUsage.TIME_STAMPING);
            break;
          case '1.3.6.1.5.5.7.3.9':
            extKeyUsage.add(ExtendedKeyUsage.OCSP_SIGNING);
            break;
          case '1.3.6.1.5.5.7.3.31':
            extKeyUsage.add(ExtendedKeyUsage.BIMI);
            break;
          default:
        }
      }
    });
    return extKeyUsage;
  }

  ///
  /// Converts the given [chain] to a list of [X509CertificateData]
  ///
  static List<X509CertificateData> parseChainString(String chain) {
    var certs = parseChainStringAsString(chain);
    var x509 = <X509CertificateData>[];
    for (var c in certs) {
      x509.add(X509Utils.x509CertificateFromPem(c));
    }
    return x509;
  }

  ///
  /// Converts the given [chain] to a list of pem strings.
  ///
  static List<String> parseChainStringAsString(String s) {
    var lines = LineSplitter().convert(s);
    var sb = StringBuffer();
    var certs = <String>[];
    for (var l in lines) {
      if (l.isEmpty) {
        continue;
      }
      if (l != BEGIN_CERT && l != END_CERT) {
        l = l.trim();
      }
      sb.write(l);
      if (l.startsWith(END_CERT)) {
        certs.add(sb.toString());
        sb.clear();
      } else {
        sb.write('\n');
      }
    }
    return certs;
  }

  ///
  ///
  ///
  static CertificateRevokeListeData crlDataFromPem(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    var asn1Parser = ASN1Parser(bytes);
    // TOP LEVEL DATA
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var tbsCertList = topLevelSeq.elements!.elementAt(0) as ASN1Sequence;
    var sigSeq = topLevelSeq.elements!.elementAt(1) as ASN1Sequence;
    var sig = topLevelSeq.elements!.elementAt(2) as ASN1BitString;

    var certificateList = CertificateListData();

    // GET VERSION
    var asn1Version = tbsCertList.elements!.elementAt(0) as ASN1Integer;
    certificateList.version = asn1Version.integer!.toInt();

    // GET SIGNATURE
    var sigSequence = tbsCertList.elements!.elementAt(1) as ASN1Sequence;
    var oid = sigSequence.elements!.elementAt(0) as ASN1ObjectIdentifier;
    certificateList.signatureAlgorithm = oid.objectIdentifierAsString;
    certificateList.signatureAlgorithmReadableName = oid.readableName;

    // GET ISSUER
    var issuerSequence = tbsCertList.elements!.elementAt(2) as ASN1Sequence;
    var issuer = <String, String>{};
    for (var s in issuerSequence.elements as dynamic) {
      var setSequence = s.elements!.elementAt(0) as ASN1Sequence;
      var o = setSequence.elements!.elementAt(0) as ASN1ObjectIdentifier;
      var object = setSequence.elements!.elementAt(1);
      String? value = '';
      if (object is ASN1UTF8String) {
        var objectAsUtf8 = object;
        value = objectAsUtf8.utf8StringValue;
      } else if (object is ASN1PrintableString) {
        var objectPrintable = object;
        value = objectPrintable.stringValue;
      }
      var identifier = o.objectIdentifierAsString ?? 'unknown';
      issuer.putIfAbsent(identifier, () => value!);
    }
    certificateList.issuer = issuer;

    // GET THIS UPDATE
    var thisUpdate = tbsCertList.elements!.elementAt(3) as ASN1UtcTime;
    certificateList.thisUpdate = thisUpdate.time;

    // GET NEXT UPDATE
    var nextUpdate = tbsCertList.elements!.elementAt(4) as ASN1UtcTime;
    certificateList.nextUpdate = nextUpdate.time;

    // GET REVOKED CERTIFICATES
    var rCertificates = <RevokedCertificate>[];
    var revokedCertificates =
        tbsCertList.elements!.elementAt(5) as ASN1Sequence;
    for (var e in revokedCertificates.elements!) {
      var revoked = RevokedCertificate();
      var data = e as ASN1Sequence;
      var asn1Int = data.elements!.elementAt(0) as ASN1Integer;
      revoked.serialNumber = asn1Int.integer!;
      var revokeDate = data.elements!.elementAt(1) as ASN1UtcTime;
      revoked.revocationDate = revokeDate.time;
      if (data.elements!.length > 2) {
        var extensions = CrlEntryExtensionsData();
        var ext = data.elements!.elementAt(2) as ASN1Sequence;
        if (ext.elements!.isNotEmpty) {
          var crlReason = ext.elements!.elementAt(0) as ASN1Sequence;
          var octedString = crlReason.elements!.elementAt(1) as ASN1OctetString;
          var parser = ASN1Parser(octedString.octets);
          var enumerated = parser.nextObject() as ASN1Integer;
          var int = enumerated.integer;
          var crlReasonValue = _crlReasonFromInt(int!);
          extensions.reason = crlReasonValue;
        }
        revoked.extensions = extensions;
      }
      rCertificates.add(revoked);
    }
    certificateList.revokedCertificates = rCertificates;

    // GET EXTENSIONS
    // TODO PARSE

    // GET SIGNATURE ALGORITHM
    var pubKeyOid = sigSeq.elements!.elementAt(0) as ASN1ObjectIdentifier;

    // GET SIGNATURE
    var sigAsString = _bytesAsString(sig.valueBytes!);

    return CertificateRevokeListeData(
      tbsCertList: certificateList,
      signatureAlgorithm: pubKeyOid.objectIdentifierAsString,
      signatureAlgorithmReadableName: pubKeyOid.readableName,
      signature: sigAsString,
    );
  }

  static CrlReason _crlReasonFromInt(BigInt int) {
    switch (int.toInt()) {
      case 0:
        return CrlReason.unspecified;
      case 1:
        return CrlReason.keyCompromise;
      case 2:
        return CrlReason.cACompromise;
      case 3:
        return CrlReason.affiliationChanged;
      case 4:
        return CrlReason.superseded;
      case 5:
        return CrlReason.cessationOfOperation;
      case 6:
        return CrlReason.certificateHold;
      case 8:
        return CrlReason.removeFromCRL;
      case 9:
        return CrlReason.privilegeWithdrawn;
      case 10:
        return CrlReason.aACompromise;
      default:
        return CrlReason.unspecified;
    }
  }

  ///
  /// Converts the given DER encoded CRL to a PEM string with the corresponding
  /// headers. The given [bytes] can be taken directly from a .crl file.
  ///
  static String crlDerToPem(Uint8List bytes) {
    return formatKeyString(base64.encode(bytes), BEGIN_CRL, END_CRL);
  }

  static List<String> _fetchCrlDistributionPoints(ASN1Object extData) {
    var cRLDistributionPoints = <String>[];

    var octet = extData as ASN1OctetString;
    var parser = ASN1Parser(octet.valueBytes);
    var topSeq = parser.nextObject() as ASN1Sequence;
    for (var e in topSeq.elements!) {
      var seq = e as ASN1Sequence;
      var o1 = seq.elements!.elementAt(0);
      var parser = ASN1Parser(o1.valueBytes);
      var o2 = parser.nextObject();
      parser = ASN1Parser(o2.valueBytes);
      var o3 = parser.nextObject();
      var point = String.fromCharCodes(o3.valueBytes!.toList());
      cRLDistributionPoints.add(point);
    }
    return cRLDistributionPoints;
  }
}
