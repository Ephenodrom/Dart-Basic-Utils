import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/algorithm_identifier.dart';

///
///```
/// PrivateKeyInfo ::= OneAsymmetricKey
///
/// OneAsymmetricKey ::= SEQUENCE {
///        version                   Version,
///        privateKeyAlgorithm       PrivateKeyAlgorithmIdentifier,
///        privateKey                PrivateKey,
///        attributes            [0] Attributes OPTIONAL,
///        ...,
///        [[2: publicKey        [1] PublicKey OPTIONAL ]],
///        ...
/// }
///```
///
class PrivateKeyInfo extends ASN1Object {
  late ASN1Integer version;
  late AlgorithmIdentifier privateKeyAlgorithm;
  late ASN1OctetString privateKey;
  ASN1Set? attributes;
  ASN1BitString? publicKey;

  PrivateKeyInfo(this.version, this.privateKeyAlgorithm, this.privateKey);

  ///
  /// Creates an instance of PrivateKeyInfo for the given [pem].
  /// The [pem] should represent a RSA private key in PKCS1.
  ///
  PrivateKeyInfo.fromPkcs1RsaPem(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    var asn1Parser = ASN1Parser(bytes);
    var privateKeySeq = asn1Parser.nextObject();
    privateKey = ASN1OctetString(octets: privateKeySeq.encode());
    version = ASN1Integer.fromtInt(0);
    privateKeyAlgorithm =
        AlgorithmIdentifier.fromIdentifier('1.2.840.113549.1.1.1');
  }

  ///
  /// Creates an instance of PrivateKeyInfo for the given [key].
  /// The [key] should represent a RSA private key in PKCS1 format as an [ASN1Sequence].
  ///
  PrivateKeyInfo.fromPkcs1Rsa(ASN1Object key) {
    privateKey = ASN1OctetString(octets: key.encode());
    version = ASN1Integer.fromtInt(0);
    privateKeyAlgorithm =
        AlgorithmIdentifier.fromIdentifier('1.2.840.113549.1.1.1');
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(elements: [
      version,
      privateKeyAlgorithm,
      privateKey,
    ]);
    if (attributes != null) {
      tmp.add(attributes!);
    }
    if (publicKey != null) {
      tmp.add(publicKey!);
    }
    return tmp.encode(encodingRule: encodingRule);
  }
}
