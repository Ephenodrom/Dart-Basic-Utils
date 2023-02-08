import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/pkcs/private_key_info.dart';

///
///```
/// KeyBag ::= PrivateKeyInfo
///```
///
class KeyBag extends ASN1Object {
  PrivateKeyInfo privateKeyInfo;

  KeyBag(this.privateKeyInfo);

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    return privateKeyInfo.encode(encodingRule: encodingRule);
  }
}
