import 'dart:typed_data';

import 'package:basic_utils/src/model/asn1/x509/algorithm_identifier.dart';
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
  late AlgorithmIdentifier digestAlgorithm;
  late Uint8List digest;

  DigestInfo(this.digest, this.digestAlgorithm);

  DigestInfo.fromSequence(ASN1Sequence seq) {
    if (seq.elements!.length != 2) {
      throw ArgumentError('Sequence has not enough elements');
    }
    digestAlgorithm = AlgorithmIdentifier.fromSequence(
        seq.elements!.elementAt(0) as ASN1Sequence);
    var o = seq.elements!.elementAt(1) as ASN1OctetString;
    if (o.valueBytes != null) {
      digest = o.valueBytes!;
    }
  }

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
