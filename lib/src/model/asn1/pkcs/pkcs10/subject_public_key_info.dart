import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/x509/algorithm_identifier.dart';

///
///```
/// SubjectPublicKeyInfo { ALGORITHM : IOSet} ::= SEQUENCE {
///   algorithm        AlgorithmIdentifier {{IOSet}},
///   subjectPublicKey BIT STRING
/// }
///```
///
class SubjectPublicKeyInfo extends ASN1Object {
  late AlgorithmIdentifier algorithm;
  late ASN1BitString subjectPublicKey;

  SubjectPublicKeyInfo(
    this.algorithm,
    this.subjectPublicKey,
  );

  SubjectPublicKeyInfo.fromSequence(ASN1Sequence seq) {
    if (seq.elements == null || seq.elements!.length != 2) {
      throw ArgumentError('');
    }
    if (!(seq.elements!.elementAt(0) is ASN1Sequence)) {
      throw ArgumentError('Element at index 0 has to be ASN1Sequence');
    }
    if (!(seq.elements!.elementAt(1) is ASN1BitString)) {
      throw ArgumentError('Element at index 1 has to be ASN1BitString');
    }
    algorithm = AlgorithmIdentifier.fromSequence(
        seq.elements!.elementAt(0) as ASN1Sequence);
    subjectPublicKey = seq.elements!.elementAt(1) as ASN1BitString;
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(
      elements: [
        algorithm,
        subjectPublicKey,
      ],
    );
    return tmp.encode(encodingRule: encodingRule);
  }
}
