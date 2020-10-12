import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/asn1.dart';

class Asn1Utils {
  ///
  /// Creates an ASN1 dump for the given [pem].
  ///
  static String dump(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject();
    var dump = topLevelSeq.dump();
    return dump;
  }
}
