import 'package:basic_utils/src/model/x509/CertificateChainPairCheckResult.dart';
import 'package:basic_utils/src/model/x509/X509CertificateData.dart';

///
/// Model for representing a certificate chain check.
///
class CertificateChainCheckData {
  /// The chain
  List<X509CertificateData>? chain;

  ///
  /// The check result for each pair of the chain.
  /// The amount of pairs is depending on the length of the chain.7
  ///
  List<CertificateChainPairCheckResult>? pairs;

  CertificateChainCheckData({this.chain});

  ///
  /// Returns true of the chain is valid. For detail information take a look at
  /// the [pairs] field.
  ///
  bool isValid() {
    var valid = true;
    if (pairs != null) {
      for (var p in pairs!) {
        valid = p.isValid();
        if (valid == false) {
          break;
        }
      }
    }
    return valid;
  }
}
