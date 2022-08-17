// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CertificationRequestInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificationRequestInfo _$CertificationRequestInfoFromJson(
        Map<String, dynamic> json) =>
    CertificationRequestInfo(
      subject: (json['subject'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      version: json['version'] as int?,
      publicKeyInfo: json['publicKeyInfo'] == null
          ? null
          : SubjectPublicKeyInfo.fromJson(
              json['publicKeyInfo'] as Map<String, dynamic>),
      extensions: json['extensions'] == null
          ? null
          : CertificateSigningRequestExtensions.fromJson(
              json['extensions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CertificationRequestInfoToJson(
    CertificationRequestInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('version', instance.version);
  writeNotNull('subject', instance.subject);
  writeNotNull('publicKeyInfo', instance.publicKeyInfo?.toJson());
  writeNotNull('extensions', instance.extensions?.toJson());
  return val;
}
