import 'package:basic_utils/src/model/x509/X509CertificateData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Pkcs7CertificateData.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Pkcs7CertificateData {
  /// The syntax version number
  int? version;

  /// Indicates the type of the associated content.
  String? contentType;

  /// The certificates within the PKCS7
  List<X509CertificateData>? certificates;

  Pkcs7CertificateData({this.version, this.certificates, this.contentType});

  /*
   * Json to Pkcs7CertificateData object
   */
  factory Pkcs7CertificateData.fromJson(Map<String, dynamic> json) =>
      _$Pkcs7CertificateDataFromJson(json);

  /*
   * Pkcs7CertificateData object to json
   */
  Map<String, dynamic> toJson() => _$Pkcs7CertificateDataToJson(this);
}
