import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';

///
///```
/// RelativeDistinguishedName ::= SET SIZE (1..MAX) OF AttributeTypeAndValue
///```
///
class RDN extends ASN1Object {
  /// Values for the RDN. Elements should be of [AttributeTypeAndValue]
  late ASN1Set values;

  RDN(this.values);

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    return values.encode(encodingRule: encodingRule);
  }
}
