// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificatePublicKeyData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificatePublicKeyData _$X509CertificatePublicKeyDataFromJson(
        Map<String, dynamic> json) =>
    X509CertificatePublicKeyData(
      algorithm: json['algorithm'] as String?,
      length: json['length'] as int?,
      sha1Thumbprint: json['sha1Thumbprint'] as String?,
      sha256Thumbprint: json['sha256Thumbprint'] as String?,
      bytes: json['bytes'] as String?,
      plainSha1: X509CertificatePublicKeyData.plainSha1FromJson(
          json['plainSha1'] as List<int>?),
      algorithmReadableName: json['algorithmReadableName'] as String?,
      parameter: json['parameter'] as String?,
      parameterReadableName: json['parameterReadableName'] as String?,
      exponent: json['exponent'] as int?,
    );

Map<String, dynamic> _$X509CertificatePublicKeyDataToJson(
    X509CertificatePublicKeyData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('algorithm', instance.algorithm);
  writeNotNull('algorithmReadableName', instance.algorithmReadableName);
  writeNotNull('parameter', instance.parameter);
  writeNotNull('parameterReadableName', instance.parameterReadableName);
  writeNotNull('length', instance.length);
  writeNotNull('sha1Thumbprint', instance.sha1Thumbprint);
  writeNotNull('sha256Thumbprint', instance.sha256Thumbprint);
  writeNotNull('bytes', instance.bytes);
  writeNotNull('plainSha1',
      X509CertificatePublicKeyData.plainSha1ToJson(instance.plainSha1));
  writeNotNull('exponent', instance.exponent);
  return val;
}
