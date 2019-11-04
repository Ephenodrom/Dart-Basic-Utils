import 'dart:typed_data';

///
/// Model that a public key from a X509Certificate
///
class X509CertificatePublicKeyData {
  /// The algorithm of the public key
  String algorithm;

  /// The key length of the public key
  int length;

  /// The sha1 thumbprint of the public key
  String sha1Thumbprint;

  /// The bytes representing the public key
  Uint8List bytes;

  X509CertificatePublicKeyData(
      {this.algorithm, this.length, this.sha1Thumbprint, this.bytes});

  ///
  /// Converts the bytes to a hex string
  ///
  String bytesAsString() {
    StringBuffer b = StringBuffer();
    bytes.forEach((v) {
      String s = v.toRadixString(16);
      if (s.length == 1) {
        b.write("0$s");
      } else {
        b.write(s);
      }
    });
    return b.toString().toUpperCase();
  }
}
