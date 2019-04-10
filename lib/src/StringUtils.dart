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
  /// Checks if the given String [s] is null or empty
  ///
  static bool isNullOrEmpty(String s) =>
      (s == null || s.isEmpty) ? true : false;

  ///
  /// Checks if the given String [s] is not null or empty
  ///
  static bool isNotNullOrEmpty(String s) => !isNullOrEmpty(s);

  ///
  /// Transfers the given String [s] from camcelCase to upperCaseUnderscore
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
  /// Transfers the given String [s] from camcelCase to lpperCaseUnderscore
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
  /// Checks if the given string [s] is lower case
  ///
  static bool isLowerCase(String s) {
    return s == s.toLowerCase();
  }

  ///
  /// Checks if the given string [s] is upper case
  ///
  static bool isUpperCase(String s) {
    return s == s.toUpperCase();
  }

  ///
  /// Checks if the given string [s] contains only ascii chars
  ///
  static bool isAscii(String s) {
    try {
      asciiCodec.decode(s.codeUnits);
    } catch (e) {
      return false;
    }
    return true;
  }

  ///
  /// Capitalize the given string [s]
  /// Example : world => World, WORLD => World
  ///
  static String capitalize(String s) {
    return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
  }

  ///
  /// Reverse the given string [s]
  /// Example : hello => olleh
  ///
  static String reverse(String s) {
    return new String.fromCharCodes(s.runes.toList().reversed);
  }

  ///
  /// Counts how offen the given [char] apears in the given string [s].
  /// The value [caseSensitive] controlls whether it should only look for the given [char]
  /// or also the equivalent lower/upper case version.
  /// Example: Hello and char l => 2
  ///
  static int countChars(String s, String char, {bool caseSensitive = true}) {
    int count = 0;
    s.codeUnits.toList().forEach((i) {
      if (caseSensitive) {
        if (i == char.runes.first) {
          count++;
        }
      } else {
        if (i == char.toLowerCase().runes.first ||
            i == char.toUpperCase().runes.first) {
          count++;
        }
      }
    });
    return count;
  }

  ///
  /// Checks if the given string [s] is a digit
  ///
  static bool isDigit(String s){
    if(s.length > 1){
      for(int r in s.runes){
        if(r ^ 0x30 > 9){
          return false;
        }
      }
      return true;
    }else{
      return s.runes.first ^ 0x30 <= 9;
    }
  }

///
/// Compares the given strings [a] and [b].
/// 
static bool equalsIgnoreCase(String a, String b) =>
    (a == null && b == null) ||
    (a != null && b != null && a.toLowerCase() == b.toLowerCase());
}
