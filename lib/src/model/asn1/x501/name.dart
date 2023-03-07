import 'dart:typed_data';

import 'package:basic_utils/src/model/asn1/x501/rdn.dart';
import 'package:pointycastle/pointycastle.dart';

///
///```
/// Name ::= CHOICE { -- only one possibility for now --
///   rdnSequence  RDNSequence
/// }
///
/// RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
///```
///
class Name extends ASN1Object {
  late List<RDN> rdnSequence;

  Name(this.rdnSequence);

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    var tmp = ASN1Sequence(
      elements: rdnSequence,
    );
    return tmp.encode(encodingRule: encodingRule);
  }
}
