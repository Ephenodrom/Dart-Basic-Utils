import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/asn1/object_identifiers.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/src/utils.dart';
import 'package:pointycastle/ecc/ecc_fp.dart' as ecc_fp;

import 'StringUtils.dart';

///
/// Helper class for cryptographic operations
///
class CryptoUtils {
  static const BEGIN_PRIVATE_KEY = '-----BEGIN PRIVATE KEY-----';
  static const END_PRIVATE_KEY = '-----END PRIVATE KEY-----';

  static const BEGIN_PUBLIC_KEY = '-----BEGIN PUBLIC KEY-----';
  static const END_PUBLIC_KEY = '-----END PUBLIC KEY-----';

  static const BEGIN_EC_PRIVATE_KEY = '-----BEGIN EC PRIVATE KEY-----';
  static const END_EC_PRIVATE_KEY = '-----END EC PRIVATE KEY-----';

  static const BEGIN_EC_PUBLIC_KEY = '-----BEGIN EC PUBLIC KEY-----';
  static const END_EC_PUBLIC_KEY = '-----END EC PUBLIC KEY-----';

  static const BEGIN_RSA_PRIVATE_KEY = '-----BEGIN RSA PRIVATE KEY-----';
  static const END_RSA_PRIVATE_KEY = '-----END RSA PRIVATE KEY-----';

  static const BEGIN_RSA_PUBLIC_KEY = '-----BEGIN RSA PUBLIC KEY-----';
  static const END_RSA_PUBLIC_KEY = '-----END RSA PUBLIC KEY-----';

  ///
  /// Converts the [RSAPublicKey.modulus] from the given [publicKey] to a [Uint8List].
  ///
  static Uint8List rsaPublicKeyModulusToBytes(RSAPublicKey publicKey) =>
      encodeBigInt(publicKey.modulus);

  ///
  /// Converts the [RSAPublicKey.exponent] from the given [publicKey] to a [Uint8List].
  ///
  static Uint8List rsaPublicKeyExponentToBytes(RSAPublicKey publicKey) =>
      encodeBigInt(publicKey.exponent);

  ///
  /// Converts the [RSAPrivateKey.modulus] from the given [privateKey] to a [Uint8List].
  ///
  static Uint8List rsaPrivateKeyModulusToBytes(RSAPrivateKey privateKey) =>
      encodeBigInt(privateKey.modulus);

  ///
  /// Converts the [RSAPrivateKey.exponent] from the given [privateKey] to a [Uint8List].
  ///
  static Uint8List rsaPrivateKeyExponentToBytes(RSAPrivateKey privateKey) =>
      encodeBigInt(privateKey.exponent);

  ///
  /// Get a SHA1 Thumbprint for the given [bytes].
  ///
  @Deprecated('Use [getHash]')
  static String getSha1ThumbprintFromBytes(Uint8List bytes) {
    return getHash(bytes, algorithmName: 'SHA-1');
  }

  ///
  /// Get a SHA256 Thumbprint for the given [bytes].
  ///
  @Deprecated('Use [getHash]')
  static String getSha256ThumbprintFromBytes(Uint8List bytes) {
    return getHash(bytes, algorithmName: 'SHA-256');
  }

  ///
  /// Get a MD5 Thumbprint for the given [bytes].
  ///
  @Deprecated('Use [getHash]')
  static String getMd5ThumbprintFromBytes(Uint8List bytes) {
    return getHash(bytes, algorithmName: 'MD5');
  }

  ///
  /// Get a hash for the given [bytes] using the given [algorithm]
  ///
  /// The default [algorithm] used is **SHA-256**. All supported algorihms are :
  ///
  /// * SHA-1
  /// * SHA-224
  /// * SHA-256
  /// * SHA-384
  /// * SHA-512
  /// * SHA-512/224
  /// * SHA-512/256
  /// * MD5
  ///
  static String getHash(Uint8List bytes, {String algorithmName = 'SHA-256'}) {
    var hash = getHashPlain(bytes, algorithmName: algorithmName);

    const hexDigits = '0123456789abcdef';
    var charCodes = Uint8List(hash.length * 2);
    for (var i = 0, j = 0; i < hash.length; i++) {
      var byte = hash[i];
      charCodes[j++] = hexDigits.codeUnitAt((byte >> 4) & 0xF);
      charCodes[j++] = hexDigits.codeUnitAt(byte & 0xF);
    }

    return String.fromCharCodes(charCodes).toUpperCase();
  }

  ///
  /// Get a hash for the given [bytes] using the given [algorithm]
  ///
  /// The default [algorithm] used is **SHA-256**. All supported algorihms are :
  ///
  /// * SHA-1
  /// * SHA-224
  /// * SHA-256
  /// * SHA-384
  /// * SHA-512
  /// * SHA-512/224
  /// * SHA-512/256
  /// * MD5
  ///
  static Uint8List getHashPlain(Uint8List bytes,
      {String algorithmName = 'SHA-256'}) {
    Uint8List hash;
    switch (algorithmName) {
      case 'SHA-1':
        hash = Digest('SHA-1').process(bytes);
        break;
      case 'SHA-224':
        hash = Digest('SHA-224').process(bytes);
        break;
      case 'SHA-256':
        hash = Digest('SHA-256').process(bytes);
        break;
      case 'SHA-384':
        hash = Digest('SHA-384').process(bytes);
        break;
      case 'SHA-512':
        hash = Digest('SHA-512').process(bytes);
        break;
      case 'SHA-512/224':
        hash = Digest('SHA-512/224').process(bytes);
        break;
      case 'SHA-512/256':
        hash = Digest('SHA-512/256').process(bytes);
        break;
      case 'MD5':
        hash = Digest('MD5').process(bytes);
        break;
      default:
        throw ArgumentError('Hash not supported');
    }

    return hash;
  }

  ///
  /// Generates a RSA [AsymmetricKeyPair] with the given [keySize].
  /// The default value for the [keySize] is 2048 bits.
  ///
  /// The following keySize is supported:
  /// * 1024
  /// * 2048
  /// * 4096
  /// * 8192
  ///
  static AsymmetricKeyPair generateRSAKeyPair({int keySize = 2048}) {
    var keyParams =
        RSAKeyGeneratorParameters(BigInt.parse('65537'), keySize, 12);

    var secureRandom = _getSecureRandom();

    var rngParams = ParametersWithRandom(keyParams, secureRandom);
    var generator = RSAKeyGenerator();
    generator.init(rngParams);

    return generator.generateKeyPair();
  }

  ///
  /// Generates a elliptic curve [AsymmetricKeyPair].
  ///
  /// The default curve is **prime256v1**
  ///
  /// The following curves are supported:
  ///
  /// * brainpoolp160r1
  /// * brainpoolp160t1
  /// * brainpoolp192r1
  /// * brainpoolp192t1
  /// * brainpoolp224r1
  /// * brainpoolp224t1
  /// * brainpoolp256r1
  /// * brainpoolp256t1
  /// * brainpoolp320r1
  /// * brainpoolp320t1
  /// * brainpoolp384r1
  /// * brainpoolp384t1
  /// * brainpoolp512r1
  /// * brainpoolp512t1
  /// * GostR3410-2001-CryptoPro-A
  /// * GostR3410-2001-CryptoPro-B
  /// * GostR3410-2001-CryptoPro-C
  /// * GostR3410-2001-CryptoPro-XchA
  /// * GostR3410-2001-CryptoPro-XchB
  /// * prime192v1
  /// * prime192v2
  /// * prime192v3
  /// * prime239v1
  /// * prime239v2
  /// * prime239v3
  /// * prime256v1
  /// * secp112r1
  /// * secp112r2
  /// * secp128r1
  /// * secp128r2
  /// * secp160k1
  /// * secp160r1
  /// * secp160r2
  /// * secp192k1
  /// * secp192r1
  /// * secp224k1
  /// * secp224r1
  /// * secp256k1
  /// * secp256r1
  /// * secp384r1
  /// * secp521r1
  ///
  static AsymmetricKeyPair generateEcKeyPair({String curve = 'prime256v1'}) {
    var ecDomainParameters = ECDomainParameters(curve);
    var keyParams = ECKeyGeneratorParameters(ecDomainParameters);

    var secureRandom = _getSecureRandom();

    var rngParams = ParametersWithRandom(keyParams, secureRandom);
    var generator = ECKeyGenerator();
    generator.init(rngParams);

    return generator.generateKeyPair();
  }

  ///
  /// Generates a secure [FortunaRandom]
  ///
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
  /// Enode the given [publicKey] to PEM format using the PKCS#8 standard.
  ///
  static String encodeRSAPublicKeyToPem(RSAPublicKey publicKey) {
    var algorithmSeq = ASN1Sequence();
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(ASN1ObjectIdentifier.fromName('rsaEncryption'));
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeq = ASN1Sequence();
    publicKeySeq.add(ASN1Integer(publicKey.modulus));
    publicKeySeq.add(ASN1Integer(publicKey.exponent));
    var publicKeySeqBitString =
        ASN1BitString(stringValues: Uint8List.fromList(publicKeySeq.encode()));

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);
    var dataBase64 = base64.encode(topLevelSeq.encode());
    var chunks = StringUtils.chunk(dataBase64, 64);

    return '$BEGIN_PUBLIC_KEY\n${chunks.join('\n')}\n$END_PUBLIC_KEY';
  }

  ///
  /// Enode the given [rsaPublicKey] to PEM format using the PKCS#1 standard.
  ///
  /// The ASN1 structure is decripted at <https://tools.ietf.org/html/rfc8017#page-53>.
  ///
  /// ```
  /// RSAPublicKey ::= SEQUENCE {
  ///   modulus           INTEGER,  -- n
  ///   publicExponent    INTEGER   -- e
  /// }
  /// ```
  ///
  static String encodeRSAPublicKeyToPemPkcs1(RSAPublicKey rsaPublicKey) {
    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(ASN1Integer(rsaPublicKey.modulus));
    topLevelSeq.add(ASN1Integer(rsaPublicKey.exponent));

    var dataBase64 = base64.encode(topLevelSeq.encode());
    var chunks = StringUtils.chunk(dataBase64, 64);

    return '$BEGIN_RSA_PUBLIC_KEY\n${chunks.join('\n')}\n$END_RSA_PUBLIC_KEY';
  }

  ///
  /// Enode the given [rsaPrivateKey] to PEM format using the PKCS#1 standard.
  ///
  /// The ASN1 structure is decripted at <https://tools.ietf.org/html/rfc8017#page-54>.
  ///
  /// ```
  /// RSAPrivateKey ::= SEQUENCE {
  ///   version           Version,
  ///   modulus           INTEGER,  -- n
  ///   publicExponent    INTEGER,  -- e
  ///   privateExponent   INTEGER,  -- d
  ///   prime1            INTEGER,  -- p
  ///   prime2            INTEGER,  -- q
  ///   exponent1         INTEGER,  -- d mod (p-1)
  ///   exponent2         INTEGER,  -- d mod (q-1)
  ///   coefficient       INTEGER,  -- (inverse of q) mod p
  ///   otherPrimeInfos   OtherPrimeInfos OPTIONAL
  /// }
  /// ```
  static String encodeRSAPrivateKeyToPemPkcs1(RSAPrivateKey rsaPrivateKey) {
    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(rsaPrivateKey.n);
    var publicExponent = ASN1Integer(BigInt.parse('65537'));
    var privateExponent = ASN1Integer(rsaPrivateKey.privateExponent);

    var p = ASN1Integer(rsaPrivateKey.p);
    var q = ASN1Integer(rsaPrivateKey.q);
    var dP =
        rsaPrivateKey.privateExponent! % (rsaPrivateKey.p! - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ =
        rsaPrivateKey.privateExponent! % (rsaPrivateKey.q! - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = rsaPrivateKey.q!.modInverse(rsaPrivateKey.p!);
    var co = ASN1Integer(iQ);

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(modulus);
    topLevelSeq.add(publicExponent);
    topLevelSeq.add(privateExponent);
    topLevelSeq.add(p);
    topLevelSeq.add(q);
    topLevelSeq.add(exp1);
    topLevelSeq.add(exp2);
    topLevelSeq.add(co);
    var dataBase64 = base64.encode(topLevelSeq.encode());
    var chunks = StringUtils.chunk(dataBase64, 64);
    return '$BEGIN_RSA_PRIVATE_KEY\n${chunks.join('\n')}\n$END_RSA_PRIVATE_KEY';
  }

  ///
  /// Enode the given [rsaPrivateKey] to PEM format using the PKCS#8 standard.
  ///
  /// The ASN1 structure is decripted at <https://tools.ietf.org/html/rfc5208>.
  /// ```
  /// PrivateKeyInfo ::= SEQUENCE {
  ///   version         Version,
  ///   algorithm       AlgorithmIdentifier,
  ///   PrivateKey      BIT STRING
  /// }
  /// ```
  ///
  static String encodeRSAPrivateKeyToPem(RSAPrivateKey rsaPrivateKey) {
    var version = ASN1Integer(BigInt.from(0));

    var algorithmSeq = ASN1Sequence();
    var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var privateKeySeq = ASN1Sequence();
    var modulus = ASN1Integer(rsaPrivateKey.n);
    var publicExponent = ASN1Integer(BigInt.parse('65537'));
    var privateExponent = ASN1Integer(rsaPrivateKey.privateExponent);
    var p = ASN1Integer(rsaPrivateKey.p);
    var q = ASN1Integer(rsaPrivateKey.q);
    var dP =
        rsaPrivateKey.privateExponent! % (rsaPrivateKey.p! - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ =
        rsaPrivateKey.privateExponent! % (rsaPrivateKey.q! - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = rsaPrivateKey.q!.modInverse(rsaPrivateKey.p!);
    var co = ASN1Integer(iQ);

    privateKeySeq.add(version);
    privateKeySeq.add(modulus);
    privateKeySeq.add(publicExponent);
    privateKeySeq.add(privateExponent);
    privateKeySeq.add(p);
    privateKeySeq.add(q);
    privateKeySeq.add(exp1);
    privateKeySeq.add(exp2);
    privateKeySeq.add(co);
    var publicKeySeqOctetString =
        ASN1OctetString(octets: Uint8List.fromList(privateKeySeq.encode()));

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqOctetString);
    var dataBase64 = base64.encode(topLevelSeq.encode());
    var chunks = StringUtils.chunk(dataBase64, 64);
    return '$BEGIN_PRIVATE_KEY\n${chunks.join('\n')}\n$END_PRIVATE_KEY';
  }

  ///
  /// Decode a [RSAPrivateKey] from the given [pem] String.
  ///
  static RSAPrivateKey rsaPrivateKeyFromPem(String pem) {
    var bytes = getBytesFromPEMString(pem);
    return rsaPrivateKeyFromDERBytes(bytes);
  }

  ///
  /// Decode the given [bytes] into an [RSAPrivateKey].
  ///
  static RSAPrivateKey rsaPrivateKeyFromDERBytes(Uint8List bytes) {
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    //ASN1Object version = topLevelSeq.elements[0];
    //ASN1Object algorithm = topLevelSeq.elements[1];
    var privateKey = topLevelSeq.elements![2];

    asn1Parser = ASN1Parser(privateKey.valueBytes);
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    var modulus = pkSeq.elements![1] as ASN1Integer;
    //ASN1Integer publicExponent = pkSeq.elements[2] as ASN1Integer;
    var privateExponent = pkSeq.elements![3] as ASN1Integer;
    var p = pkSeq.elements![4] as ASN1Integer;
    var q = pkSeq.elements![5] as ASN1Integer;
    //ASN1Integer exp1 = pkSeq.elements[6] as ASN1Integer;
    //ASN1Integer exp2 = pkSeq.elements[7] as ASN1Integer;
    //ASN1Integer co = pkSeq.elements[8] as ASN1Integer;

    var rsaPrivateKey = RSAPrivateKey(
        modulus.integer!, privateExponent.integer!, p.integer, q.integer);

    return rsaPrivateKey;
  }

  ///
  /// Decode a [RSAPrivateKey] from the given [pem] string formated in the pkcs1 standard.
  ///
  static RSAPrivateKey rsaPrivateKeyFromPemPkcs1(String pem) {
    var bytes = getBytesFromPEMString(pem);
    return rsaPrivateKeyFromDERBytesPkcs1(bytes);
  }

  ///
  /// Decode the given [bytes] into an [RSAPrivateKey].
  ///
  /// The [bytes] need to follow the the pkcs1 standard
  ///
  static RSAPrivateKey rsaPrivateKeyFromDERBytesPkcs1(Uint8List bytes) {
    var asn1Parser = ASN1Parser(bytes);
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    var modulus = pkSeq.elements![1] as ASN1Integer;
    //ASN1Integer publicExponent = pkSeq.elements[2] as ASN1Integer;
    var privateExponent = pkSeq.elements![3] as ASN1Integer;
    var p = pkSeq.elements![4] as ASN1Integer;
    var q = pkSeq.elements![5] as ASN1Integer;
    //ASN1Integer exp1 = pkSeq.elements[6] as ASN1Integer;
    //ASN1Integer exp2 = pkSeq.elements[7] as ASN1Integer;
    //ASN1Integer co = pkSeq.elements[8] as ASN1Integer;

    var rsaPrivateKey = RSAPrivateKey(
        modulus.integer!, privateExponent.integer!, p.integer, q.integer);

    return rsaPrivateKey;
  }

  ///
  /// Helper function for decoding the base64 in [pem].
  ///
  /// Throws an ArgumentError if the given [pem] is not sourounded by begin marker -----BEGIN and
  /// endmarker -----END or the [pem] consists of less than two lines.
  ///
  static Uint8List getBytesFromPEMString(String pem) {
    var lines = LineSplitter.split(pem)
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.length < 2 ||
        !lines.first.startsWith('-----BEGIN') ||
        !lines.last.startsWith('-----END')) {
      throw ArgumentError('The given string does not have the correct '
          'begin/end markers expected in a PEM file.');
    }
    var base64 = lines.sublist(1, lines.length - 1).join('');
    return Uint8List.fromList(base64Decode(base64));
  }

  ///
  /// Decode a [RSAPublicKey] from the given [pem] String.
  ///
  static RSAPublicKey rsaPublicKeyFromPem(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    return rsaPublicKeyFromDERBytes(bytes);
  }

  ///
  /// Decode the given [bytes] into an [RSAPublicKey].
  ///
  static RSAPublicKey rsaPublicKeyFromDERBytes(Uint8List bytes) {
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var publicKeySeq;
    if (topLevelSeq.elements![1].runtimeType == ASN1BitString) {
      var publicKeyBitString = topLevelSeq.elements![1] as ASN1BitString;

      var publicKeyAsn =
          ASN1Parser(publicKeyBitString.stringValues as Uint8List?);
      publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    } else {
      publicKeySeq = topLevelSeq;
    }
    var modulus = publicKeySeq.elements![0] as ASN1Integer;
    var exponent = publicKeySeq.elements![1] as ASN1Integer;

    var rsaPublicKey = RSAPublicKey(modulus.integer!, exponent.integer!);

    return rsaPublicKey;
  }

  ///
  /// Decode a [RSAPublicKey] from the given [pem] string formated in the pkcs1 standard.
  ///
  static RSAPublicKey rsaPublicKeyFromPemPkcs1(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    return rsaPublicKeyFromDERBytesPkcs1(bytes);
  }

  ///
  /// Decode the given [bytes] into an [RSAPublicKey].
  ///
  /// The [bytes] need to follow the the pkcs1 standard
  ///
  static RSAPublicKey rsaPublicKeyFromDERBytesPkcs1(Uint8List bytes) {
    var publicKeyAsn = ASN1Parser(bytes);
    var publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    var modulus = publicKeySeq.elements![0] as ASN1Integer;
    var exponent = publicKeySeq.elements![1] as ASN1Integer;

    var rsaPublicKey = RSAPublicKey(modulus.integer!, exponent.integer!);
    return rsaPublicKey;
  }

  ///
  /// Enode the given elliptic curve [publicKey] to PEM format.
  ///
  /// This is descripted in <https://tools.ietf.org/html/rfc5915>
  ///
  /// ```ASN1
  /// ECPrivateKey ::= SEQUENCE {
  ///   version        INTEGER { ecPrivkeyVer1(1) } (ecPrivkeyVer1),
  ///   privateKey     OCTET STRING
  ///   parameters [0] ECParameters {{ NamedCurve }} OPTIONAL
  ///   publicKey  [1] BIT STRING OPTIONAL
  /// }
  ///
  /// ```
  ///
  /// As descripted in the mentioned RFC, all optional values will always be set.
  ///
  static String encodeEcPrivateKeyToPem(ECPrivateKey ecPrivateKey) {
    var outer = ASN1Sequence();

    var version = ASN1Integer(BigInt.from(1));
    var privateKeyAsBytes = encodeBigInt(ecPrivateKey.d);
    var privateKey = ASN1OctetString(octets: privateKeyAsBytes);
    var choice = ASN1Sequence(tag: 0xA0);

    choice.add(
        ASN1ObjectIdentifier.fromName(ecPrivateKey.parameters!.domainName));

    var publicKey = ASN1Sequence(tag: 0xA1);

    var subjectPublicKey = ASN1BitString(
        stringValues: ecPrivateKey.parameters!.G.getEncoded(false));
    publicKey.add(subjectPublicKey);

    outer.add(version);
    outer.add(privateKey);
    outer.add(choice);
    outer.add(publicKey);
    var dataBase64 = base64.encode(outer.encode());
    var chunks = StringUtils.chunk(dataBase64, 64);

    return '$BEGIN_EC_PRIVATE_KEY\n${chunks.join('\n')}\n$END_EC_PRIVATE_KEY';
  }

  ///
  /// Enode the given elliptic curve [publicKey] to PEM format.
  ///
  /// This is descripted in <https://tools.ietf.org/html/rfc5480>
  ///
  /// ```ASN1
  /// SubjectPublicKeyInfo  ::=  SEQUENCE  {
  ///     algorithm         AlgorithmIdentifier,
  ///     subjectPublicKey  BIT STRING
  /// }
  /// ```
  ///
  static String encodeEcPublicKeyToPem(ECPublicKey publicKey) {
    var outer = ASN1Sequence();
    var algorithm = ASN1Sequence();
    algorithm.add(ASN1ObjectIdentifier.fromName('ecPublicKey'));
    algorithm.add(ASN1ObjectIdentifier.fromName('prime256v1'));
    var encodedBytes = publicKey.Q!.getEncoded(false);

    var subjectPublicKey = ASN1BitString(stringValues: encodedBytes);

    outer.add(algorithm);
    outer.add(subjectPublicKey);
    var dataBase64 = base64.encode(outer.encode());
    var chunks = StringUtils.chunk(dataBase64, 64);

    return '$BEGIN_EC_PUBLIC_KEY\n${chunks.join('\n')}\n$END_EC_PUBLIC_KEY';
  }

  ///
  /// Decode a [ECPublicKey] from the given [pem] String.
  ///
  /// Throws an ArgumentError if the given string [pem] is null or empty.
  ///
  static ECPublicKey ecPublicKeyFromPem(String pem) {
    if (pem.isEmpty) {
      throw ArgumentError('Argument must not be null.');
    }
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    return ecPublicKeyFromDerBytes(bytes);
  }

  ///
  /// Decode a [ECPrivateKey] from the given [pem] String.
  ///
  /// Throws an ArgumentError if the given string [pem] is null or empty.
  ///
  static ECPrivateKey ecPrivateKeyFromPem(String pem) {
    if (pem.isEmpty) {
      throw ArgumentError('Argument must not be null.');
    }
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    return ecPrivateKeyFromDerBytes(
      bytes,
      pkcs8: pem.startsWith(BEGIN_PRIVATE_KEY),
    );
  }

  ///
  /// Decode the given [bytes] into an [ECPrivateKey].
  ///
  /// [pkcs8] defines the ASN1 format of the given [bytes]. The default is false, so SEC1 is assumed.
  ///
  /// Supports SEC1 (<https://tools.ietf.org/html/rfc5915>) and PKCS8 (<https://datatracker.ietf.org/doc/html/rfc5208>)
  ///
  static ECPrivateKey ecPrivateKeyFromDerBytes(Uint8List bytes,
      {bool pkcs8 = false}) {
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var curveName;
    var x;
    if (pkcs8) {
      // Parse the PKCS8 format
      var innerSeq = topLevelSeq.elements!.elementAt(1) as ASN1Sequence;
      var b2 = innerSeq.elements!.elementAt(1) as ASN1ObjectIdentifier;
      var b2Data = b2.objectIdentifierAsString;
      var b2Curvedata = ObjectIdentifiers.getIdentifierByIdentifier(b2Data);
      if (b2Curvedata != null) {
        curveName = b2Curvedata['readableName'];
      }

      var octetString = topLevelSeq.elements!.elementAt(2) as ASN1OctetString;
      asn1Parser = ASN1Parser(octetString.valueBytes);
      var octetStringSeq = asn1Parser.nextObject() as ASN1Sequence;
      var octetStringKeyData =
          octetStringSeq.elements!.elementAt(1) as ASN1OctetString;

      x = octetStringKeyData.valueBytes!;
    } else {
      // Parse the SEC1 format
      var privateKeyAsOctetString =
          topLevelSeq.elements!.elementAt(1) as ASN1OctetString;
      var choice = topLevelSeq.elements!.elementAt(2);
      var s = ASN1Sequence();
      var parser = ASN1Parser(choice.valueBytes);
      while (parser.hasNext()) {
        s.add(parser.nextObject());
      }
      var curveNameOi = s.elements!.elementAt(0) as ASN1ObjectIdentifier;
      var data = ObjectIdentifiers.getIdentifierByIdentifier(
          curveNameOi.objectIdentifierAsString);
      if (data != null) {
        curveName = data['readableName'];
      }

      x = privateKeyAsOctetString.valueBytes!;
    }

    return ECPrivateKey(decodeBigInt(x), ECDomainParameters(curveName));
  }

  ///
  /// Decode the given [bytes] into an [ECPublicKey].
  ///
  static ECPublicKey ecPublicKeyFromDerBytes(Uint8List bytes) {
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    var algorithmIdentifierSequence = topLevelSeq.elements![0] as ASN1Sequence;
    var curveNameOi = algorithmIdentifierSequence.elements!.elementAt(1)
        as ASN1ObjectIdentifier;
    var curveName;
    var data = ObjectIdentifiers.getIdentifierByIdentifier(
        curveNameOi.objectIdentifierAsString);
    if (data != null) {
      curveName = data['readableName'];
    }

    var subjectPublicKey = topLevelSeq.elements![1] as ASN1BitString;
    var compressed = false;
    var pubBytes = subjectPublicKey.valueBytes!;
    if (pubBytes.elementAt(0) == 0) {
      pubBytes = pubBytes.sublist(1);
    }

    // Looks good so far!
    var firstByte = pubBytes.elementAt(0);
    if (firstByte != 4) {
      compressed = true;
    }
    var x = pubBytes.sublist(1, (pubBytes.length / 2).round());
    var y = pubBytes.sublist(1 + x.length, pubBytes.length);
    var params = ECDomainParameters(curveName);
    var bigX = decodeBigIntWithSign(1, x);
    var bigY = decodeBigIntWithSign(1, y);
    var pubKey = ECPublicKey(
        ecc_fp.ECPoint(
            params.curve as ecc_fp.ECCurve,
            params.curve.fromBigInteger(bigX) as ecc_fp.ECFieldElement?,
            params.curve.fromBigInteger(bigY) as ecc_fp.ECFieldElement?,
            compressed),
        params);
    return pubKey;
  }

  ///
  /// Encrypt the given [message] using the given RSA [publicKey].
  ///
  static String rsaEncrypt(String message, RSAPublicKey publicKey) {
    var cipher = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    var cipherText = cipher.process(Uint8List.fromList(message.codeUnits));

    return String.fromCharCodes(cipherText);
  }

  ///
  /// Decrypt the given [cipherMessage] using the given RSA [privateKey].
  ///
  static String rsaDecrypt(String cipherMessage, RSAPrivateKey privateKey) {
    var cipher = RSAEngine()
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    var decrypted = cipher.process(Uint8List.fromList(cipherMessage.codeUnits));

    return String.fromCharCodes(decrypted);
  }

  ///
  /// Signing the given [dataToSign] with the given [privateKey].
  ///
  /// The default [algorithm] used is **SHA-256/RSA**. All supported algorihms are :
  ///
  /// * MD2/RSA
  /// * MD4/RSA
  /// * MD5/RSA
  /// * RIPEMD-128/RSA
  /// * RIPEMD-160/RSA
  /// * RIPEMD-256/RSA
  /// * SHA-1/RSA
  /// * SHA-224/RSA
  /// * SHA-256/RSA
  /// * SHA-384/RSA
  /// * SHA-512/RSA
  ///
  static Uint8List rsaSign(RSAPrivateKey privateKey, Uint8List dataToSign,
      {String algorithmName = 'SHA-256/RSA'}) {
    var signer = Signer(algorithmName) as RSASigner;

    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    var sig = signer.generateSignature(dataToSign);

    return sig.bytes;
  }

  ///
  /// Verifying the given [signedData] with the given [publicKey] and the given [signature].
  /// Will return **true** if the given [signature] matches the [signedData].
  ///
  /// The default [algorithm] used is **SHA-256/RSA**. All supported algorihms are :
  ///
  /// * MD2/RSA
  /// * MD4/RSA
  /// * MD5/RSA
  /// * RIPEMD-128/RSA
  /// * RIPEMD-160/RSA
  /// * RIPEMD-256/RSA
  /// * SHA-1/RSA
  /// * SHA-224/RSA
  /// * SHA-256/RSA
  /// * SHA-384/RSA
  /// * SHA-512/RSA
  ///
  static bool rsaVerify(
      RSAPublicKey publicKey, Uint8List signedData, Uint8List signature,
      {String algorithm = 'SHA-256/RSA'}) {
    final sig = RSASignature(signature);

    final verifier = Signer(algorithm);

    verifier.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

    try {
      return verifier.verifySignature(signedData, sig);
    } on ArgumentError {
      return false;
    }
  }

  ///
  /// Signing the given [dataToSign] with the given [privateKey].
  ///
  /// The default [algorithm] used is **SHA-1/ECDSA**. All supported algorihms are :
  ///
  /// * SHA-1/ECDSA
  /// * SHA-224/ECDSA
  /// * SHA-256/ECDSA
  /// * SHA-384/ECDSA
  /// * SHA-512/ECDSA
  /// * SHA-1/DET-ECDSA
  /// * SHA-224/DET-ECDSA
  /// * SHA-256/DET-ECDSA
  /// * SHA-384/DET-ECDSA
  /// * SHA-512/DET-ECDSA
  ///
  static ECSignature ecSign(ECPrivateKey privateKey, Uint8List dataToSign,
      {String algorithmName = 'SHA-1/ECDSA'}) {
    var signer = Signer(algorithmName) as ECDSASigner;

    var params = ParametersWithRandom(
        PrivateKeyParameter<ECPrivateKey>(privateKey), _getSecureRandom());
    signer.init(true, params);

    var sig = signer.generateSignature(dataToSign) as ECSignature;

    return sig;
  }

  ///
  /// Verifying the given [signedData] with the given [publicKey] and the given [signature].
  /// Will return **true** if the given [signature] matches the [signedData].
  ///
  /// The default [algorithm] used is **SHA-1/ECDSA**. All supported algorihms are :
  ///
  /// * SHA-1/ECDSA
  /// * SHA-224/ECDSA
  /// * SHA-256/ECDSA
  /// * SHA-384/ECDSA
  /// * SHA-512/ECDSA
  /// * SHA-1/DET-ECDSA
  /// * SHA-224/DET-ECDSA
  /// * SHA-256/DET-ECDSA
  /// * SHA-384/DET-ECDSA
  /// * SHA-512/DET-ECDSA
  ///
  static bool ecVerify(
      ECPublicKey publicKey, Uint8List signedData, ECSignature signature,
      {String algorithm = 'SHA-1/ECDSA'}) {
    final verifier = Signer(algorithm) as ECDSASigner;

    verifier.init(false, PublicKeyParameter<ECPublicKey>(publicKey));

    try {
      return verifier.verifySignature(signedData, signature);
    } on ArgumentError {
      return false;
    }
  }

  ///
  /// Returns the modulus of the given [pem] that represents an RSA private key.
  ///
  /// This equals the following openssl command:
  /// ```
  /// openssl rsa -noout -modulus -in FILE.key
  /// ```
  ///
  static BigInt getModulusFromRSAPrivateKeyPem(String pem) {
    RSAPrivateKey privateKey;
    switch (_getPrivateKeyType(pem)) {
      case 'RSA':
        privateKey = rsaPrivateKeyFromPem(pem);
        return privateKey.modulus!;
      case 'RSA_PKCS1':
        privateKey = rsaPrivateKeyFromPemPkcs1(pem);
        return privateKey.modulus!;
      case 'ECC':
        throw ArgumentError('ECC private key not supported.');
      default:
        privateKey = rsaPrivateKeyFromPem(pem);
        return privateKey.modulus!;
    }
  }

  ///
  /// Returns the private key type of the given [pem]
  ///
  static String _getPrivateKeyType(String pem) {
    if (pem.startsWith(BEGIN_RSA_PRIVATE_KEY)) {
      return 'RSA_PKCS1';
    } else if (pem.startsWith(BEGIN_PRIVATE_KEY)) {
      return 'RSA';
    } else if (pem.startsWith(BEGIN_EC_PRIVATE_KEY)) {
      return 'ECC';
    }
    return 'RSA';
  }
}
