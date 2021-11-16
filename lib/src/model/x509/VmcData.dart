import 'package:json_annotation/json_annotation.dart';

part 'VmcData.g.dart';

///
/// Model that represents a verified mark certificate data
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class VmcData {
  /// The base64 encoded logo
  String? base64Logo;

  /// The logo type
  String? type;

  /// The hash
  String? hash;

  /// The readable version of the algorithm of the hash
  String? hashAlgorithmReadable;

  /// The algorithm of the hash
  String? hashAlgorithm;

  VmcData({
    this.base64Logo,
    this.hash,
    this.hashAlgorithm,
    this.hashAlgorithmReadable,
    this.type,
  });

  ///
  ///Json to VmcData object
  ///
  factory VmcData.fromJson(Map<String, dynamic> json) =>
      _$VmcDataFromJson(json);

  ///
  /// VmcData object to json
  ///
  Map<String, dynamic> toJson() => _$VmcDataToJson(this);

  String getFullSvgData() {
    return 'data:$type;base64,$base64Logo';
  }
}
