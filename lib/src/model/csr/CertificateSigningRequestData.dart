import 'package:basic_utils/src/model/csr/CertificateSigningRequestExtensions.dart';
import 'package:basic_utils/src/model/csr/CertificationRequestInfo.dart';
import 'package:basic_utils/src/model/csr/SubjectPublicKeyInfo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CertificateSigningRequestData.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CertificateSigningRequestData {
  /// The certificationRequestInfo
  CertificationRequestInfo? certificationRequestInfo;

  /// The version
  @Deprecated('Use certificationRequestInfo.version instead')
  int? version;

  /// The subject data of the certificate singing request
  @Deprecated('Use certificationRequestInfo.subject instead')
  Map<String, String>? subject;

  /// The public key information
  @Deprecated('Use certificationRequestInfo.publicKeyInfo instead')
  SubjectPublicKeyInfo? publicKeyInfo;

  /// The signature algorithm
  String? signatureAlgorithm;

  /// The readable name of the signature algorithm
  String? signatureAlgorithmReadableName;

  /// The salt length if algorithm is rsaPSS
  int? saltLength;

  /// The digest used for PSS signature
  String? pssDigest;

  /// The signature
  String? signature;

  /// The plain PEM string
  String? plain;

  /// The extension
  @Deprecated('Use certificationRequestInfo.extensions instead')
  CertificateSigningRequestExtensions? extensions;

  /// The certificationRequestInfo sequence as base64
  String? certificationRequestInfoSeq;

  CertificateSigningRequestData({
    this.subject,
    this.version,
    this.signature,
    this.signatureAlgorithm,
    this.signatureAlgorithmReadableName,
    this.publicKeyInfo,
    this.plain,
    this.extensions,
    this.certificationRequestInfoSeq,
    this.certificationRequestInfo,
    this.saltLength,
    this.pssDigest,
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
