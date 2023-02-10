import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';

///
///```
/// AlgorithmIdentifier ::= SEQUENCE {
///   algorithm OBJECT IDENTIFIER,
///   parameters ANY DEFINED BY algorithm OPTIONAL
/// }
///```
///
class AlgorithmIdentifier extends ASN1Object {
  late ASN1ObjectIdentifier algorithm;
  ASN1Object? parameters;

  AlgorithmIdentifier(this.algorithm, {this.parameters});

  ///
  /// Creates a AlgorithmIdentifier instance from the given [identifier] like "1.3.14.3.2.26".
  ///
  AlgorithmIdentifier.fromIdentifier(String identifier, {this.parameters}) {
    algorithm = ASN1ObjectIdentifier.fromIdentifierString(identifier);
  }

  ///
  /// Creates a AlgorithmIdentifier instance from the given [name] like "sha1".
  ///
  AlgorithmIdentifier.fromName(String name, {this.parameters}) {
    algorithm = ASN1ObjectIdentifier.fromName(name);
  }

  AlgorithmIdentifier.fromSequence(ASN1Sequence seq) {
    algorithm = seq.elements!.elementAt(0) as ASN1ObjectIdentifier;
    if (seq.elements!.length >= 2) {
      parameters = seq.elements!.elementAt(1);
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(elements: [
      algorithm,
      parameters ?? ASN1Null(),
    ]);
    return tmp.encode(encodingRule: encodingRule);
  }
}
