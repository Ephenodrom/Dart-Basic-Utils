import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/pkcs/digest_info.dart';

///
///```
/// MacData ::= SEQUENCE {
///     mac        DigestInfo,
///     macSalt    OCTET STRING,
///     iterations INTEGER DEFAULT 1
/// }
///```
///
class MacData extends ASN1Object {
  late DigestInfo mac;
  late Uint8List macSalt;
  late BigInt iterationCount;

  MacData(this.mac, this.macSalt, this.iterationCount);

  MacData.fromSequence(ASN1Sequence seq) {
    if (seq.elements!.length != 3) {
      throw ArgumentError('Sequence has not enough elements');
    }
    mac = DigestInfo.fromSequence(seq.elements!.elementAt(0) as ASN1Sequence);
    var o = seq.elements!.elementAt(1) as ASN1OctetString;
    if (o.valueBytes != null) {
      macSalt = o.valueBytes!;
    }
    var i = seq.elements!.elementAt(2) as ASN1Integer;
    if (i.integer != null) {
      iterationCount = i.integer!;
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(elements: [
      mac,
      ASN1OctetString(octets: macSalt),
      ASN1Integer(iterationCount),
    ]);
    return tmp.encode(encodingRule: encodingRule);
  }
}
