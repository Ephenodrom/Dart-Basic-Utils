import 'package:basic_utils/src/model/csr/SubjectPublicKeyInfo.dart';
import 'package:json_annotation/json_annotation.dart';

//part 'CertificateSigningRequestData.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CertificateSigningRequestData {
  /// The version
  int? version;

  /// The subject data of the certificate singing request
  Map<String, String>? subject;

  SubjectPublicKeyInfo? publicKeyInfo;

  String? signatureAlgorithm;

  String? signatureAlgorithmReadableName;

  String? signature;

  CertificateSigningRequestData({
    this.subject,
    this.version,
    this.signature,
    this.signatureAlgorithm,
    this.signatureAlgorithmReadableName,
    this.publicKeyInfo,
  });
}
