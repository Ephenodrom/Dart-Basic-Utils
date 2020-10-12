import 'package:basic_utils/basic_utils.dart';

///
/// Helper class for color operations.
///
class ColorUtils {
  static const String BASIC_COLOR_RED = 'red';
  static const String BASIC_COLOR_GREEN = 'green';
  static const String BASIC_COLOR_BLUE = 'blue';
  static const String HEX_BLACK = '#000000';
  static const String HEX_WHITE = '#FFFFFF';

  ///
  /// Converts the given [hex] color string to the corresponding int.
  ///
  /// Note that when no alpha/opacity is specified, 0xFF is assumed.
  ///
  static int hexToInt(String hex) {
    final hexDigits = hex.startsWith('#') ? hex.substring(1) : hex;
    final hexMask = hexDigits.length <= 6 ? 0xFF000000 : 0;
    final hexValue = int.parse(hexDigits, radix: 16);
    assert(hexValue >= 0 && hexValue <= 0xFFFFFFFF);
    return hexValue | hexMask;
  }

  ///
  /// Converts the given integer [i] to a hex string with a leading #.
  ///
  /// Note that only the RGB values will be returned (like #RRGGBB), so
  /// and alpha/opacity value will be stripped.
  ///
  static String intToHex(int i) {
    assert(i >= 0 && i <= 0xFFFFFFFF);
    return '#${(i & 0xFFFFFF | 0x1000000).toRadixString(16).substring(1).toUpperCase()}';
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
    var bC = basicColorsFromHex(hex);

    var R = (bC[BASIC_COLOR_RED] * (100 + percent) / 100).round();
    var G = (bC[BASIC_COLOR_GREEN] * (100 + percent) / 100).round();
    var B = (bC[BASIC_COLOR_BLUE] * (100 + percent) / 100).round();

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

    var RR = ((R.toRadixString(16).length == 1)
        ? '0' + R.toRadixString(16)
        : R.toRadixString(16));
    var GG = ((G.toRadixString(16).length == 1)
        ? '0' + G.toRadixString(16)
        : G.toRadixString(16));
    var BB = ((B.toRadixString(16).length == 1)
        ? '0' + B.toRadixString(16)
        : B.toRadixString(16));

    return '#' + RR + GG + BB;
  }

  ///
  /// Fills up the given 3 char [hex] string to 6 char hex string.
  ///
  /// Will add a # to the [hex] string if it is missing.
  ///
  static String fillUpHex(String hex) {
    if (!hex.startsWith('#')) {
      hex = '#' + hex;
    }

    if (hex.length == 7) {
      return hex;
    }

    var filledUp = '';
    hex.runes.forEach((r) {
      var char = String.fromCharCode(r);
      if (char == '#') {
        filledUp = filledUp + char;
      } else {
        filledUp = filledUp + char + char;
      }
    });
    return filledUp;
  }

  ///
  /// Returns true or false if the calculated relative luminance from the given [hex] is less than 0.5.
  ///
  static bool isDark(String hex) {
    var bC = basicColorsFromHex(hex);

    return calculateRelativeLuminance(
            bC[BASIC_COLOR_RED], bC[BASIC_COLOR_GREEN], bC[BASIC_COLOR_BLUE]) <
        0.5;
  }

  ///
  /// Calculates the limunance for the given [hex] color and returns black as hex for bright colors, white as hex for dark colors.
  ///
  static String contrastColor(String hex) {
    var bC = basicColorsFromHex(hex);

    var luminance = calculateRelativeLuminance(
        bC[BASIC_COLOR_RED], bC[BASIC_COLOR_GREEN], bC[BASIC_COLOR_BLUE]);
    return luminance > 0.5 ? HEX_BLACK : HEX_WHITE;
  }

  ///
  /// Fetches the basic color int values for red, green, blue from the given [hex] string.
  ///
  /// The values are returned inside a map with the following keys :
  /// * red
  /// * green
  /// * blue
  ///
  static Map<String, int> basicColorsFromHex(String hex) {
    hex = fillUpHex(hex);

    if (!hex.startsWith('#')) {
      hex = '#' + hex;
    }

    var R = int.parse(hex.substring(1, 3), radix: 16);
    var G = int.parse(hex.substring(3, 5), radix: 16);
    var B = int.parse(hex.substring(5, 7), radix: 16);
    return {BASIC_COLOR_RED: R, BASIC_COLOR_GREEN: G, BASIC_COLOR_BLUE: B};
  }

  ///
  /// Calculates the relative luminance for the given [red], [green], [blue] values.
  ///
  /// The returned value is between 0 and 1 with the given [decimals].
  ///
  static double calculateRelativeLuminance(int red, int green, int blue,
      {int decimals = 2}) {
    return MathUtils.round(
        (0.299 * red + 0.587 * green + 0.114 * blue) / 255, decimals);
  }

  ///
  /// Swatch the given [hex] color.
  ///
  /// It creates lighter and darker colors from the given [hex] returned in a list with the given [hex].
  ///
  /// The [amount] defines how much lighter or darker colors a generated.
  /// The specified [percentage] value defines the color spacing of the individual colors. As a default,
  /// each color is 15 percent lighter or darker than the previous one.
  ///
  static List<String> swatchColor(String hex,
      {double percentage = 15, int amount = 5}) {
    hex = fillUpHex(hex);

    var colors = <String>[];
    for (var i = 1; i <= amount; i++) {
      colors.add(shadeColor(hex, (6 - i) * percentage));
    }
    colors.add(hex);
    for (var i = 1; i <= amount; i++) {
      colors.add(shadeColor(hex, (0 - i) * percentage));
    }
    return colors;
  }

  ///
  /// Inverts Color Hex code
  /// Convert string to (4-bit int) and apply bitwise-NOT operation then convert back to Hex String
  /// e.g: convert white (FFFFFF) to Dark (000000).
  /// Returns Inverted String Color.
  ///
  static String invertColor(String color) {
    var invertedColor = <String>[];
    for (var i = 0; i < color.length; i++) {
      if (color[i].startsWith('#')) {
        invertedColor.add('#');
      } else {
        invertedColor.add(
            ((~int.parse('0x${color[i]}')).toUnsigned(4)).toRadixString(16));
      }
    }
    return invertedColor.join();
  }
}
