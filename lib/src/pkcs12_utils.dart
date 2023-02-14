import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/library/crypto/desede_engine.dart';
import 'package:basic_utils/src/library/crypto/rc2_engine.dart';
import 'package:basic_utils/src/library/crypto/rc4_engine.dart';
import 'package:basic_utils/src/model/asn1/pkcs/algorithm_identifier.dart';
import 'package:basic_utils/src/model/asn1/pkcs/attribute.dart';
import 'package:basic_utils/src/model/asn1/pkcs/authenticated_safe.dart';
import 'package:basic_utils/src/model/asn1/pkcs/cert_bag.dart';
import 'package:basic_utils/src/model/asn1/pkcs/content_info.dart';
import 'package:basic_utils/src/model/asn1/pkcs/digest_info.dart';
import 'package:basic_utils/src/model/asn1/pkcs/encrypted_content_info.dart';
import 'package:basic_utils/src/model/asn1/pkcs/encrypted_data.dart';
import 'package:basic_utils/src/model/asn1/pkcs/key_bag.dart';
import 'package:basic_utils/src/model/asn1/pkcs/mac_data.dart';
import 'package:basic_utils/src/model/asn1/pkcs/pfx.dart';
import 'package:basic_utils/src/model/asn1/pkcs/pkcs12_parameter_generator.dart';
import 'package:basic_utils/src/model/asn1/pkcs/private_key_info.dart';
import 'package:basic_utils/src/model/asn1/pkcs/safe_bag.dart';
import 'package:basic_utils/src/model/asn1/pkcs/safe_contents.dart';
import 'package:pointycastle/block/modes/cbc.dart';

class Pkcs12Utils {
  ///
  /// Generates a PKCS12 file according to RFC 7292.
  ///
  /// * privateKey = A private key in PEM format.
  /// * certificates = A list of certificates in PEM format.
  /// * password = The password used for encryption.
  /// * keyPbe = The encryption algorithm used to encrypt the private key.
  /// * certPbe = The encryption algorithm used to encrypt the certificates.
  /// * digetAlgorithm = The digest algorithm used for the mac key derivation
  /// * macIter = The iteration count for the key derivation
  /// * salt = The salt used for the key derivation, if left out, it will be generated
  /// * certSalt = The salt used for the key derivation for cert encryption, if left out salt will be used.
  /// * keySalt = The salt used for the key derivation for key encryption, if left out salt will be used.
  /// * friendlyName =  The name to be used to place as an attribue.
  /// * localKeyId = The id to be used to place as an attribue. If left, it will be generated.
  ///
  /// Possible values for keyPbe and certPbe:
  /// * PBE-SHA1-RC4-128
  /// * PBE-SHA1-RC4-40
  /// * PBE-SHA1-3DES ( default for keyPbe )
  /// * PBE-SHA1-2DES
  /// * PBE-SHA1-RC2-128
  /// * PBE-SHA1-RC2-40 ( default for certPbe)
  ///
  /// Possible values for digestAlgorithm:
  /// * SHA-1 ( DEFAULT)
  /// * SHA-224
  /// * SHA-256
  /// * SHA-384
  /// * SHA-512
  ///
  /// **IMPORTANT:** This method generates a PKCS12 file that only supports PASSWORD PRIVACY and PASSWORD INTEGRITY mode. This
  /// means that the private key and certificates are encrypted with the given password and the HMAC is generated using the given password.
  ///
  /// If keyPbe or certPbe are set to NONE or the password is left out, there will be no encryption.
  /// If the password is left out, no HMAC is generated
  ///
  ///
  static Uint8List generatePkcs12(
    String privateKey,
    List<String> certificates, {
    String? password,
    String keyPbe = 'PBE-SHA1-3DES',
    String certPbe = 'PBE-SHA1-RC2-40',
    String digestAlgorithm = 'SHA-1',
    int macIter = 2048,
    Uint8List? salt,
    Uint8List? certSalt,
    Uint8List? keySalt,
    String? friendlyName,
    Uint8List? localKeyId,
  }) {
    Uint8List? pwFormatted;
    if (password != null) {
      pwFormatted =
          formatPkcs12Password(Uint8List.fromList(password.codeUnits));
    }

    // GENERATE SALT
    if (salt == null) {
      salt = _generateSalt();
    }

    if (certSalt == null) {
      certSalt = salt;
    }

    if (keySalt == null) {
      keySalt = salt;
    }

    // GENERATE LOCAL KEY ID
    if (localKeyId == null) {
      localKeyId = _generateLocalKeyId();
    }

    // CREATE SAFEBAGS WITH PEMS WRAPPED IN CERTBAG
    var safeBags = _generateSafeBagsForCerts(certificates, localKeyId,
        friendlyName: friendlyName);
    var safeContentsCert = SafeContents(safeBags);

    // CREATE CONTENT INFO
    var contentInfoCert;
    var contentInfoKey;
    if (certPbe != 'NONE' && pwFormatted != null) {
      var params = ASN1Sequence(elements: [
        ASN1OctetString(octets: certSalt),
        ASN1Integer(BigInt.from(macIter)),
      ]);
      var contentEncryptionAlgorithm = AlgorithmIdentifier(
        _oiFromAlgorithm(certPbe),
        parameters: params,
      );

      Uint8List encryptedContent = _encrypt(
        safeContentsCert.encode(),
        certPbe,
        pwFormatted,
        certSalt,
        macIter,
        'SHA-1',
      );

      var encryptedContentInfo = EncryptedContentInfo.forData(
          contentEncryptionAlgorithm, encryptedContent);

      var encryptedData = EncryptedData(encryptedContentInfo);
      contentInfoCert = ContentInfo.forEncryptedData(encryptedData);
    } else {
      contentInfoCert = ContentInfo.forData(
        ASN1OctetString(
          octets: safeContentsCert.encode(),
        ),
      );
    }
    if (keyPbe != 'NONE' && pwFormatted != null) {
      var params = ASN1Sequence(elements: [
        ASN1OctetString(octets: keySalt),
        ASN1Integer(BigInt.from(macIter)),
      ]);
      var contentEncryptionAlgorithm = AlgorithmIdentifier(
        _oiFromAlgorithm(keyPbe),
        parameters: params,
      );
      var privateKeyInfo = _getPrivateKeyInfoFromPem(privateKey);
      Uint8List encryptedContent = _encrypt(
        privateKeyInfo.encode(),
        keyPbe,
        pwFormatted,
        keySalt,
        macIter,
        'SHA-1',
      );

      // CREATE SAFEBAG FOR PRIVATEKEY WRAPPED IN KEYBAG
      var safeBagsKey = _generateSafeBagsForShroudedKey(
        ASN1Sequence(elements: [
          contentEncryptionAlgorithm,
          ASN1OctetString(octets: encryptedContent)
        ]),
        localKeyId,
        friendlyName: friendlyName,
      );

      var safeContentsKey = SafeContents(safeBagsKey);
      contentInfoKey = ContentInfo.forData(
        ASN1OctetString(
          octets: safeContentsKey.encode(),
        ),
      );
    } else {
      // CREATE SAFEBAG FOR PRIVATEKEY WRAPPED IN KEYBAG
      var safeBagsKey = _generateSafeBagsForKey(
        privateKey,
        localKeyId,
        friendlyName: friendlyName,
      );

      var safeContentsKey = SafeContents(safeBagsKey);

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

      var pwFormatted =
          formatPkcs12Password(Uint8List.fromList(password.codeUnits));

      var generator = PKCS12ParametersGenerator(Digest(digestAlgorithm));
      generator.init(pwFormatted, salt, macIter);

      var key = generator.generateDerivedMacParameters(20);
      var m = _generateHmac(bytesForHmac, key.key, digestAlgorithm);
      macData = MacData(
        DigestInfo(
          m,
          _algorithmIdentifierFromDigest(
            digestAlgorithm,
          ),
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
    return CryptoUtils.getSecureRandom().nextBytes(20);
  }

  static Uint8List _generateSalt() {
    return CryptoUtils.getSecureRandom().nextBytes(8);
  }

  static Uint8List _generateHmac(
      Uint8List bytesForHmac, Uint8List key, String digestAlgorithm) {
    final hmac = Mac('$digestAlgorithm/HMAC')..init(KeyParameter(key));
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

  static _generateSafeBagsForCerts(
      List<String> certificates, Uint8List localKeyId,
      {String? friendlyName}) {
    var certBags = <CertBag>[];
    var safeBags = <SafeBag>[];

    for (var pem in certificates) {
      certBags.add(CertBag.fromX509Pem(pem));
    }
    for (var certBag in certBags) {
      var asn1Set = ASN1Set(elements: []);
      asn1Set.add(Attribute.localKeyID(localKeyId));
      if (friendlyName != null) {
        asn1Set.add(Attribute.friendlyName(friendlyName));
      }
      safeBags.add(
        SafeBag.forCertBag(
          certBag,
          bagAttributes: asn1Set,
        ),
      );
    }
    return safeBags;
  }

  static List<SafeBag> _generateSafeBagsForKey(
      String privateKey, Uint8List localKeyId,
      {String? friendlyName}) {
    late PrivateKeyInfo privateKeyInfo = _getPrivateKeyInfoFromPem(privateKey);

    var safeBagsKey = <SafeBag>[];
    var asn1Set = ASN1Set(elements: []);
    asn1Set.add(Attribute.localKeyID(localKeyId));
    if (friendlyName != null) {
      asn1Set.add(Attribute.friendlyName(friendlyName));
    }
    safeBagsKey.add(
      SafeBag.forKeyBag(
        KeyBag(privateKeyInfo),
        bagAttributes: asn1Set,
      ),
    );
    return safeBagsKey;
  }

  static _generateSafeBagsForShroudedKey(
      ASN1Object bagValue, Uint8List localKeyId,
      {String? friendlyName}) {
    var safeBagsKey = <SafeBag>[];
    var asn1Set = ASN1Set(elements: []);
    asn1Set.add(Attribute.localKeyID(localKeyId));
    if (friendlyName != null) {
      asn1Set.add(Attribute.friendlyName(friendlyName));
    }
    safeBagsKey.add(
      SafeBag.forPkcs8ShroudedKeyBag(
        bagValue,
        bagAttributes: asn1Set,
      ),
    );
    return safeBagsKey;
  }

  static PrivateKeyInfo _getPrivateKeyInfoFromPem(String pem) {
    late PrivateKeyInfo privateKeyInfo;
    switch (CryptoUtils.getPrivateKeyType(pem)) {
      case "RSA":
        privateKeyInfo = PrivateKeyInfo.fromPkcs8RsaPem(pem);
        break;
      case "RSA_PKCS1":
        privateKeyInfo = PrivateKeyInfo.fromPkcs1RsaPem(pem);
        break;
      case "ECC":
        privateKeyInfo = PrivateKeyInfo.fromEccPem(pem);
        break;
    }
    return privateKeyInfo;
  }

  static Uint8List _encryptRc2(Uint8List bytesToEncrypt,
      ParametersWithIV generateDerivedParametersWithIV) {
    var engine = CBCBlockCipher(RC2Engine());
    engine.reset();
    engine.init(true, generateDerivedParametersWithIV);
    var padded = CryptoUtils.addPKCS7Padding(bytesToEncrypt, 8);
    final encryptedContent = Uint8List(padded.length);

    var offset = 0;
    while (offset < padded.length) {
      offset += engine.processBlock(padded, offset, encryptedContent, offset);
    }

    return encryptedContent;
  }

  static Uint8List _encrypt3des(Uint8List bytesToEncrypt,
      ParametersWithIV generateDerivedParametersWithIV) {
    var engine = CBCBlockCipher(DESedeEngine());
    engine.reset();
    engine.init(true, generateDerivedParametersWithIV);
    var padded = CryptoUtils.addPKCS7Padding(bytesToEncrypt, 8);
    final encryptedContent = Uint8List(padded.length);

    var offset = 0;
    while (offset < padded.length) {
      offset += engine.processBlock(padded, offset, encryptedContent, offset);
    }

    return encryptedContent;
  }

  static Uint8List _encryptRc4(
      Uint8List bytesToEncrypt, KeyParameter generateDerivedParameters) {
    var engine = RC4Engine();
    engine.init(true, generateDerivedParameters);
    engine.reset();
    //var padded = CryptoUtils.addPKCS7Padding(bytesToEncrypt, 8);
    final encryptedContent = engine.process(bytesToEncrypt);

    return encryptedContent;
  }

  static Uint8List _encrypt(
      Uint8List encode,
      String algorithm,
      Uint8List pwFormatted,
      Uint8List salt,
      int macIter,
      String digetAlgorithm) {
    var pkcs12ParameterGenerator =
        PKCS12ParametersGenerator(Digest(digetAlgorithm));
    pkcs12ParameterGenerator.init(pwFormatted, salt, macIter);

    switch (algorithm) {
      case 'PBE-SHA1-RC2-40':
        return _encryptRc2(
          encode,
          pkcs12ParameterGenerator.generateDerivedParametersWithIV(
              5, RC2Engine.BLOCK_SIZE),
        );
      case 'PBE-SHA1-RC2-128':
        return _encryptRc2(
          encode,
          pkcs12ParameterGenerator.generateDerivedParametersWithIV(
              16, RC2Engine.BLOCK_SIZE),
        );
      case 'PBE-SHA1-RC4-40':
        return _encryptRc4(
          encode,
          pkcs12ParameterGenerator.generateDerivedParameters(5),
        );
      case 'PBE-SHA1-RC4-128':
        return _encryptRc4(
          encode,
          pkcs12ParameterGenerator.generateDerivedParameters(16),
        );
      case 'PBE-SHA1-2DES':
        return _encrypt3des(
          encode,
          pkcs12ParameterGenerator.generateDerivedParametersWithIV(
            16,
            DESedeEngine.BLOCK_SIZE,
          ),
        );
      case 'PBE-SHA1-3DES':
        return _encrypt3des(
          encode,
          pkcs12ParameterGenerator.generateDerivedParametersWithIV(
            24,
            DESedeEngine.BLOCK_SIZE,
          ),
        );
      default:
        throw ArgumentError('unsupported algorithm $algorithm');
    }
  }

  static AlgorithmIdentifier _algorithmIdentifierFromDigest(
      String digestAlgorithm) {
    switch (digestAlgorithm) {
      case 'SHA-1':
        return AlgorithmIdentifier.fromIdentifier('1.3.14.3.2.26');
      case 'SHA-224':
        return AlgorithmIdentifier.fromIdentifier('2.16.840.1.101.3.4.2.4');
      case 'SHA-256':
        return AlgorithmIdentifier.fromIdentifier('2.16.840.1.101.3.4.2.1');
      case 'SHA-384':
        return AlgorithmIdentifier.fromIdentifier('2.16.840.1.101.3.4.2.2');
      case 'SHA-512':
        return AlgorithmIdentifier.fromIdentifier('2.16.840.1.101.3.4.2.3');
      default:
        return AlgorithmIdentifier.fromIdentifier('1.3.14.3.2.26');
    }
  }

  static ASN1ObjectIdentifier _oiFromAlgorithm(String keyPbe) {
    switch (keyPbe) {
      case 'PBE-SHA1-RC2-40':
        // 1.2.840.113549.1.12.1.6
        return ASN1ObjectIdentifier.fromBytes(
          Uint8List.fromList(
            HexUtils.decode("06 0A 2A 86 48 86 F7 0D 01 0C 01 06"),
          ),
        );
      case 'PBE-SHA1-RC2-128':
        // 1.2.840.113549.1.12.1.5
        return ASN1ObjectIdentifier.fromBytes(
          Uint8List.fromList(
            HexUtils.decode("06 0A 2A 86 48 86 F7 0D 01 0C 01 05"),
          ),
        );
      case 'PBE-SHA1-RC4-40':
        // 1.2.840.113549.1.12.1.2
        return ASN1ObjectIdentifier.fromBytes(
          Uint8List.fromList(
            HexUtils.decode("06 0A 2A 86 48 86 F7 0D 01 0C 01 02"),
          ),
        );
      case 'PBE-SHA1-RC4-128':
        // 1.2.840.113549.1.12.1.1
        return ASN1ObjectIdentifier.fromBytes(
          Uint8List.fromList(
            HexUtils.decode("06 0A 2A 86 48 86 F7 0D 01 0C 01 01"),
          ),
        );
      case 'PBE-SHA1-2DES':
        // 1.2.840.113549.1.12.1.4
        return ASN1ObjectIdentifier.fromBytes(
          Uint8List.fromList(
            HexUtils.decode("06 0A 2A 86 48 86 F7 0D 01 0C 01 04"),
          ),
        );
      case 'PBE-SHA1-3DES':
        // 1.2.840.113549.1.12.1.3
        return ASN1ObjectIdentifier.fromBytes(
          Uint8List.fromList(
            HexUtils.decode("06 0A 2A 86 48 86 F7 0D 01 0C 01 03"),
          ),
        );
      default:
        throw ArgumentError('unsupported algorithm');
    }
  }
}
