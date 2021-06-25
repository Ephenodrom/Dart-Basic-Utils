// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubjectPublicKeyInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectPublicKeyInfo _$SubjectPublicKeyInfoFromJson(Map<String, dynamic> json) {
  return SubjectPublicKeyInfo(
    algorithm: json['algorithm'] as String?,
    length: json['length'] as int?,
    sha1Thumbprint: json['sha1Thumbprint'] as String?,
    sha256Thumbprint: json['sha256Thumbprint'] as String?,
    bytes: json['bytes'] as String?,
    algorithmReadableName: json['algorithmReadableName'] as String?,
  );
}

Map<String, dynamic> _$SubjectPublicKeyInfoToJson(
    SubjectPublicKeyInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('algorithm', instance.algorithm);
  writeNotNull('algorithmReadableName', instance.algorithmReadableName);
  writeNotNull('length', instance.length);
  writeNotNull('sha1Thumbprint', instance.sha1Thumbprint);
  writeNotNull('sha256Thumbprint', instance.sha256Thumbprint);
  writeNotNull('bytes', instance.bytes);
  return val;
}
