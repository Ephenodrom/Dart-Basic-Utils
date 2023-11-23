// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificateDataExtensions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificateDataExtensions _$X509CertificateDataExtensionsFromJson(
        Map<String, dynamic> json) =>
    X509CertificateDataExtensions(
      subjectAlternativNames: (json['subjectAlternativNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      extKeyUsage: (json['extKeyUsage'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ExtendedKeyUsageEnumMap, e))
          .toList(),
      keyUsage: (json['keyUsage'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$KeyUsageEnumMap, e))
          .toList(),
      cA: json['cA'] as bool?,
      pathLenConstraint: json['pathLenConstraint'] as int?,
      vmc: json['vmc'] == null
          ? null
          : VmcData.fromJson(json['vmc'] as Map<String, dynamic>),
      cRLDistributionPoints: (json['cRLDistributionPoints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$X509CertificateDataExtensionsToJson(
    X509CertificateDataExtensions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('subjectAlternativNames', instance.subjectAlternativNames);
  writeNotNull('extKeyUsage',
      instance.extKeyUsage?.map((e) => _$ExtendedKeyUsageEnumMap[e]!).toList());
  writeNotNull('keyUsage',
      instance.keyUsage?.map((e) => _$KeyUsageEnumMap[e]!).toList());
  writeNotNull('cA', instance.cA);
  writeNotNull('pathLenConstraint', instance.pathLenConstraint);
  writeNotNull('vmc', instance.vmc?.toJson());
  writeNotNull('cRLDistributionPoints', instance.cRLDistributionPoints);
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

const _$KeyUsageEnumMap = {
  KeyUsage.DIGITAL_SIGNATURE: 'DIGITAL_SIGNATURE',
  KeyUsage.NON_REPUDIATION: 'NON_REPUDIATION',
  KeyUsage.KEY_ENCIPHERMENT: 'KEY_ENCIPHERMENT',
  KeyUsage.DATA_ENCIPHERMENT: 'DATA_ENCIPHERMENT',
  KeyUsage.KEY_AGREEMENT: 'KEY_AGREEMENT',
  KeyUsage.KEY_CERT_SIGN: 'KEY_CERT_SIGN',
  KeyUsage.CRL_SIGN: 'CRL_SIGN',
  KeyUsage.ENCIPHER_ONLY: 'ENCIPHER_ONLY',
  KeyUsage.DECIPHER_ONLY: 'DECIPHER_ONLY',
};
