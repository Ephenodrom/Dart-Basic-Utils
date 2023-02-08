import 'dart:typed_data';

import 'package:basic_utils/src/model/asn1/pkcs/algorithm_identifier.dart';
import 'package:pointycastle/asn1.dart';

///
///```
/// DigestInfo ::= SEQUENCE {
///      digestAlgorithm DigestAlgorithmIdentifier,
///      digest Digest
/// }
///
/// Digest ::= OCTET STRING
///```
///
class DigestInfo extends ASN1Object {
  AlgorithmIdentifier digestAlgorithm;
  Uint8List digest;

  DigestInfo(this.digest, this.digestAlgorithm);

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(elements: [
      digestAlgorithm,
      ASN1OctetString(octets: digest),
    ]);
    return tmp.encode(encodingRule: encodingRule);
  }
}
