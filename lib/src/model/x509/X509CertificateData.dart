import 'package:basic_utils/src/model/x509/ExtendedKeyUsage.dart';
import 'package:basic_utils/src/model/x509/TbsCertificate.dart';
import 'package:basic_utils/src/model/x509/X509CertificateDataExtensions.dart';
import 'package:basic_utils/src/model/x509/X509CertificatePublicKeyData.dart';
import 'package:json_annotation/json_annotation.dart';

import 'X509CertificateValidity.dart';

part 'X509CertificateData.g.dart';

///
/// Model that represents the data of a x509Certificate
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class X509CertificateData {
  /// The tbsCertificate data
  TbsCertificate tbsCertificate;

  /// The version of the certificate
  @Deprecated('Use tbsCertificate.version instead')
  int version;

  /// The serialNumber of the certificate
  @Deprecated('Use tbsCertificate.serialNumber instead')
  BigInt serialNumber;

  /// The signatureAlgorithm of the certificate
  String signatureAlgorithm;

  /// The readable name of the signatureAlgorithm of the certificate
  String? signatureAlgorithmReadableName;

  /// The issuer data of the certificate
  @Deprecated('Use tbsCertificate.issuer instead')
  Map<String, String?> issuer;

  /// The validity of the certificate
  @Deprecated('Use tbsCertificate.validity instead')
  X509CertificateValidity validity;

  /// The subject data of the certificate
  @Deprecated('Use tbsCertificate.subject instead')
  Map<String, String?> subject;

  /// The sha1 thumbprint for the certificate
  String? sha1Thumbprint;

  /// The sha256 thumbprint for the certificate
  String? sha256Thumbprint;

  /// The md5 thumbprint for the certificate
  String? md5Thumbprint;

  /// The public key data from the certificate
  @Deprecated('Use tbsCertificate.subjectPublicKeyInfo instead')
  X509CertificatePublicKeyData publicKeyData;

  /// The subject alternative names
  @Deprecated('Use extensions.subjectAlternativNames instead')
  List<String>? subjectAlternativNames;

  /// The plain certificate pem string, that was used to decode.
  String? plain;

  /// The extended key usage extension
  @Deprecated('Use extensions.extKeyUsage instead')
  List<ExtendedKeyUsage>? extKeyUsage;

  /// The certificate extensions
  @Deprecated('Use tbsCertificate.extensions instead')
  X509CertificateDataExtensions? extensions;

  /// The signature
  String signature;

  /// The tbsCertificateSeq as base64 string
  String? tbsCertificateSeqAsString;

  X509CertificateData({
    required this.version,
    required this.serialNumber,
    required this.signatureAlgorithm,
    required this.issuer,
    required this.validity,
    required this.subject,
    required this.tbsCertificate,
    this.signatureAlgorithmReadableName,
    this.sha1Thumbprint,
    this.sha256Thumbprint,
    this.md5Thumbprint,
    required this.publicKeyData,
    required this.subjectAlternativNames,
    this.plain,
    this.extKeyUsage,
    this.extensions,
    this.tbsCertificateSeqAsString,
    required this.signature,
  });

  /*
   * Json to X509CertificateData object
   */
  factory X509CertificateData.fromJson(Map<String, dynamic> json) =>
      _$X509CertificateDataFromJson(json);

  /*
   * X509CertificateData object to json
   */
  Map<String, dynamic> toJson() => _$X509CertificateDataToJson(this);
}
