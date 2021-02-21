// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificateData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificateData _$X509CertificateDataFromJson(Map<String, dynamic> json) {
  return X509CertificateData(
    version: json['version'] as int?,
    serialNumber: json['serialNumber'] == null
        ? null
        : BigInt.parse(json['serialNumber'] as String),
    signatureAlgorithm: json['signatureAlgorithm'] as String?,
    issuer: (json['issuer'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String?),
    ),
    validity: json['validity'] == null
        ? null
        : X509CertificateValidity.fromJson(
            json['validity'] as Map<String, dynamic>),
    subject: (json['subject'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String?),
    ),
    sha1Thumbprint: json['sha1Thumbprint'] as String?,
    sha256Thumbprint: json['sha256Thumbprint'] as String?,
    md5Thumbprint: json['md5Thumbprint'] as String?,
    publicKeyData: json['publicKeyData'] == null
        ? null
        : X509CertificatePublicKeyData.fromJson(
            json['publicKeyData'] as Map<String, dynamic>),
    subjectAlternativNames: (json['subjectAlternativNames'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    plain: json['plain'] as String?,
  );
}

Map<String, dynamic> _$X509CertificateDataToJson(X509CertificateData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('version', instance.version);
  writeNotNull('serialNumber', instance.serialNumber?.toString());
  writeNotNull('signatureAlgorithm', instance.signatureAlgorithm);
  writeNotNull('issuer', instance.issuer);
  writeNotNull('validity', instance.validity?.toJson());
  writeNotNull('subject', instance.subject);
  writeNotNull('sha1Thumbprint', instance.sha1Thumbprint);
  writeNotNull('sha256Thumbprint', instance.sha256Thumbprint);
  writeNotNull('md5Thumbprint', instance.md5Thumbprint);
  writeNotNull('publicKeyData', instance.publicKeyData?.toJson());
  writeNotNull('subjectAlternativNames', instance.subjectAlternativNames);
  writeNotNull('plain', instance.plain);
  return val;
}
