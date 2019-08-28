///
/// Helper class for color operations.
///
class ColorUtils {
  ///
  /// Converts the given [hex] color string to the corresponding int
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

  ///
  /// Lightens or darkens the given [hex] color by the given [percent].
  ///
  /// To lighten a color, set the [percent] value to > 0.
  /// To darken a color, set the [percent] value to < 0.
  /// Will add a # to the [hex] string if it is missing.
  ///
  ///
  static String shadeColor(String hex, double percent) {
    hex = fillUpHex(hex);

    if (!hex.startsWith("#")) {
      hex = "#" + hex;
    }

    int R = int.parse(hex.substring(1, 3), radix: 16);
    int G = int.parse(hex.substring(3, 5), radix: 16);
    int B = int.parse(hex.substring(5, 7), radix: 16);
    print("$R $G $B");

    R = (R * (100 + percent) / 100).round();
    G = (G * (100 + percent) / 100).round();
    B = (B * (100 + percent) / 100).round();
    print("$R $G $B");

    if (R > 255) {
      R = 255;
    } else if (R < 0) {
      R = 0;
    }

    if (G > 255) {
      G = 255;
    } else if (G < 0) {
      G = 0;
    }

    if (B > 255) {
      B = 255;
    } else if (B < 0) {
      B = 0;
    }

    String RR = ((R.toRadixString(16).length == 1)
        ? "0" + R.toRadixString(16)
        : R.toRadixString(16));
    String GG = ((G.toRadixString(16).length == 1)
        ? "0" + G.toRadixString(16)
        : G.toRadixString(16));
    String BB = ((B.toRadixString(16).length == 1)
        ? "0" + B.toRadixString(16)
        : B.toRadixString(16));

    return "#" + RR + GG + BB;
  }

  ///
  /// Fills up the given 3 char [hex] string to 6 char hex string.
  ///
  /// Will add a # to the [hex] string if it is missing.
  ///
  static String fillUpHex(String hex) {
    if (!hex.startsWith("#")) {
      hex = "#" + hex;
    }

    if (hex.length == 7) {
      return hex;
    }

    String filledUp = "";
    hex.runes.forEach((r) {
      String char = new String.fromCharCode(r);
      if (char == "#") {
        filledUp = filledUp + char;
      } else {
        filledUp = filledUp + char + char;
      }
    });
    return filledUp;
  }
}
