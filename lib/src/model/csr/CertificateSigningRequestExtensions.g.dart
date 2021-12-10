// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CertificateSigningRequestExtensions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateSigningRequestExtensions
    _$CertificateSigningRequestExtensionsFromJson(Map<String, dynamic> json) =>
        CertificateSigningRequestExtensions(
          subjectAlternativNames:
              (json['subjectAlternativNames'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList(),
        );

Map<String, dynamic> _$CertificateSigningRequestExtensionsToJson(
    CertificateSigningRequestExtensions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('subjectAlternativNames', instance.subjectAlternativNames);
  return val;
}
