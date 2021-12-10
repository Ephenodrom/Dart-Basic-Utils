import 'package:basic_utils/src/model/csr/SubjectPublicKeyInfo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CertificateSigningRequestData.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CertificateSigningRequestData {
  /// The version
  int? version;

  /// The subject data of the certificate singing request
  Map<String, String>? subject;

  /// The public key information
  SubjectPublicKeyInfo? publicKeyInfo;

  /// The signature algorithm
  String? signatureAlgorithm;

  /// The readable name of the signature algorithm
  String? signatureAlgorithmReadableName;

  /// The signature
  String? signature;

  /// The plain PEM string
  String? plain;

  CertificateSigningRequestData({
    this.subject,
    this.version,
    this.signature,
    this.signatureAlgorithm,
    this.signatureAlgorithmReadableName,
    this.publicKeyInfo,
    this.plain,
  });

  /*
   * Json to CertificateSigningRequestData object
   */
  factory CertificateSigningRequestData.fromJson(Map<String, dynamic> json) =>
      _$CertificateSigningRequestDataFromJson(json);

  /*
   * CertificateSigningRequestData object to json
   */
  Map<String, dynamic> toJson() => _$CertificateSigningRequestDataToJson(this);
}
