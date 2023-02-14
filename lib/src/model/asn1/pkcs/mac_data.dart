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

  MacData.fromSequence(ASN1Sequence seq) {}

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
