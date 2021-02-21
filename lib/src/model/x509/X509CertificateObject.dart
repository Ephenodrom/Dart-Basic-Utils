import 'package:basic_utils/src/model/x509/X509CertificateData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'X509CertificateObject.g.dart';

///
/// Model that represents a x509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class X509CertificateObject {
  X509CertificateData? data;

  X509CertificateObject(this.data);

  /*
   * Json to X509CertificateObject object
   */
  factory X509CertificateObject.fromJson(Map<String, dynamic> json) =>
      _$X509CertificateObjectFromJson(json);

  /*
   * X509CertificateObject object to json
   */
  Map<String, dynamic> toJson() => _$X509CertificateObjectToJson(this);
}
