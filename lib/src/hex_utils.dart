import 'dart:typed_data';

class HexUtils {
  ///
  /// Converts the given [hex] to [Uint8List]
  ///
  static Uint8List decode(String hex) {
    var str = hex.replaceAll(" ", "");
    str = str.toLowerCase();
    if (str.length % 2 != 0) {
      str = "0" + str;
    }
    var l = str.length ~/ 2;
    var result = new Uint8List(l);
    for (var i = 0; i < l; ++i) {
      var x = int.parse(str.substring(i * 2, (2 * (i + 1))), radix: 16);
      if (x.isNaN) {
        throw ArgumentError('Expected hex string');
      }
      result[i] = x;
    }
    return result;
  }

  ///
  /// Converts the given [bytes] to hex string
  ///
  static String encode(Uint8List bytes) {
    var sb = StringBuffer();
    for (var b in bytes) {
      var s = b.toRadixString(16).toUpperCase();
      if (s.length == 1) {
        s = '0$s';
      }
      sb.write(s);
    }
    return sb.toString();
  }
}
