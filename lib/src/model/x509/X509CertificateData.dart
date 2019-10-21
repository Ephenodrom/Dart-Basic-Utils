import 'X509CertificateValidity.dart';

///
/// Model that represents the data of a x509Certificate
///
class X509CertificateData {
  /// The version of the certificate
  int version;

  /// The serialNumber of the certificate
  BigInt serialNumber;

  /// The signatureAlgorithm of the certificate
  String signatureAlgorithm;

  /// The issuer data of the certificate
  Map<String, String> issuer;

  /// The validity of the certificate
  X509CertificateValidity validity;

  /// The subject data of the certificate
  Map<String, String> subject;

  X509CertificateData(
      {this.version,
      this.serialNumber,
      this.signatureAlgorithm,
      this.issuer,
      this.validity,
      this.subject});
}
