import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/pkcs/pkcs12/safe_bag.dart';

///
///```
///  SafeContents ::= SEQUENCE OF SafeBag
///```
///
class SafeContents extends ASN1Object {
  ///
  /// The safebags to store.
  ///
  late List<SafeBag> safeBags;

  SafeContents(this.safeBags);

  ///
  /// Creates a SafeContents object from the given sequence consisting of [SafeBag] or [ASN1Sequence].
  ///
  SafeContents.fromSequence(ASN1Sequence seq) {
    safeBags = [];
    if (seq.elements != null) {
      seq.elements!.forEach((element) {
        if (element is SafeBag) {
          safeBags.add(element);
        } else if (element is ASN1Sequence) {
          safeBags.add(SafeBag.fromSequence(element));
        }
      });
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(elements: safeBags);
    return tmp.encode(encodingRule: encodingRule);
  }
}
