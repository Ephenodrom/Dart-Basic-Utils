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
    Digest digest = sha1.convert(bytes);
    return digest.toString().toUpperCase();
  }

  ///
  /// Get a MD5 Thumbprint for the given [bytes].
  ///
  static String getMd5ThumbprintFromBytes(Uint8List bytes) {
    Digest digest = md5.convert(bytes);
    return digest.toString().toUpperCase();
  }
}
