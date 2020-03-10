// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResolveResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveResponse _$ResolveResponseFromJson(Map<String, dynamic> json) {
  return ResolveResponse(
    status: json['Status'] as int,
    tc: json['TC'] as bool,
    rd: json['RD'] as bool,
    ra: json['RA'] as bool,
    ad: json['AD'] as bool,
    cd: json['CD'] as bool,
    question: (json['Question'] as List)
        ?.map((e) =>
            e == null ? null : Question.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    answer: (json['Answer'] as List)
        ?.map((e) =>
            e == null ? null : RRecord.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    comment: json['Comment'] as String,
  );
}

Map<String, dynamic> _$ResolveResponseToJson(ResolveResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Status', instance.status);
  writeNotNull('TC', instance.tc);
  writeNotNull('RD', instance.rd);
  writeNotNull('RA', instance.ra);
  writeNotNull('AD', instance.ad);
  writeNotNull('CD', instance.cd);
  writeNotNull('Question', instance.question);
  writeNotNull('Answer', instance.answer);
  writeNotNull('Comment', instance.comment);
  return val;
}
