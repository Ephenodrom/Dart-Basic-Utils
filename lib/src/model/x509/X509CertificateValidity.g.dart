// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificateValidity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificateValidity _$X509CertificateValidityFromJson(
    Map<String, dynamic> json) {
  return X509CertificateValidity(
    notBefore: json['notBefore'] == null
        ? null
        : DateTime.parse(json['notBefore'] as String),
    notAfter: json['notAfter'] == null
        ? null
        : DateTime.parse(json['notAfter'] as String),
  );
}

Map<String, dynamic> _$X509CertificateValidityToJson(
    X509CertificateValidity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('notBefore', instance.notBefore?.toIso8601String());
  writeNotNull('notAfter', instance.notAfter?.toIso8601String());
  return val;
}
