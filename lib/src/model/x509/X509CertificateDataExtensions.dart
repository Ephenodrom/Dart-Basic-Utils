import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/x509/ExtendedKeyUsage.dart';
import 'package:basic_utils/src/model/x509/VmcData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'X509CertificateDataExtensions.g.dart';

///
/// Model that represents the extensions of a x509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class X509CertificateDataExtensions {
  /// The subject alternative names
  List<String>? subjectAlternativNames;

  /// The extended key usage extension
  List<ExtendedKeyUsage>? extKeyUsage;

  /// The key usage extension
  List<KeyUsage>? keyUsage;

  /// The cA field of the basic constraints extension
  bool? cA;

  /// The pathLenConstraint field of the basic constraints extension
  int? pathLenConstraint;

  /// The base64 encoded VMC logo
  VmcData? vmc;

  /// The distribution points for the crl files. Normally a url.
  List<String>? cRLDistributionPoints;

  X509CertificateDataExtensions({
    this.subjectAlternativNames,
    this.extKeyUsage,
    this.keyUsage,
    this.cA,
    this.pathLenConstraint,
    this.vmc,
    this.cRLDistributionPoints,
  });

  /*
   * Json to X509CertificateDataExtensions object
   */
  factory X509CertificateDataExtensions.fromJson(Map<String, dynamic> json) =>
      _$X509CertificateDataExtensionsFromJson(json);

  /*
   * X509CertificateDataExtensions object to json
   */
  Map<String, dynamic> toJson() => _$X509CertificateDataExtensionsToJson(this);
}
