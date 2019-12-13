// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'X509CertificateObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X509CertificateObject _$X509CertificateObjectFromJson(
    Map<String, dynamic> json) {
  return X509CertificateObject(
    json['data'] == null
        ? null
        : X509CertificateData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$X509CertificateObjectToJson(
    X509CertificateObject instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('data', instance.data?.toJson());
  return val;
}
