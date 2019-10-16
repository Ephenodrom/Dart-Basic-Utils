import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';

import '../basic_utils.dart';

///
/// Helper class for certificate operations.
///
class X509Utils {
  static final String BEGIN_PRIVATE_KEY = "-----BEGIN PRIVATE KEY-----";
  static final String END_PRIVATE_KEY = "-----END PRIVATE KEY-----";

  static final String BEGIN_PUBLIC_KEY = "-----BEGIN PUBLIC KEY-----";
  static final String END_PUBLIC_KEY = "-----END PUBLIC KEY-----";

  static final String BEGIN_CSR = "-----BEGIN CERTIFICATE REQUEST-----";
  static final String END_CSR = "-----END CERTIFICATE REQUEST-----";

  ///
  /// Generates a [AsymmetricKeyPair] with the given [keySize].
  ///
  static AsymmetricKeyPair generateKeyPair({int keySize = 2048}) {
    RSAKeyGeneratorParameters keyParams =
        RSAKeyGeneratorParameters(BigInt.parse('65537'), keySize, 12);

    FortunaRandom secureRandom = FortunaRandom();
    Random random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    ParametersWithRandom rngParams =
        ParametersWithRandom(keyParams, secureRandom);
    RSAKeyGenerator k = RSAKeyGenerator();
    k.init(rngParams);

    return k.generateKeyPair();
  }

  ///
  /// Formats the given [key] by chunking the [key] and adding the [begin] and [end] to the [key].
  ///
  /// The line length will be defined by the given [chunkSize]. The default value is 64.
  ///
  /// Each line will be delimited by the given [lineDelimiter]. The default value is "\n".w
  ///
  static String formatKeyString(String key, String begin, String end,
      {int chunkSize = 64, String lineDelimiter = "\n"}) {
    StringBuffer sb = StringBuffer();
    List<String> chunks = StringUtils.chunk(key, chunkSize);
    sb.write(begin + lineDelimiter);
    for (String s in chunks) {
      sb.write(s + lineDelimiter);
    }
    sb.write(end);
    return sb.toString();
  }

  ///
  /// Generates a Certificate Signing Request with the given [attributes] using the given [privateKey] and [publicKey].
  ///
  static String generateRsaCsrPem(Map<String, String> attributes,
      RSAPrivateKey privateKey, RSAPublicKey publicKey) {
    ASN1Object encodedDN = encodeDN(attributes);

    ASN1Sequence blockDN = ASN1Sequence();
    blockDN.add(ASN1Integer(BigInt.from(0)));
    blockDN.add(encodedDN);
    blockDN.add(_makePublicKeyBlock(publicKey));
    blockDN.add(ASN1Null(tag: 0xA0)); // let's call this WTF

    ASN1Sequence blockProtocol = ASN1Sequence();
    blockProtocol.add(ASN1ObjectIdentifier.fromName("md5WithRSAEncryption"));
    blockProtocol.add(ASN1Null());

    ASN1Sequence outer = ASN1Sequence();
    outer.add(blockDN);
    outer.add(blockProtocol);
    outer.add(ASN1BitString(rsaPrivateKeyModulusToBytes(privateKey)));
    List<String> chunks =
        StringUtils.chunk(base64.encode(outer.encodedBytes), 64);
    return "$BEGIN_CSR\n${chunks.join("\r\n")}\n$END_CSR";
  }

  ///
  /// Encode the given [asn1Object] to PEM format and adding the [begin] and [end].
  ///
  static String encodeASN1ObjectToPem(
      ASN1Object asn1Object, String begin, String end) {
    List<String> chunks =
        StringUtils.chunk(base64.encode(asn1Object.encodedBytes), 64);
    return "$begin\n${chunks.join("\r\n")}\n$end";
  }

  ///
  /// Enode the given [publicKey] to PEM format.
  ///
  static String encodeRSAPublicKeyToPem(RSAPublicKey publicKey) {
    var algorithmSeq = ASN1Sequence();
    var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeq = ASN1Sequence();
    publicKeySeq.add(ASN1Integer(publicKey.modulus));
    publicKeySeq.add(ASN1Integer(publicKey.exponent));
    var publicKeySeqBitString =
        ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);
    List<String> chunks = StringUtils.chunk(dataBase64, 64);

    return "$BEGIN_PUBLIC_KEY\n${chunks.join("\n")}\n$END_PUBLIC_KEY";
  }

  ///
  /// Enode the given [rsaPrivateKey] to PEM format.
  ///
  static String encodeRSAPrivateKeyToPem(RSAPrivateKey rsaPrivateKey) {
    ASN1Integer version = ASN1Integer(BigInt.from(0));

    ASN1Sequence algorithmSeq = ASN1Sequence();
    ASN1Object algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    ASN1Object paramsAsn1Obj =
        ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    ASN1Sequence privateKeySeq = ASN1Sequence();
    ASN1Integer modulus = ASN1Integer(rsaPrivateKey.n);
    ASN1Integer publicExponent = ASN1Integer(BigInt.parse('65537'));
    ASN1Integer privateExponent = ASN1Integer(rsaPrivateKey.d);
    ASN1Integer p = ASN1Integer(rsaPrivateKey.p);
    ASN1Integer q = ASN1Integer(rsaPrivateKey.q);
    BigInt dP = rsaPrivateKey.d % (rsaPrivateKey.p - BigInt.from(1));
    ASN1Integer exp1 = ASN1Integer(dP);
    BigInt dQ = rsaPrivateKey.d % (rsaPrivateKey.q - BigInt.from(1));
    ASN1Integer exp2 = ASN1Integer(dQ);
    BigInt iQ = rsaPrivateKey.q.modInverse(rsaPrivateKey.p);
    ASN1Integer co = ASN1Integer(iQ);

    privateKeySeq.add(version);
    privateKeySeq.add(modulus);
    privateKeySeq.add(publicExponent);
    privateKeySeq.add(privateExponent);
    privateKeySeq.add(p);
    privateKeySeq.add(q);
    privateKeySeq.add(exp1);
    privateKeySeq.add(exp2);
    privateKeySeq.add(co);
    ASN1OctetString publicKeySeqOctetString =
        ASN1OctetString(Uint8List.fromList(privateKeySeq.encodedBytes));

    ASN1Sequence topLevelSeq = ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqOctetString);
    String dataBase64 = base64.encode(topLevelSeq.encodedBytes);
    List<String> chunks = StringUtils.chunk(dataBase64, 64);
    return "$BEGIN_PRIVATE_KEY\n${chunks.join("\n")}\n$END_PRIVATE_KEY";
  }

  ///
  /// Decode a [RSAPrivateKey] from the given [pem] String.
  ///
  static RSAPrivateKey privateKeyFromPem(String pem) {
    if (pem == null) {
      throw ArgumentError('Argument must not be null.');
    }
    Uint8List bytes = getBytesFromPEMString(pem);
    return privateKeyFromDERBytes(bytes);
  }

  ///
  /// Decode a [RSAPublicKey] from the given [pem] String.
  ///
  static RSAPublicKey publicKeyFromPem(String pem) {
    if (pem == null) {
      throw ArgumentError('Argument must not be null.');
    }
    Uint8List bytes = getBytesFromPEMString(pem);
    ASN1Parser asn1Parser = ASN1Parser(bytes);
    ASN1Sequence topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    ASN1Object publicKeyBitString = topLevelSeq.elements[1];

    ASN1Parser publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes());
    ASN1Sequence publicKeySeq = publicKeyAsn.nextObject();
    ASN1Integer modulus = publicKeySeq.elements[0] as ASN1Integer;
    ASN1Integer exponent = publicKeySeq.elements[1] as ASN1Integer;

    RSAPublicKey rsaPublicKey =
        RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);

    return rsaPublicKey;
  }

  ///
  /// Helper function for decoding the base64 in [pem].
  ///
  /// Throws an ArgumentError if the given [pem] is not sourounded by begin marker -----BEGIN and
  /// endmarker -----END or the [pem] consists of less than two lines.
  ///
  static Uint8List getBytesFromPEMString(String pem) {
    List<String> lines = LineSplitter.split(pem)
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.length < 2 ||
        !lines.first.startsWith('-----BEGIN') ||
        !lines.last.startsWith('-----END')) {
      throw ArgumentError('The given string does not have the correct '
          'begin/end markers expected in a PEM file.');
    }
    String base64 = lines.sublist(1, lines.length - 1).join('');
    return Uint8List.fromList(base64Decode(base64));
  }

  ///
  /// Decode the given [bytes] into an [RSAPrivateKey].
  ///
  static RSAPrivateKey privateKeyFromDERBytes(Uint8List bytes) {
    ASN1Parser asn1Parser = ASN1Parser(bytes);
    ASN1Sequence topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    //ASN1Object version = topLevelSeq.elements[0];
    //ASN1Object algorithm = topLevelSeq.elements[1];
    ASN1Object privateKey = topLevelSeq.elements[2];

    asn1Parser = ASN1Parser(privateKey.contentBytes());
    ASN1Sequence pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    ASN1Integer modulus = pkSeq.elements[1] as ASN1Integer;
    //ASN1Integer publicExponent = pkSeq.elements[2] as ASN1Integer;
    ASN1Integer privateExponent = pkSeq.elements[3] as ASN1Integer;
    ASN1Integer p = pkSeq.elements[4] as ASN1Integer;
    ASN1Integer q = pkSeq.elements[5] as ASN1Integer;
    //ASN1Integer exp1 = pkSeq.elements[6] as ASN1Integer;
    //ASN1Integer exp2 = pkSeq.elements[7] as ASN1Integer;
    //ASN1Integer co = pkSeq.elements[8] as ASN1Integer;

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.valueAsBigInteger,
        privateExponent.valueAsBigInteger,
        p.valueAsBigInteger,
        q.valueAsBigInteger);

    return rsaPrivateKey;
  }

  ///
  /// Decode the given [asnSequence] into an [RSAPrivateKey].
  ///
  static RSAPrivateKey privateKeyFromASN1Sequence(ASN1Sequence asnSequence) {
    List<ASN1Object> objects = asnSequence.elements;

    List<ASN1Integer> asnIntegers =
        objects.take(9).map((o) => o as ASN1Integer).toList();

    ASN1Integer version = asnIntegers.first;
    if (version.valueAsBigInteger != BigInt.zero) {
      throw ArgumentError(
          'Expected version 0, got: ${version.valueAsBigInteger}.');
    }

    RSAPrivateKey key = RSAPrivateKey(
        asnIntegers[1].valueAsBigInteger,
        asnIntegers[2].valueAsBigInteger,
        asnIntegers[3].valueAsBigInteger,
        asnIntegers[4].valueAsBigInteger);

    var bitLength = key.n.bitLength;
    if (bitLength != 1024 && bitLength != 2048 && bitLength != 4096) {
      throw ArgumentError('The RSA modulus has a bit length of $bitLength. '
          'Only 1024, 2048 and 4096 are supported.');
    }
    return key;
  }

  static Uint8List _bigIntToBytes(BigInt n) {
    int bytes = (n.bitLength + 7) >> 3;

    var b256 = BigInt.from(256);
    var result = Uint8List(bytes);

    for (int i = 0; i < bytes; i++) {
      result[i] = n.remainder(b256).toInt();
      n = n >> 8;
    }

    return result;
  }

  ///
  /// Converts the [RSAPublicKey.modulus] from the given [publicKey] to a [Uint8List].
  ///
  static Uint8List rsaPublicKeyModulusToBytes(RSAPublicKey publicKey) =>
      _bigIntToBytes(publicKey.modulus);

  ///
  /// Converts the [RSAPublicKey.exponent] from the given [publicKey] to a [Uint8List].
  ///
  static Uint8List rsaPublicKeyExponentToBytes(RSAPublicKey publicKey) =>
      _bigIntToBytes(publicKey.exponent);

  ///
  /// Converts the [RSAPrivateKey.modulus] from the given [privateKey] to a [Uint8List].
  ///
  static Uint8List rsaPrivateKeyModulusToBytes(RSAPrivateKey privateKey) =>
      _bigIntToBytes(privateKey.modulus);

  ///
  /// Encode the given [dn] (Distinguished Name) to a [ASN1Object].
  ///
  /// For supported DN see the rf at <https://tools.ietf.org/html/rfc2256>
  ///
  static ASN1Object encodeDN(Map<String, String> dn) {
    ASN1Sequence distinguishedName = ASN1Sequence();
    ASN1ObjectIdentifier.registerFrequentNames();
    dn.forEach((name, value) {
      ASN1ObjectIdentifier oid = ASN1ObjectIdentifier.fromName(name);
      if (oid == null) {
        throw ArgumentError("Unknown distinguished name field $name");
      }

      ASN1Object ovalue;
      switch (name.toUpperCase()) {
        case "C":
          ovalue = ASN1PrintableString(value);
          break;
        case "CN":
        case "O":
        case "L":
        case "S":
        default:
          ovalue = ASN1UTF8String(value);
          break;
      }

      if (ovalue == null) {
        throw ArgumentError("Could not process distinguished name field $name");
      }

      ASN1Sequence pair = ASN1Sequence();
      pair.add(oid);
      pair.add(ovalue);

      ASN1Set pairset = ASN1Set();
      pairset.add(pair);

      distinguishedName.add(pairset);
    });

    return distinguishedName;
  }

  ///
  /// Create  the public key ASN1Sequence for the csr.
  ///
  static ASN1Sequence _makePublicKeyBlock(RSAPublicKey publicKey) {
    ASN1Sequence blockEncryptionType = ASN1Sequence();
    blockEncryptionType.add(ASN1ObjectIdentifier.fromName("rsaEncryption"));
    blockEncryptionType.add(ASN1Null());

    ASN1Sequence publicKeySequence = ASN1Sequence();
    publicKeySequence.add(ASN1Integer(publicKey.modulus));
    publicKeySequence.add(ASN1Integer(publicKey.exponent));

    ASN1BitString blockPublicKey =
        ASN1BitString(publicKeySequence.encodedBytes);

    ASN1Sequence outer = ASN1Sequence();
    outer.add(blockEncryptionType);
    outer.add(blockPublicKey);

    return outer;
  }
}
