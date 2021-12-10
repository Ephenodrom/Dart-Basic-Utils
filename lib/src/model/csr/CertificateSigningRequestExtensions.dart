import 'package:json_annotation/json_annotation.dart';

part 'CertificateSigningRequestExtensions.g.dart';

///
/// Model that represents the extensions of a x509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CertificateSigningRequestExtensions {
  /// The subject alternative names
  List<String>? subjectAlternativNames;

  CertificateSigningRequestExtensions({
    this.subjectAlternativNames,
  });

  /*
   * Json to CertificateSigningRequestExtensions object
   */
  factory CertificateSigningRequestExtensions.fromJson(
          Map<String, dynamic> json) =>
      _$CertificateSigningRequestExtensionsFromJson(json);

  /*
   * CertificateSigningRequestExtensions object to json
   */
  Map<String, dynamic> toJson() =>
      _$CertificateSigningRequestExtensionsToJson(this);
}
