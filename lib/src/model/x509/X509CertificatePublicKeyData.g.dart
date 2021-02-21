// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificatePublicKeyData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificatePublicKeyData _$X509CertificatePublicKeyDataFromJson(
    Map<String, dynamic> json) {
  return X509CertificatePublicKeyData(
    algorithm: json['algorithm'] as String?,
    length: json['length'] as int?,
    sha1Thumbprint: json['sha1Thumbprint'] as String?,
    sha256Thumbprint: json['sha256Thumbprint'] as String?,
    bytes: json['bytes'] as String?,
  );
}

Map<String, dynamic> _$X509CertificatePublicKeyDataToJson(
    X509CertificatePublicKeyData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('algorithm', instance.algorithm);
  writeNotNull('length', instance.length);
  writeNotNull('sha1Thumbprint', instance.sha1Thumbprint);
  writeNotNull('sha256Thumbprint', instance.sha256Thumbprint);
  writeNotNull('bytes', instance.bytes);
  return val;
}
