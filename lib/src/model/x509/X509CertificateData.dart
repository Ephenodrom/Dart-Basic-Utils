import 'X509CertificateValidity.dart';

class X509CertificateData {
  int version;
  BigInt serialNumber;
  String signatureAlgorithm;
  Map<String, String> issuer;
  X509CertificateValidity validity;
  Map<String, String> subject;

  X509CertificateData(
      {this.version,
      this.serialNumber,
      this.signatureAlgorithm,
      this.issuer,
      this.validity,
      this.subject});
}
