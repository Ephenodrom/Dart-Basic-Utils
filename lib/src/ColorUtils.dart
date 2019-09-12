import 'package:basic_utils/basic_utils.dart';

///
/// Helper class for color operations.
///
class ColorUtils {
  static const String BASIC_COLOR_RED = "red";
  static const String BASIC_COLOR_GREEN = "green";
  static const String BASIC_COLOR_BLUE = "blue";
  static const String HEX_BLACK = "#000000";
  static const String HEX_WHITE = "#FFFFFF";

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
  /// Converts the given [color] integer to the corresponding hex string with a leading #.
  ///
  static String intToHex(int color) {
    return "#" + color.toRadixString(16).substring(2).toUpperCase();
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
    Map<String, int> bC = basicColorsFromHex(hex);

    int R = (bC[BASIC_COLOR_RED] * (100 + percent) / 100).round();
    int G = (bC[BASIC_COLOR_GREEN] * (100 + percent) / 100).round();
    int B = (bC[BASIC_COLOR_BLUE] * (100 + percent) / 100).round();

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

  ///
  /// Fills up the given 3 char [hex] string to 6 char hex string.
  ///
  /// Will add a # to the [hex] string if it is missing.
  ///
  static bool isDark(String hex) {
    Map<String, int> bC = basicColorsFromHex(hex);

    return calculateRelativeLuminance(
            bC[BASIC_COLOR_RED], bC[BASIC_COLOR_GREEN], bC[BASIC_COLOR_BLUE]) <
        0.5;
  }

  ///
  /// Calculates the limunance for the given [hex] color and returns black as hex for bright colors, white as hex for dark colors.
  ///
  static String contrastColor(String hex) {
    Map<String, int> bC = basicColorsFromHex(hex);

    double luminance = calculateRelativeLuminance(
        bC[BASIC_COLOR_RED], bC[BASIC_COLOR_GREEN], bC[BASIC_COLOR_BLUE]);
    return luminance > 0.5 ? HEX_BLACK : HEX_WHITE;
  }

  ///
  /// Fetches the basic color int values for red, green, blue from the given [hex] string.
  ///
  static Map<String, int> basicColorsFromHex(String hex) {
    hex = fillUpHex(hex);

    if (!hex.startsWith("#")) {
      hex = "#" + hex;
    }

    int R = int.parse(hex.substring(1, 3), radix: 16);
    int G = int.parse(hex.substring(3, 5), radix: 16);
    int B = int.parse(hex.substring(5, 7), radix: 16);
    return {BASIC_COLOR_RED: R, BASIC_COLOR_GREEN: G, BASIC_COLOR_BLUE: B};
  }

  ///
  /// Calculates the relative luminance for the given [red], [green], [blue] values.
  ///
  static double calculateRelativeLuminance(int red, int green, int blue,
      {int decimals = 2}) {
    return MathUtils.round(
        (0.299 * red + 0.587 * green + 0.114 * blue) / 255, decimals);
  }
}
