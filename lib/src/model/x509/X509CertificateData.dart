import 'package:basic_utils/src/model/x509/X509CertificatePublicKeyData.dart';
import 'package:json_annotation/json_annotation.dart';

import 'X509CertificateValidity.dart';

part 'X509CertificateData.g.dart';

///
/// Model that represents the data of a x509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
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

  /// The sha1 thumbprint for the certificate
  String sha1Thumbprint;

  /// The sha256 thumbprint for the certificate
  String sha256Thumbprint;

  /// The md5 thumbprint for the certificate
  String md5Thumbprint;

  /// The public key data from the certificate
  X509CertificatePublicKeyData publicKeyData;

  List<String> subjectAlternativNames;

  X509CertificateData(
      {this.version,
      this.serialNumber,
      this.signatureAlgorithm,
      this.issuer,
      this.validity,
      this.subject,
      this.sha1Thumbprint,
      this.sha256Thumbprint,
      this.md5Thumbprint,
      this.publicKeyData,
      this.subjectAlternativNames});

  /*
   * Json to X509CertificateData object
   */
  factory X509CertificateData.fromJson(Map<String, dynamic> json) =>
      _$X509CertificateDataFromJson(json);

  /*
   * X509CertificateData object to json
   */
  Map<String, dynamic> toJson() => _$X509CertificateDataToJson(this);
}
