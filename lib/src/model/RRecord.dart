import 'package:json_annotation/json_annotation.dart';

part 'RRecord.g.dart';

@JsonSerializable(includeIfNull: false)
class RRecord {
  /// The name of the record
  String name;

  /// The type of the record
  int rType;

  /// The time to live of the record
  @JsonKey(name: "TTL")
  int ttl;

  /// The data of the record
  String data;

  RRecord({this.name, this.rType, this.ttl, this.data});

  /*
   * Json to RRecord object
   */
  factory RRecord.fromJson(Map<String, dynamic> json) =>
      _$RRecordFromJson(json);

  /*
   * RRecord object to json
   */
  Map<String, dynamic> toJson() => _$RRecordToJson(this);
}
