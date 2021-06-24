// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Pkcs7CertificateData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pkcs7CertificateData _$Pkcs7CertificateDataFromJson(Map<String, dynamic> json) {
  return Pkcs7CertificateData(
    certificates: (json['certificates'] as List<dynamic>?)
        ?.map((e) => X509CertificateData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$Pkcs7CertificateDataToJson(
    Pkcs7CertificateData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'certificates', instance.certificates?.map((e) => e.toJson()).toList());
  return val;
}
