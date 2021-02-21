import 'package:basic_utils/src/model/Question.dart';
import 'package:basic_utils/src/model/RRecord.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ResolveResponse.g.dart';

@JsonSerializable(includeIfNull: false)
class ResolveResponse {
  @JsonKey(name: 'Status')
  int? status;
  @JsonKey(name: 'TC')
  bool? tc;
  @JsonKey(name: 'RD')
  bool? rd;
  @JsonKey(name: 'RA')
  bool? ra;
  @JsonKey(name: 'AD')
  bool? ad;
  @JsonKey(name: 'CD')
  bool? cd;
  @JsonKey(name: 'Question')
  List<Question>? question;
  @JsonKey(name: 'Answer')
  List<RRecord>? answer;
  @JsonKey(name: 'Comment')
  String? comment;

  ResolveResponse(
      {this.status,
      this.tc,
      this.rd,
      this.ra,
      this.ad,
      this.cd,
      this.question,
      this.answer,
      this.comment});

  /*
   * Json to ResolveResponse object
   */
  factory ResolveResponse.fromJson(Map<String, dynamic> json) =>
      _$ResolveResponseFromJson(json);

  /*
   * ResolveResponse object to json
   */
  Map<String, dynamic> toJson() => _$ResolveResponseToJson(this);
}
