import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/pkcs/pkcs7/content_info.dart';
import 'package:basic_utils/src/model/asn1/pkcs/pkcs12/mac_data.dart';

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

  ///
  /// Creates an instance of [PFX] from the given [sequence]. The sequence must have at least 2 elements.
  ///
  Pfx.fromSequence(ASN1Sequence seq) {
    if (IterableUtils.isNullOrEmpty(seq.elements)) {
      throw ArgumentError('Empty sequence');
    }
    if (seq.elements!.length == 1) {
      throw ArgumentError('Sequence has not enough elements');
    }
    version = seq.elements!.elementAt(0) as ASN1Integer;
    if (version.integer!.toInt() != 3) {
      throw ArgumentError('Wrong version for PFX PDU');
    }
    authSafe =
        ContentInfo.fromSequence(seq.elements!.elementAt(1) as ASN1Sequence);
    if (seq.elements!.length == 3) {
      macData =
          MacData.fromSequence(seq.elements!.elementAt(2) as ASN1Sequence);
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
