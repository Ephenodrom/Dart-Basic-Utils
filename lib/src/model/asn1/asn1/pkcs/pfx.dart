import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/content_info.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/mac_data.dart';

///
///```
/// PFX ::= SEQUENCE {
///   version     INTEGER {v3(3)}(v3,...),
///   authSafe    ContentInfo,
///   macData     MacData OPTIONAL
/// }
///```
///
class Pfx extends ASN1Object {
  late ASN1Integer version;
  late ContentInfo authSafe;
  MacData? macData;

  Pfx(this.version, this.authSafe, {this.macData});

  Pfx.fromSequence(ASN1Sequence seq) {
    version = seq.elements!.elementAt(0) as ASN1Integer;
    if (version.integer!.toInt() != 3) {
      throw ArgumentError('wrong version for PFX PDU');
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(elements: [version, authSafe]);
    if (macData != null) {
      tmp.add(macData!);
    }
    return tmp.encode(encodingRule: encodingRule);
  }
}
