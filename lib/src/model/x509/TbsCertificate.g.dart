// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TbsCertificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TbsCertificate _$TbsCertificateFromJson(Map<String, dynamic> json) =>
    TbsCertificate(
      version: json['version'] as int,
      serialNumber: BigInt.parse(json['serialNumber'] as String),
      issuer: Map<String, String?>.from(json['issuer'] as Map),
      validity: X509CertificateValidity.fromJson(
          json['validity'] as Map<String, dynamic>),
      subject: Map<String, String?>.from(json['subject'] as Map),
      subjectPublicKeyInfo: SubjectPublicKeyInfo.fromJson(
          json['subjectPublicKeyInfo'] as Map<String, dynamic>),
      signatureAlgorithm: json['signatureAlgorithm'] as String,
      signatureAlgorithmReadableName:
          json['signatureAlgorithmReadableName'] as String?,
      extensions: json['extensions'] == null
          ? null
          : X509CertificateDataExtensions.fromJson(
              json['extensions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TbsCertificateToJson(TbsCertificate instance) {
  final val = <String, dynamic>{
    'version': instance.version,
    'serialNumber': instance.serialNumber.toString(),
    'signatureAlgorithm': instance.signatureAlgorithm,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('signatureAlgorithmReadableName',
      instance.signatureAlgorithmReadableName);
  val['issuer'] = instance.issuer;
  val['validity'] = instance.validity.toJson();
  val['subject'] = instance.subject;
  val['subjectPublicKeyInfo'] = instance.subjectPublicKeyInfo.toJson();
  writeNotNull('extensions', instance.extensions?.toJson());
  return val;
}
