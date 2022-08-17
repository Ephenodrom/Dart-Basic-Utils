import 'package:basic_utils/src/model/csr/SubjectPublicKeyInfo.dart';
import 'package:basic_utils/src/model/x509/X509CertificateDataExtensions.dart';
import 'package:basic_utils/src/model/x509/X509CertificatePublicKeyData.dart';
import 'package:json_annotation/json_annotation.dart';

import 'X509CertificateValidity.dart';

part 'TbsCertificate.g.dart';

///
/// Model that represents the data of a TbsCertificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TbsCertificate {
  /// The version of the certificate
  int version;

  /// The serialNumber of the certificate
  BigInt serialNumber;

  /// The signatureAlgorithm of the certificate
  String signatureAlgorithm;

  /// The readable name of the signatureAlgorithm of the certificate
  String? signatureAlgorithmReadableName;

  /// The issuer data of the certificate
  Map<String, String?> issuer;

  /// The validity of the certificate
  X509CertificateValidity validity;

  /// The subject data of the certificate
  Map<String, String?> subject;

  /// The public key data from the certificate
  SubjectPublicKeyInfo subjectPublicKeyInfo;

  /// The certificate extensions
  X509CertificateDataExtensions? extensions;

  TbsCertificate({
    required this.version,
    required this.serialNumber,
    required this.issuer,
    required this.validity,
    required this.subject,
    required this.subjectPublicKeyInfo,
    required this.signatureAlgorithm,
    required this.signatureAlgorithmReadableName,
    this.extensions,
  });

  /*
   * Json to TbsCertificate object
   */
  factory TbsCertificate.fromJson(Map<String, dynamic> json) =>
      _$TbsCertificateFromJson(json);

  /*
   * TbsCertificate object to json
   */
  Map<String, dynamic> toJson() => _$TbsCertificateToJson(this);
}
