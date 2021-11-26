// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RRecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RRecord _$RRecordFromJson(Map<String, dynamic> json) => RRecord(
      name: json['name'] as String,
      rType: json['type'] as int,
      ttl: json['TTL'] as int,
      data: json['data'] as String,
    );

Map<String, dynamic> _$RRecordToJson(RRecord instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.rType,
      'TTL': instance.ttl,
      'data': instance.data,
    };
