// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificateValidity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificateValidity _$X509CertificateValidityFromJson(
        Map<String, dynamic> json) =>
    X509CertificateValidity(
      notBefore: DateTime.parse(json['notBefore'] as String),
      notAfter: DateTime.parse(json['notAfter'] as String),
    );

Map<String, dynamic> _$X509CertificateValidityToJson(
        X509CertificateValidity instance) =>
    <String, dynamic>{
      'notBefore': instance.notBefore.toIso8601String(),
      'notAfter': instance.notAfter.toIso8601String(),
    };
