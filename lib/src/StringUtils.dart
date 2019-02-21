part of basic_utils;

///
/// Helper class for String operations
///
class StringUtils {
  static AsciiCodec asciiCodec = new AsciiCodec();

  ///
  /// Returns the given string or the default string if the given string is null
  ///
  static String defaultString(String str, [String defaultStr = '']) {
    return str == null ? defaultStr : str;
  }

  ///
  /// Checks if the given string is null or empty
  ///
  static bool isNullOrEmpty(String s) =>
      (s == null || s.length == 0) ? true : false;

  ///
  /// Checks if the given string is not null or empty
  ///
  static bool isNotNullOrEmpty(String s) => !isNullOrEmpty(s);

  ///
  /// Transfers the given String from camcelCase to upperCaseUnderscore
  /// Example : helloWorld => HELLO_WORLD
  ///
  static String camelCaseToUpperUnderscore(String s) {
    StringBuffer sb = new StringBuffer();
    bool first = true;
    s.runes.forEach((int rune) {
      String char = String.fromCharCode(rune);
      if (isUpperCase(char) && !first) {
        sb.write("_");
        sb.write(char.toUpperCase());
      } else {
        first = false;
        sb.write(char.toUpperCase());
      }
    });
    return sb.toString();
  }

  ///
  /// Transfers the given String from camcelCase to lpperCaseUnderscore
  /// Example : helloWorld => hello_world
  ///
  static String camelCaseToLowerUnderscore(String s) {
    StringBuffer sb = new StringBuffer();
    bool first = true;
    s.runes.forEach((int rune) {
      String char = String.fromCharCode(rune);
      if (isUpperCase(char) && !first) {
        sb.write("_");
        sb.write(char.toLowerCase());
      } else {
        first = false;
        sb.write(char.toLowerCase());
      }
    });
    return sb.toString();
  }

  ///
  /// Checks if the given string is lower case
  ///
  static bool isLowerCase(String s) {
    return s == s.toLowerCase();
  }

  ///
  /// Checks if the given string is upper case
  ///
  static bool isUpperCase(String s) {
    return s == s.toUpperCase();
  }

  ///
  /// Checks if the given string contains only ascii chars
  ///
  static bool isAscii(String s) {
    try {
      asciiCodec.decode(s.codeUnits);
    } catch (e) {
      return false;
    }
    return true;
  }
}
