// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificateData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificateData _$X509CertificateDataFromJson(Map<String, dynamic> json) =>
    X509CertificateData(
      version: json['version'] as int,
      serialNumber: BigInt.parse(json['serialNumber'] as String),
      signatureAlgorithm: json['signatureAlgorithm'] as String,
      issuer: Map<String, String?>.from(json['issuer'] as Map),
      validity: X509CertificateValidity.fromJson(
          json['validity'] as Map<String, dynamic>),
      subject: Map<String, String?>.from(json['subject'] as Map),
      tbsCertificate: json['tbsCertificate'] == null
          ? null
          : TbsCertificate.fromJson(
              json['tbsCertificate'] as Map<String, dynamic>),
      signatureAlgorithmReadableName:
          json['signatureAlgorithmReadableName'] as String?,
      sha1Thumbprint: json['sha1Thumbprint'] as String?,
      sha256Thumbprint: json['sha256Thumbprint'] as String?,
      md5Thumbprint: json['md5Thumbprint'] as String?,
      publicKeyData: X509CertificatePublicKeyData.fromJson(
          json['publicKeyData'] as Map<String, dynamic>),
      subjectAlternativNames: (json['subjectAlternativNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      plain: json['plain'] as String?,
      extKeyUsage: (json['extKeyUsage'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ExtendedKeyUsageEnumMap, e))
          .toList(),
      extensions: json['extensions'] == null
          ? null
          : X509CertificateDataExtensions.fromJson(
              json['extensions'] as Map<String, dynamic>),
      tbsCertificateSeqAsString: json['tbsCertificateSeqAsString'] as String?,
      signature: json['signature'] as String?,
    );

Map<String, dynamic> _$X509CertificateDataToJson(X509CertificateData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tbsCertificate', instance.tbsCertificate?.toJson());
  val['version'] = instance.version;
  val['serialNumber'] = instance.serialNumber.toString();
  val['signatureAlgorithm'] = instance.signatureAlgorithm;
  writeNotNull('signatureAlgorithmReadableName',
      instance.signatureAlgorithmReadableName);
  val['issuer'] = instance.issuer;
  val['validity'] = instance.validity.toJson();
  val['subject'] = instance.subject;
  writeNotNull('sha1Thumbprint', instance.sha1Thumbprint);
  writeNotNull('sha256Thumbprint', instance.sha256Thumbprint);
  writeNotNull('md5Thumbprint', instance.md5Thumbprint);
  val['publicKeyData'] = instance.publicKeyData.toJson();
  writeNotNull('subjectAlternativNames', instance.subjectAlternativNames);
  writeNotNull('plain', instance.plain);
  writeNotNull('extKeyUsage',
      instance.extKeyUsage?.map((e) => _$ExtendedKeyUsageEnumMap[e]!).toList());
  writeNotNull('extensions', instance.extensions?.toJson());
  val['signature'] = instance.signature;
  writeNotNull('tbsCertificateSeqAsString', instance.tbsCertificateSeqAsString);
  return val;
}

const _$ExtendedKeyUsageEnumMap = {
  ExtendedKeyUsage.SERVER_AUTH: 'SERVER_AUTH',
  ExtendedKeyUsage.CLIENT_AUTH: 'CLIENT_AUTH',
  ExtendedKeyUsage.CODE_SIGNING: 'CODE_SIGNING',
  ExtendedKeyUsage.EMAIL_PROTECTION: 'EMAIL_PROTECTION',
  ExtendedKeyUsage.TIME_STAMPING: 'TIME_STAMPING',
  ExtendedKeyUsage.OCSP_SIGNING: 'OCSP_SIGNING',
  ExtendedKeyUsage.BIMI: 'BIMI',
};
