// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificateDataExtensions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificateDataExtensions _$X509CertificateDataExtensionsFromJson(
    Map<String, dynamic> json) {
  return X509CertificateDataExtensions(
    subjectAlternativNames: (json['subjectAlternativNames'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    extKeyUsage: (json['extKeyUsage'] as List<dynamic>?)
        ?.map((e) => _$enumDecode(_$ExtendedKeyUsageEnumMap, e))
        .toList(),
    vmc: json['vmc'] == null
        ? null
        : VmcData.fromJson(json['vmc'] as Map<String, dynamic>),
  );
}

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
      instance.extKeyUsage?.map((e) => _$ExtendedKeyUsageEnumMap[e]).toList());
  writeNotNull('vmc', instance.vmc?.toJson());
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
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
