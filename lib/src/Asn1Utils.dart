import 'package:basic_utils/basic_utils.dart';

class Asn1Utils {
  ///
  /// Creates an ASN1 dump for the given [pem].
  ///
  /// To ignore the check for correct PEM headers, set the [checkHeader] parameter to false.
  ///
  static String dump(String pem, {bool checkHeader = true}) {
    var bytes =
        CryptoUtils.getBytesFromPEMString(pem, checkHeader: checkHeader);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject();
    var dump = topLevelSeq.dump();
    return dump;
  }
}
