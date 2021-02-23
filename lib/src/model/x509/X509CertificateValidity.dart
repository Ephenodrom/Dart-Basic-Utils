import 'package:json_annotation/json_annotation.dart';

part 'X509CertificateValidity.g.dart';

///
/// Model that represents the validity data of a x509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class X509CertificateValidity {
  /// The start date
  DateTime notBefore;

  /// The end date
  DateTime notAfter;

  X509CertificateValidity({required this.notBefore,required this.notAfter});

  /*
   * Json to X509CertificateValidity object
   */
  factory X509CertificateValidity.fromJson(Map<String, dynamic> json) =>
      _$X509CertificateValidityFromJson(json);

  /*
   * X509CertificateValidity object to json
   */
  Map<String, dynamic> toJson() => _$X509CertificateValidityToJson(this);
}
