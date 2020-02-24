import 'dart:typed_data';

import 'package:crypto/crypto.dart';

///
/// Helper class for cryptographic operations
///
class CryptoUtils {
  ///
  /// Get a SHA1 Thumbprint for the given [bytes].
  ///
  static String getSha1ThumbprintFromBytes(Uint8List bytes) {
    var digest = sha1.convert(bytes);
    return digest.toString().toUpperCase();
  }

  ///
  /// Get a SHA256 Thumbprint for the given [bytes].
  ///
  static String getSha256ThumbprintFromBytes(Uint8List bytes) {
    var digest = sha256.convert(bytes);
    return digest.toString().toUpperCase();
  }

  ///
  /// Get a MD5 Thumbprint for the given [bytes].
  ///
  static String getMd5ThumbprintFromBytes(Uint8List bytes) {
    var digest = md5.convert(bytes);
    return digest.toString().toUpperCase();
  }
}
