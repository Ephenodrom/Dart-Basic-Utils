import 'package:json_annotation/json_annotation.dart';

part 'SubjectPublicKeyInfo.g.dart';

///
/// Model that a public key from a X509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SubjectPublicKeyInfo {
  /// The algorithm of the public key
  String? algorithm;

  /// The algorithm of the public key
  String? algorithmReadableName;

  /// The key length of the public key
  int? length;

  /// The sha1 thumbprint of the public key
  String? sha1Thumbprint;

  /// The sha256 thumbprint of the public key
  String? sha256Thumbprint;

  /// The bytes representing the public key as String
  String? bytes;

  SubjectPublicKeyInfo({
    this.algorithm,
    this.length,
    this.sha1Thumbprint,
    this.sha256Thumbprint,
    this.bytes,
    this.algorithmReadableName,
  });

  /*
   * Json to SubjectPublicKeyInfo object
   */
  factory SubjectPublicKeyInfo.fromJson(Map<String, dynamic> json) =>
      _$SubjectPublicKeyInfoFromJson(json);

  /*
   * SubjectPublicKeyInfo object to json
   */
  Map<String, dynamic> toJson() => _$SubjectPublicKeyInfoToJson(this);
}
