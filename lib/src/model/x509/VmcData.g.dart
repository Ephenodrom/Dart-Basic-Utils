// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VmcData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcData _$VmcDataFromJson(Map<String, dynamic> json) {
  return VmcData(
    base64Logo: json['base64Logo'] as String?,
    hash: json['hash'] as String?,
    hashAlgorithm: json['hashAlgorithm'] as String?,
    type: json['type'] as String?,
  );
}

Map<String, dynamic> _$VmcDataToJson(VmcData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('base64Logo', instance.base64Logo);
  writeNotNull('type', instance.type);
  writeNotNull('hash', instance.hash);
  writeNotNull('hashAlgorithm', instance.hashAlgorithm);
  return val;
}
