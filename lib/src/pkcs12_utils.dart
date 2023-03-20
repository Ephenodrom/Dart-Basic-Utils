import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

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
    var safeContentsCert = ASN1SafeContents(safeBags);

    // CREATE CONTENT INFO
    var contentInfoCert;
    var contentInfoKey;
    if (certPbe != 'NONE' && pwFormatted != null) {
      var params = ASN1Sequence(
        elements: [
          ASN1OctetString(octets: certSalt),
          ASN1Integer(
            BigInt.from(macIter),
          ),
        ],
      );
      var contentEncryptionAlgorithm = ASN1AlgorithmIdentifier(
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

      var encryptedContentInfo = ASN1EncryptedContentInfo.forData(
          contentEncryptionAlgorithm, encryptedContent);

      var encryptedData = ASN1EncryptedData(encryptedContentInfo);
      contentInfoCert = ASN1ContentInfo.forEncryptedData(encryptedData);
    } else {
      contentInfoCert = ASN1ContentInfo.forData(
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
      var contentEncryptionAlgorithm = ASN1AlgorithmIdentifier(
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

      var safeContentsKey = ASN1SafeContents(safeBagsKey);
      contentInfoKey = ASN1ContentInfo.forData(
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

      var safeContentsKey = ASN1SafeContents(safeBagsKey);

      contentInfoKey = ASN1ContentInfo.forData(
        ASN1OctetString(
          octets: safeContentsKey.encode(),
        ),
      );
    }

    // CREATE AUTHENTICATED SAFE WITH CONTENTINFO ( CERT AND KEY )
    var authSafe = ASN1AuthenticatedSafe([contentInfoCert, contentInfoKey]);

    // WRAP AUTHENTICATED SAFE WITHIN A CONTENTINFO
    var T = ASN1ContentInfo.forData(
      ASN1OctetString(
        octets: authSafe.encode(),
      ),
    );

    // GENERATE HMAC IF PASSWORD IS GIVEN
    ASN1MacData? macData;
    if (password != null) {
      var bytesForHmac = authSafe.encode();

      var pwFormatted =
          formatPkcs12Password(Uint8List.fromList(password.codeUnits));

      var generator = PKCS12ParametersGenerator(Digest(digestAlgorithm));
      generator.init(pwFormatted, salt, macIter);

      var key = generator.generateDerivedMacParameters(20);
      var m = _generateHmac(bytesForHmac, key.key, digestAlgorithm);
      macData = ASN1MacData(
        ASN1DigestInfo(
          m,
          _algorithmIdentifierFromDigest(
            digestAlgorithm,
          ),
        ),
        salt,
        BigInt.from(2048),
      );
    }
    var pfx = ASN1Pfx(
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
    var certBags = <ASN1CertBag>[];
    var safeBags = <ASN1SafeBag>[];

    for (var pem in certificates) {
      certBags.add(ASN1CertBag.fromX509Pem(pem));
    }
    for (var certBag in certBags) {
      var asn1Set = ASN1Set(elements: []);
      asn1Set.add(ASN1Pkcs12Attribute.localKeyID(localKeyId));
      if (friendlyName != null) {
        asn1Set.add(ASN1Pkcs12Attribute.friendlyName(friendlyName));
      }
      safeBags.add(
        ASN1SafeBag.forCertBag(
          certBag,
          bagAttributes: asn1Set,
        ),
      );
    }
    return safeBags;
  }

  static List<ASN1SafeBag> _generateSafeBagsForKey(
      String privateKey, Uint8List localKeyId,
      {String? friendlyName}) {
    late ASN1PrivateKeyInfo privateKeyInfo =
        _getPrivateKeyInfoFromPem(privateKey);

    var safeBagsKey = <ASN1SafeBag>[];
    var asn1Set = ASN1Set(elements: []);
    asn1Set.add(ASN1Pkcs12Attribute.localKeyID(localKeyId));
    if (friendlyName != null) {
      asn1Set.add(ASN1Pkcs12Attribute.friendlyName(friendlyName));
    }
    safeBagsKey.add(
      ASN1SafeBag.forKeyBag(
        ASN1KeyBag(privateKeyInfo),
        bagAttributes: asn1Set,
      ),
    );
    return safeBagsKey;
  }

  static _generateSafeBagsForShroudedKey(
      ASN1Object bagValue, Uint8List localKeyId,
      {String? friendlyName}) {
    var safeBagsKey = <ASN1SafeBag>[];
    var asn1Set = ASN1Set(elements: []);
    asn1Set.add(ASN1Pkcs12Attribute.localKeyID(localKeyId));
    if (friendlyName != null) {
      asn1Set.add(ASN1Pkcs12Attribute.friendlyName(friendlyName));
    }
    safeBagsKey.add(
      ASN1SafeBag.forPkcs8ShroudedKeyBag(
        bagValue,
        bagAttributes: asn1Set,
      ),
    );
    return safeBagsKey;
  }

  static ASN1PrivateKeyInfo _getPrivateKeyInfoFromPem(String pem) {
    late ASN1PrivateKeyInfo privateKeyInfo;
    switch (CryptoUtils.getPrivateKeyType(pem)) {
      case "RSA":
        privateKeyInfo = ASN1PrivateKeyInfo.fromPkcs8RsaPem(pem);
        break;
      case "RSA_PKCS1":
        privateKeyInfo = ASN1PrivateKeyInfo.fromPkcs1RsaPem(pem);
        break;
      case "ECC":
        privateKeyInfo = ASN1PrivateKeyInfo.fromEccPem(pem);
        break;
    }
    return privateKeyInfo;
  }

  static Uint8List _encryptRc2(Uint8List bytesToEncrypt,
      ParametersWithIV generateDerivedParametersWithIV) {
    return _processRc2(bytesToEncrypt, generateDerivedParametersWithIV, true);
  }

  static Uint8List _decryptRc2(Uint8List bytesToDecrypt,
      ParametersWithIV generateDerivedParametersWithIV) {
    return _processRc2(bytesToDecrypt, generateDerivedParametersWithIV, false);
  }

  static Uint8List _processRc2(Uint8List bytes,
      ParametersWithIV generateDerivedParametersWithIV, bool encrypt) {
    var engine = CBCBlockCipher(RC2Engine());
    engine.reset();
    engine.init(encrypt, generateDerivedParametersWithIV);
    var padded = CryptoUtils.addPKCS7Padding(bytes, 8);
    final encryptedContent = Uint8List(padded.length);

    var offset = 0;
    while (offset < padded.length) {
      offset += engine.processBlock(padded, offset, encryptedContent, offset);
    }

    return encryptedContent;
  }

  static Uint8List _encrypt3des(Uint8List bytesToEncrypt,
      ParametersWithIV generateDerivedParametersWithIV) {
    return _process3des(bytesToEncrypt, generateDerivedParametersWithIV, true);
  }

  static Uint8List _decrypt3des(Uint8List bytesToDecrypt,
      ParametersWithIV generateDerivedParametersWithIV) {
    return _process3des(bytesToDecrypt, generateDerivedParametersWithIV, false);
  }

  static Uint8List _process3des(Uint8List bytes,
      ParametersWithIV generateDerivedParametersWithIV, bool encrypt) {
    var engine = CBCBlockCipher(DESedeEngine());
    engine.reset();
    engine.init(encrypt, generateDerivedParametersWithIV);
    Uint8List padded;
    if (encrypt) {
      padded = CryptoUtils.addPKCS7Padding(bytes, 8);
    } else {
      padded = bytes;
    }

    final content = Uint8List(padded.length);

    var offset = 0;
    while (offset < padded.length) {
      offset += engine.processBlock(padded, offset, content, offset);
    }
    if (encrypt) {
      return content;
    } else {
      return CryptoUtils.removePKCS7Padding(content);
    }
  }

  static Uint8List _encryptRc4(
      Uint8List bytesToEncrypt, KeyParameter generateDerivedParameters) {
    return _processRc4(bytesToEncrypt, generateDerivedParameters, true);
  }

  static Uint8List _decryptRc4(
      Uint8List bytesToDecrypt, KeyParameter generateDerivedParameters) {
    return _processRc4(bytesToDecrypt, generateDerivedParameters, false);
  }

  static Uint8List _processRc4(Uint8List bytesToEncrypt,
      KeyParameter generateDerivedParameters, bool encrypt) {
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

  static Uint8List _decrypt(
      Uint8List toDecrypt,
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
        return _decryptRc2(
          toDecrypt,
          pkcs12ParameterGenerator.generateDerivedParametersWithIV(
              5, RC2Engine.BLOCK_SIZE),
        );
      case 'PBE-SHA1-RC2-128':
        return _decryptRc2(
          toDecrypt,
          pkcs12ParameterGenerator.generateDerivedParametersWithIV(
              16, RC2Engine.BLOCK_SIZE),
        );
      case 'PBE-SHA1-RC4-40':
        return _decryptRc4(
          toDecrypt,
          pkcs12ParameterGenerator.generateDerivedParameters(5),
        );
      case 'PBE-SHA1-RC4-128':
        return _decryptRc4(
          toDecrypt,
          pkcs12ParameterGenerator.generateDerivedParameters(16),
        );
      case 'PBE-SHA1-2DES':
        return _decrypt3des(
          toDecrypt,
          pkcs12ParameterGenerator.generateDerivedParametersWithIV(
            16,
            DESedeEngine.BLOCK_SIZE,
          ),
        );
      case 'PBE-SHA1-3DES':
        return _decrypt3des(
          toDecrypt,
          pkcs12ParameterGenerator.generateDerivedParametersWithIV(
            24,
            DESedeEngine.BLOCK_SIZE,
          ),
        );
      default:
        throw ArgumentError('unsupported algorithm $algorithm');
    }
  }

  static ASN1AlgorithmIdentifier _algorithmIdentifierFromDigest(
      String digestAlgorithm) {
    switch (digestAlgorithm) {
      case 'SHA-1':
        return ASN1AlgorithmIdentifier.fromIdentifier('1.3.14.3.2.26');
      case 'SHA-224':
        return ASN1AlgorithmIdentifier.fromIdentifier('2.16.840.1.101.3.4.2.4');
      case 'SHA-256':
        return ASN1AlgorithmIdentifier.fromIdentifier('2.16.840.1.101.3.4.2.1');
      case 'SHA-384':
        return ASN1AlgorithmIdentifier.fromIdentifier('2.16.840.1.101.3.4.2.2');
      case 'SHA-512':
        return ASN1AlgorithmIdentifier.fromIdentifier('2.16.840.1.101.3.4.2.3');
      default:
        return ASN1AlgorithmIdentifier.fromIdentifier('1.3.14.3.2.26');
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

  ///
  ///
  ///
  static List<String> parsePkcs12(
    Uint8List pkcs12, {
    String? password,
  }) {
    Uint8List? pwFormatted;
    if (password != null) {
      pwFormatted =
          formatPkcs12Password(Uint8List.fromList(password.codeUnits));
    }

    var pems = <String>[];
    var parser = ASN1Parser(pkcs12);
    var wrapperSeq = parser.nextObject() as ASN1Sequence;
    var pfx = ASN1Pfx.fromSequence(wrapperSeq);

    var authSafeContent = pfx.authSafe.content as ASN1OctetString;
    parser = ASN1Parser(authSafeContent.valueBytes);
    wrapperSeq = parser.nextObject() as ASN1Sequence;
    if (wrapperSeq.elements == null || wrapperSeq.elements!.isEmpty) {
      // TODO
    }
    for (var e in wrapperSeq.elements!) {
      if (e is ASN1Sequence) {
        if (e.elements == null || e.elements!.isEmpty) {
          // TODO
        }
        var contentInfo = ASN1ContentInfo.fromSequence(e);

        switch (contentInfo.contentType.objectIdentifierAsString) {
          case '1.2.840.113549.1.7.6': // encryptedData
            var encryptedData = ASN1EncryptedData.fromSequence(
                contentInfo.content as ASN1Sequence);
            var encryptedContentInfo = encryptedData.encryptedContentInfo;

            // GET ALGORITHM
            var contentEncryptionAlgorithm =
                encryptedContentInfo.contentEncryptionAlgorithm;
            var encryptionAlgorithm = _algorithmFromOi(
                contentEncryptionAlgorithm.algorithm.objectIdentifierAsString!);
            // GET SALT AND MACITER AND DIGEST ALGORITHM
            Uint8List salt = _getSaltFromAlgorithmParameters(
                contentEncryptionAlgorithm.parameters);
            int macIter = _getMacIterFromAlgorithmParameters(
                contentEncryptionAlgorithm.parameters);
            var digestAlgorithm =
                _getDigestAlgorithmFromEncryptionAlgorithm(encryptionAlgorithm);
            // DECRYPT
            var decryptedContent = _decrypt(
              encryptedContentInfo.encryptedContent!,
              encryptionAlgorithm,
              pwFormatted!,
              salt,
              macIter,
              digestAlgorithm,
            );
            var contentType = encryptedContentInfo.contentType;
            switch (contentType.objectIdentifierAsString) {
              case '1.2.840.113549.1.7.1': // CERTIFICATES
                var safeContents = ASN1SafeContents.fromSequence(
                  ASN1Sequence.fromBytes(decryptedContent),
                );
                safeContents.safeBags.forEach((element) {
                  var pem = _pemFromSafeBag(element);
                  pems.add(pem);
                });
                break;
            }
            print('');
            break;
          case '1.2.840.113549.1.7.1': // data (PKCS #7)

            var safeContents = ASN1SafeContents.fromSequence(
              ASN1Sequence.fromBytes(contentInfo.content!.valueBytes!),
            );
            safeContents.safeBags.forEach((element) {
              var bagValueSeq = element.bagValue as ASN1Sequence;
              switch (element.bagId.objectIdentifierAsString!) {
                case "1.2.840.113549.1.12.10.1.3": // pkcs-12-certBag
                  var seq = element.bagValue as ASN1Sequence;
                  var octet = ASN1OctetString.fromBytes(
                      seq.elements!.elementAt(1).valueBytes!);
                  var asn1o = ASN1Sequence.fromBytes(octet.valueBytes!);
                  pems.insert(
                    0,
                    X509Utils.encodeASN1ObjectToPem(
                      asn1o,
                      X509Utils.BEGIN_CERT,
                      X509Utils.END_CERT,
                    ),
                  );
                  break;
                case "1.2.840.113549.1.12.10.1.2": // pkcs-12-pkcs-8ShroudedKeyBag
                  var contentEncryptionAlgorithm =
                      ASN1AlgorithmIdentifier.fromSequence(
                          bagValueSeq.elements!.elementAt(0) as ASN1Sequence);
                  // GET ALGORITHM
                  var encryptionAlgorithm = _algorithmFromOi(
                      contentEncryptionAlgorithm
                          .algorithm.objectIdentifierAsString!);
                  // GET SALT AND MACITER AND DIGEST ALGORITHM
                  Uint8List salt = _getSaltFromAlgorithmParameters(
                      contentEncryptionAlgorithm.parameters);
                  int macIter = _getMacIterFromAlgorithmParameters(
                      contentEncryptionAlgorithm.parameters);
                  var digestAlgorithm =
                      _getDigestAlgorithmFromEncryptionAlgorithm(
                          encryptionAlgorithm);
                  // DECRYPT
                  var decryptedContent = _decrypt(
                    bagValueSeq.elements!.elementAt(1).valueBytes!,
                    encryptionAlgorithm,
                    pwFormatted!,
                    salt,
                    macIter,
                    digestAlgorithm,
                  );
                  var s = ASN1Sequence.fromBytes(decryptedContent);
                  pems.insert(
                    0,
                    X509Utils.encodeASN1ObjectToPem(
                        s,
                        CryptoUtils.BEGIN_PRIVATE_KEY,
                        CryptoUtils.END_PRIVATE_KEY),
                  ); // TODO ECC ?
                  break;
                case "1.2.840.113549.1.12.10.1.1": // pkcs-12-keyBag
                  var seq = bagValueSeq.elements!.elementAt(1) as ASN1Sequence;
                  var identifier =
                      seq.elements!.elementAt(0) as ASN1ObjectIdentifier;
                  switch (identifier.objectIdentifierAsString!) {
                    case "1.2.840.113549.1.1.1": // rsaEncryption
                      pems.insert(
                        0,
                        X509Utils.encodeASN1ObjectToPem(
                            bagValueSeq,
                            CryptoUtils.BEGIN_PRIVATE_KEY,
                            CryptoUtils.END_PRIVATE_KEY),
                      );
                      break;
                  }
                  break;
              }
            });

            break;
        }
      }
    }
    return pems;
  }

  static String _algorithmFromOi(String keyPbe) {
    switch (keyPbe) {
      case '1.2.840.113549.1.12.1.6':
        return "PBE-SHA1-RC2-40";
      case '1.2.840.113549.1.12.1.5':
        return "PBE-SHA1-RC2-128";
      case '1.2.840.113549.1.12.1.2':
        return "PBE-SHA1-RC4-40";
      case '1.2.840.113549.1.12.1.1':
        return "PBE-SHA1-RC4-128";
      case '1.2.840.113549.1.12.1.4':
        return "PBE-SHA1-2DES";
      case '1.2.840.113549.1.12.1.3':
        return "PBE-SHA1-3DES";
      default:
        throw ArgumentError('unsupported algorithm');
    }
  }

  static String _getDigestAlgorithmFromEncryptionAlgorithm(String keyPbe) {
    switch (keyPbe) {
      case 'PBE-SHA1-RC2-40':
      case 'PBE-SHA1-RC2-128':
      case "PBE-SHA1-RC4-40":
      case "PBE-SHA1-RC4-128":
      case "PBE-SHA1-2DES":
      case 'PBE-SHA1-3DES':
        return "SHA-1";
      default:
        throw ArgumentError('unsupported algorithm');
    }
  }

  static Uint8List _getSaltFromAlgorithmParameters(ASN1Object? parameters) {
    var seq = parameters as ASN1Sequence;
    if (seq.elements != null && seq.elements!.isNotEmpty) {
      var asn1Octet = seq.elements!.elementAt(0) as ASN1OctetString;
      return asn1Octet.valueBytes!;
    }
    return Uint8List.fromList([]);
  }

  static int _getMacIterFromAlgorithmParameters(ASN1Object? parameters) {
    var seq = parameters as ASN1Sequence;
    if (seq.elements != null && seq.elements!.isNotEmpty) {
      var asn1Int = seq.elements!.elementAt(1) as ASN1Integer;
      return asn1Int.integer!.toInt();
    }
    return 1;
  }

  static String _pemFromSafeBag(ASN1SafeBag element) {
    switch (element.bagId.objectIdentifierAsString) {
      case "1.2.840.113549.1.12.10.1.1": // KEYBAG
        break;
      case "1.2.840.113549.1.12.10.1.2": // PKCS-8SHROUDEDKEYBAG
        break;
      case "1.2.840.113549.1.12.10.1.3": // CERTIFICATE
        var seq = element.bagValue as ASN1Sequence;
        var a0 = seq.elements!.elementAt(1);
        var asn1OctetString = ASN1OctetString.fromBytes(a0.valueBytes!);
        var x509Seq = ASN1Sequence.fromBytes(asn1OctetString.valueBytes!);
        return X509Utils.encodeASN1ObjectToPem(
            x509Seq, X509Utils.BEGIN_CERT, X509Utils.END_CERT);
      case "1.2.840.113549.1.12.10.1.4": // CRL
      case "1.2.840.113549.1.12.10.1.5": // SECRET BAG
      case "1.2.840.113549.1.12.10.1.6": // SAFECONTENTSBAG
        return "";
    }
    return "";
  }
}
