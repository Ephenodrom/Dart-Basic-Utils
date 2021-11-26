// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Pkcs7CertificateData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pkcs7CertificateData _$Pkcs7CertificateDataFromJson(
        Map<String, dynamic> json) =>
    Pkcs7CertificateData(
      version: json['version'] as int?,
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((e) => X509CertificateData.fromJson(e as Map<String, dynamic>))
          .toList(),
      contentType: json['contentType'] as String?,
    );

Map<String, dynamic> _$Pkcs7CertificateDataToJson(
    Pkcs7CertificateData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('version', instance.version);
  writeNotNull('contentType', instance.contentType);
  writeNotNull(
      'certificates', instance.certificates?.map((e) => e.toJson()).toList());
  return val;
}
