import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';

///
///```
/// AttributeTypeAndValue ::= SEQUENCE {
///   type     AttributeType,
///   value    AttributeValue
/// }
///```
///
class AttributeTypeAndValue extends ASN1Object {
  late ASN1ObjectIdentifier type;

  ///
  /// The value. Can be one of the following objects
  /// * [ASN1TeletextString]
  /// * [ASN1PrintableString]
  /// * [ASN1UTF8String]
  /// * [ASN1BMPString]
  ///
  late ASN1Object value;

  AttributeTypeAndValue(this.type, this.value);

  AttributeTypeAndValue.fromSequence(ASN1Sequence seq) {
    if (seq.elements == null || seq.elements!.length != 2) {
      throw ArgumentError('');
    }
    if (!(seq.elements!.elementAt(0) is ASN1ObjectIdentifier)) {
      throw ArgumentError('Element at index 0 has to be ASN1ObjectIdentifier');
    }
    if (seq.elements!.elementAt(1) is ASN1TeletextString ||
        seq.elements!.elementAt(1) is ASN1TeletextString ||
        seq.elements!.elementAt(1) is ASN1UTF8String ||
        seq.elements!.elementAt(1) is ASN1BMPString) {
      // VALID TYPES
    } else {
      throw ArgumentError(
          'Element at index 1 has to be ASN1TeletextString, ASN1TeletextString, ASN1UTF8String or ASN1BMPString');
    }

    type = seq.elements!.elementAt(0) as ASN1ObjectIdentifier;
    value = seq.elements!.elementAt(1);
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(
      elements: [
        type,
        value,
      ],
    );
    return tmp.encode(encodingRule: encodingRule);
  }
}
