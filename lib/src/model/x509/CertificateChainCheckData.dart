import 'package:basic_utils/src/model/x509/CertificateChainCheckError.dart';
import 'package:basic_utils/src/model/x509/X509CertificateData.dart';

class CertificateChainCheckData {
  List<X509CertificateData>? chain;
  List<CertificateChainCheckError>? errors;

  CertificateChainCheckData({this.chain});
}
