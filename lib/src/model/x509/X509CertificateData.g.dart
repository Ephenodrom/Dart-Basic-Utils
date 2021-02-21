// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificateData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificateData _$X509CertificateDataFromJson(Map<String, dynamic> json) {
  return X509CertificateData(
    version: json['version'] as int,
    serialNumber: BigInt.parse(json['serialNumber'] as String),
    signatureAlgorithm: json['signatureAlgorithm'] as String,
    issuer: Map<String, String>.from(json['issuer'] as Map),
    validity: X509CertificateValidity.fromJson(
        json['validity'] as Map<String, dynamic>),
    subject: Map<String, String>.from(json['subject'] as Map),
    sha1Thumbprint: json['sha1Thumbprint'] as String,
    sha256Thumbprint: json['sha256Thumbprint'] as String,
    md5Thumbprint: json['md5Thumbprint'] as String,
    publicKeyData: X509CertificatePublicKeyData.fromJson(
        json['publicKeyData'] as Map<String, dynamic>),
    subjectAlternativNames: (json['subjectAlternativNames'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    plain: json['plain'] as String,
  );
}

Map<String, dynamic> _$X509CertificateDataToJson(X509CertificateData instance) {
  final val = <String, dynamic>{
    'version': instance.version,
    'serialNumber': instance.serialNumber.toString(),
    'signatureAlgorithm': instance.signatureAlgorithm,
    'issuer': instance.issuer,
    'validity': instance.validity.toJson(),
    'subject': instance.subject,
    'sha1Thumbprint': instance.sha1Thumbprint,
    'sha256Thumbprint': instance.sha256Thumbprint,
    'md5Thumbprint': instance.md5Thumbprint,
    'publicKeyData': instance.publicKeyData.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('subjectAlternativNames', instance.subjectAlternativNames);
  val['plain'] = instance.plain;
  return val;
}
