// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RRecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RRecord _$RRecordFromJson(Map<String, dynamic> json) {
  return RRecord(
      name: json['name'] as String,
      type: json['type'] as int,
      TTL: json['TTL'] as int,
      data: json['data'] as String);
}

Map<String, dynamic> _$RRecordToJson(RRecord instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('type', instance.type);
  writeNotNull('TTL', instance.TTL);
  writeNotNull('data', instance.data);
  return val;
}
