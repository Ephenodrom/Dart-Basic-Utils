import 'dart:typed_data';

import 'package:basic_utils/src/StringUtils.dart';
import 'package:basic_utils/src/model/asn1/pkcs/algorithm_identifier.dart';
import 'package:basic_utils/src/model/asn1/pkcs/attribute.dart';
import 'package:basic_utils/src/model/asn1/pkcs/authenticated_safe.dart';
import 'package:basic_utils/src/model/asn1/pkcs/cert_bag.dart';
import 'package:basic_utils/src/model/asn1/pkcs/content_info.dart';
import 'package:basic_utils/src/model/asn1/pkcs/digest_info.dart';
import 'package:basic_utils/src/model/asn1/pkcs/key_bag.dart';
import 'package:basic_utils/src/model/asn1/pkcs/mac_data.dart';
import 'package:basic_utils/src/model/asn1/pkcs/pfx.dart';
import 'package:basic_utils/src/model/asn1/pkcs/pkcs12_parameter_generator.dart';
import 'package:basic_utils/src/model/asn1/pkcs/private_key_info.dart';
import 'package:basic_utils/src/model/asn1/pkcs/safe_bag.dart';
import 'package:basic_utils/src/model/asn1/pkcs/safe_contents.dart';
import 'package:pointycastle/pointycastle.dart';

class Pkcs12Utils {
  ///
  /// **BETA, NOT INTENDED FOR USAGE, ONLY A PREVIEW**
  ///
  /// Generates a PKCS12 file according to RFC 7292.
  ///
  /// * privateKey = A private key in PEM format.
  /// * certificates = A list of certificates in PEM format.
  /// * password =
  /// * keyPbe = The encryption algorithm used to encrypt the private key.
  /// * certPbe = The encryption algorithm used to encrypt the certificates.
  /// * digetAlgorithm = The digest algorithm used for key derivation
  /// * macIter = The iteration count for the key derivation
  /// * salt = The salt used for the key derivation
  /// * friendlyName =  The name to be used to place as an attribue. If left, it will be generated.
  /// * localKeyId = The id to be used to place as an attribue. If left, it will be generated.
  ///
  /// Possible values :
  /// * keyPbe = RC2-40-CBC (DEFAULT) / RC4 / NONE
  /// * certPbe = DES-EDE3-CBC (DEFAULT) / NONE
  /// * digetAlgorithm = SHA-1 ( DEFAULT) / SHA-224 / SHA-256 / SHA-384 / SHA-512
  ///
  /// **IMPORTANT:** This method generates a PKCS12 file that only supports PASSWORD PRIVACY and PASSWORD INTEGRITY mode. This
  /// means that the private key and certificates are encrypted with the given password and the HMAC is generated using the given password.
  ///
  /// If keyPbe or certPbe are set to NONE or the password is left out, there will be no encryption.
  /// If the password is left out, no HMAC is generated
  ///
  static Uint8List generatePkcs12(
    String privateKey,
    List<String> certificates, {
    String? password,
    String keyPbe = 'NONE',
    String certPbe = 'NONE',
    String digetAlgorithm = 'SHA-1',
    int macIter = 2048,
    Uint8List? salt,
    String? friendlyName,
    Uint8List? localKeyId,
  }) {
    // GENERATE LOCAL KEY ID
    if (localKeyId == null) {
      localKeyId = _generateLocalKeyId();
    }

    // GENERATE FRIENDLY NAME
    if (friendlyName == null) {
      friendlyName = _generateFriendlyName();
    }

    // CREATE SAFEBAGS WITH PEMS WRAPPED IN CERTBAG
    var safeBags =
        _generateSafeBagsForCerts(certificates, localKeyId, friendlyName);
    var safeContentsCert = SafeContents(safeBags);

    // CREATE SAFEBAG FOR PRIVATEKEY WRAPPED IN KEYBAG
    var safeBagsKey =
        _generateSafeBagsForKey(privateKey, localKeyId, friendlyName);

    var safeContentsKey = SafeContents(safeBagsKey);

    // CREATE CONTENT INFO
    var contentInfoCert;
    var contentInfoKey;
    if (certPbe != 'NONE' && password != null) {
      // TODO ENCRYPT CERTS
    } else {
      contentInfoCert = ContentInfo.forData(
        ASN1OctetString(
          octets: safeContentsCert.encode(),
        ),
      );
    }
    if (keyPbe != 'NONE' && password != null) {
      // TODO ENCRYPT PRIVATE KEY
    } else {
      contentInfoKey = ContentInfo.forData(
        ASN1OctetString(
          octets: safeContentsKey.encode(),
        ),
      );
    }

    // CREATE AUTHENTICATED SAFE WITH CONTENTINFO ( CERT AND KEY )
    var authSafe = AuthenticatedSafe([contentInfoCert, contentInfoKey]);

    // WRAP AUTHENTICATED SAFE WITHIN A CONTENTINFO
    var T = ContentInfo.forData(
      ASN1OctetString(
        octets: authSafe.encode(),
      ),
    );

    // GENERATE HMAC IF PASSWORD IS GIVEN
    MacData? macData;
    if (password != null) {
      var bytesForHmac = authSafe.encode();
      if (salt == null) {
        // GENERATE SALT
        salt = _generateSalt();
      }
      var pwFormatted =
          formatPkcs12Password(Uint8List.fromList(password.codeUnits));

      var generator = PKCS12ParametersGenerator(Digest(digetAlgorithm));
      generator.init(pwFormatted, salt, macIter);

      var key = generator.generateDerivedMacParameters(20);
      var m = generateHmac(bytesForHmac, key.key);
      macData = MacData(
        DigestInfo(
          m,
          AlgorithmIdentifier.fromIdentifier(
              '1.3.14.3.2.26'), // TODO TAKE FROM DIGEST
        ),
        salt,
        BigInt.from(2048),
      );
    }
    var pfx = Pfx(
      ASN1Integer(BigInt.from(3)),
      T,
      macData: macData,
    );
    var bytes = pfx.encode();
    return bytes;
  }

  static Uint8List _generateLocalKeyId() {
    return StringUtils.hexToUint8List(
        '4B0BD09492DD36FAB7EAD0D9821068B9C2A60F1E');
  }

  static Uint8List _generateSalt() {
    return StringUtils.hexToUint8List('9E81107F8BAA0D5F');
  }

  static Uint8List generateHmac(Uint8List bytesForHmac, Uint8List key) {
    final hmac = Mac('SHA-1/HMAC')..init(KeyParameter(key));
    var m = hmac.process(bytesForHmac);
    return m;
  }

  ///
  /// Formats the given [password] according to RFC 7292 Appendix B.1
  ///
  static Uint8List formatPkcs12Password(Uint8List password) {
    if (password.isNotEmpty) {
      // +1 for extra 2 pad bytes.
      var bytes = Uint8List((password.length + 1) * 2);

      for (var i = 0; i != password.length; i++) {
        bytes[i * 2] = (password[i] >>> 8);
        bytes[i * 2 + 1] = password[i];
      }

      return bytes;
    } else {
      return Uint8List(0);
    }
  }

  static String _generateFriendlyName() {
    return 'Foo';
  }

  static _generateSafeBagsForCerts(
      List<String> certificates, Uint8List localKeyId, String friendlyName) {
    var certBags = <CertBag>[];
    var safeBags = <SafeBag>[];

    for (var pem in certificates) {
      certBags.add(CertBag.fromX509Pem(pem));
    }
    for (var certBag in certBags) {
      var attribute = Attribute.localKeyID(localKeyId);
      safeBags.add(
        SafeBag.forCertBag(
          certBag,
          bagAttributes: ASN1Set(elements: [attribute]),
        ),
      );
    }
    return safeBags;
  }

  static _generateSafeBagsForKey(
      String privateKey, Uint8List localKeyId, String friendlyName) {
    var safeBagsKey = <SafeBag>[];
    var attribute = Attribute.localKeyID(localKeyId);
    safeBagsKey.add(
      SafeBag.forKeyBag(
        KeyBag(PrivateKeyInfo.fromPkcs1RsaPem(privateKey)),
        bagAttributes: ASN1Set(elements: [attribute]),
      ),
    );
    return safeBagsKey;
  }
}
