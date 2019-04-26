import 'package:basic_utils/src/model/Question.dart';
import 'package:basic_utils/src/model/RRecord.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ResolveResponse.g.dart';

@JsonSerializable(includeIfNull: false)
class ResolveResponse {
  int Status;
  bool TC;
  bool RD;
  bool RA;
  bool AD;
  bool CD;
  List<Question> question;
  List<RRecord> answer;

  ResolveResponse(
      {this.Status,
      this.TC,
      this.RD,
      this.RA,
      this.AD,
      this.CD,
      this.question,
      this.answer});

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
