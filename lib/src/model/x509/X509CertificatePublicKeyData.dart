import 'package:json_annotation/json_annotation.dart';

part 'X509CertificatePublicKeyData.g.dart';

///
/// Model that a public key from a X509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class X509CertificatePublicKeyData {
  /// The algorithm of the public key
  String algorithm;

  /// The key length of the public key
  int length;

  /// The sha1 thumbprint of the public key
  String sha1Thumbprint;

  /// The bytes representing the public key as String
  String bytes;

  X509CertificatePublicKeyData(
      {this.algorithm, this.length, this.sha1Thumbprint, this.bytes});

  /*
   * Json to X509CertificatePublicKeyData object
   */
  factory X509CertificatePublicKeyData.fromJson(Map<String, dynamic> json) =>
      _$X509CertificatePublicKeyDataFromJson(json);

  /*
   * X509CertificatePublicKeyData object to json
   */
  Map<String, dynamic> toJson() => _$X509CertificatePublicKeyDataToJson(this);
}
