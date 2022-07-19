import 'package:basic_utils/src/model/crl/CertificateListData.dart';

class CertificateRevokeListeData {
  /// The certificate list data
  CertificateListData? tbsCertList;

  /// The signature algorithm
  String? signatureAlgorithm;

  /// The readable name of the signature algorithm
  String? signatureAlgorithmReadableName;

  /// The signature
  String? signature;

  CertificateRevokeListeData({
    this.tbsCertList,
    this.signature,
    this.signatureAlgorithm,
    this.signatureAlgorithmReadableName,
  });
}
