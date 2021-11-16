import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'X509CertificatePublicKeyData.g.dart';

///
/// Model that a public key from a X509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class X509CertificatePublicKeyData {
  /// The algorithm of the public key
  String? algorithm;

  /// The key length of the public key
  int? length;

  /// The sha1 thumbprint of the public key
  String? sha1Thumbprint;

  /// The sha256 thumbprint of the public key
  String? sha256Thumbprint;

  /// The bytes representing the public key as String
  String? bytes;

  @JsonKey(fromJson: plainSha1FromJson, toJson: plainSha1ToJson)
  Uint8List? plainSha1;

  X509CertificatePublicKeyData(
      {this.algorithm,
      this.length,
      this.sha1Thumbprint,
      this.sha256Thumbprint,
      this.bytes,
      this.plainSha1});

  /*
   * Json to X509CertificatePublicKeyData object
   */
  factory X509CertificatePublicKeyData.fromJson(Map<String, dynamic> json) =>
      _$X509CertificatePublicKeyDataFromJson(json);

  /*
   * X509CertificatePublicKeyData object to json
   */
  Map<String, dynamic> toJson() => _$X509CertificatePublicKeyDataToJson(this);

  static Uint8List? plainSha1FromJson(List<int>? json) {
    if (json == null) {
      return null;
    }
    return Uint8List.fromList(json);
  }

  static List<int>? plainSha1ToJson(Uint8List? object) {
    if (object == null) {
      return null;
    }
    return object.toList();
  }
}
