///
/// Helper class for color operations.
///
class ColorUtils {
  ///
  /// Converts the given hex color string to the corresponding int
  ///
  static int hexToInt(String hex) {
    if (hex.startsWith("#")) {
      hex = hex.replaceFirst("#", "FF");
      return int.parse(hex, radix: 16);
    } else {
      if (hex.length == 6) {
        hex = "FF" + hex;
      }
      return int.parse(hex, radix: 16);
    }
  }
}
