import 'dart:typed_data';

import 'package:basic_utils/src/model/csr/SubjectPublicKeyInfo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'X509CertificatePublicKeyData.g.dart';

///
/// Model that a public key from a X509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class X509CertificatePublicKeyData {
  /// The algorithm of the public key
  String? algorithm;

  /// The readable name of the algorithm
  String? algorithmReadableName;

  /// The parameter of the public key
  String? parameter;

  /// The readable name of the parameter
  String? parameterReadableName;

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

  /// The exponent used on a RSA public key
  int? exponent;

  X509CertificatePublicKeyData({
    this.algorithm,
    this.length,
    this.sha1Thumbprint,
    this.sha256Thumbprint,
    this.bytes,
    this.plainSha1,
    this.algorithmReadableName,
    this.parameter,
    this.parameterReadableName,
    this.exponent,
  });

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

  X509CertificatePublicKeyData.fromSubjectPublicKeyInfo(
      SubjectPublicKeyInfo info) {
    algorithm = info.algorithm;
    length = info.length;
    sha1Thumbprint = info.sha1Thumbprint;
    sha256Thumbprint = info.sha256Thumbprint;
    bytes = info.bytes;
    algorithmReadableName = info.algorithmReadableName;
    parameter = info.parameter;
    parameterReadableName = info.parameterReadableName;
    exponent = info.exponent;
  }
}
