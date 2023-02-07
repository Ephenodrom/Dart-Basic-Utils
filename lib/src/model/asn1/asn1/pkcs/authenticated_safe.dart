import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/content_info.dart';

///
/// Taken from [RFC 7292](https://www.rfc-editor.org/rfc/rfc7292#page-10).
///```
/// AuthenticatedSafe ::= SEQUENCE OF ContentInfo
///```
///
class AuthenticatedSafe extends ASN1Object {
  late List<ContentInfo> info;

  AuthenticatedSafe(this.info);

  AuthenticatedSafe.fromSequence(ASN1Sequence seq) {
    info = [];
    if (seq.elements != null) {
      seq.elements!.forEach(
        (element) {
          info.add(ContentInfo.fromSequence(element as ASN1Sequence));
        },
      );
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(elements: info);
    return tmp.encode(encodingRule: encodingRule);
  }
}
