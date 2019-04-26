// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResolveResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveResponse _$ResolveResponseFromJson(Map<String, dynamic> json) {
  return ResolveResponse(
      Status: json['Status'] as int,
      TC: json['TC'] as bool,
      RD: json['RD'] as bool,
      RA: json['RA'] as bool,
      AD: json['AD'] as bool,
      CD: json['CD'] as bool,
      question: (json['Question'] as List)
          ?.map((e) =>
              e == null ? null : Question.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      answer: (json['Answer'] as List)
          ?.map((e) =>
              e == null ? null : RRecord.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ResolveResponseToJson(ResolveResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Status', instance.Status);
  writeNotNull('TC', instance.TC);
  writeNotNull('RD', instance.RD);
  writeNotNull('RA', instance.RA);
  writeNotNull('AD', instance.AD);
  writeNotNull('CD', instance.CD);
  writeNotNull('question', instance.question);
  writeNotNull('answer', instance.answer);
  return val;
}
