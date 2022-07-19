import 'package:basic_utils/src/model/crl/CrlExtensions.dart';
import 'package:basic_utils/src/model/crl/RevokedCertificate.dart';

class CertificateListData {
  /// The version
  int? version;

  /// The issuer data of this list
  Map<String, String>? issuer;

  /// The signatureAlgorithm of the certificate
  String? signatureAlgorithm;

  /// The readable name of the signature algorithm
  String? signatureAlgorithmReadableName;

  /// The issue date of this CRL.
  DateTime? thisUpdate;

  /// The date by which the next CRL will be issued
  DateTime? nextUpdate;

  /// The revoked certificates
  List<RevokedCertificate>? revokedCertificates;

  /// The extensions
  CrlExtensions? extensions;

  CertificateListData({
    this.extensions,
    this.issuer,
    this.nextUpdate,
    this.revokedCertificates,
    this.signatureAlgorithm,
    this.signatureAlgorithmReadableName,
    this.thisUpdate,
    this.version,
  });
}
