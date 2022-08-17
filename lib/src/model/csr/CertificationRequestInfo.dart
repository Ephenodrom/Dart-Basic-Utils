import 'package:basic_utils/src/model/csr/CertificateSigningRequestExtensions.dart';
import 'package:basic_utils/src/model/csr/SubjectPublicKeyInfo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CertificationRequestInfo.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CertificationRequestInfo {
  /// The version
  int? version;

  /// The subject data of the certificate singing request
  Map<String, String>? subject;

  /// The public key information
  SubjectPublicKeyInfo? publicKeyInfo;

  CertificateSigningRequestExtensions? extensions;

  CertificationRequestInfo({
    this.subject,
    this.version,
    this.publicKeyInfo,
    this.extensions,
  });

  /*
   * Json to CertificationRequestInfo object
   */
  factory CertificationRequestInfo.fromJson(Map<String, dynamic> json) =>
      _$CertificationRequestInfoFromJson(json);

  /*
   * CertificationRequestInfo object to json
   */
  Map<String, dynamic> toJson() => _$CertificationRequestInfoToJson(this);
}
