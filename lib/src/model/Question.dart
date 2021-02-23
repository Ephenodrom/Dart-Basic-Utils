import 'package:json_annotation/json_annotation.dart';

part 'Question.g.dart';

@JsonSerializable(includeIfNull: false)
class Question {
  String name;

  int type;

  Question({required this.name,required this.type});

  /*
   * Json to Question object
   */
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  /*
   * Question object to json
   */
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
