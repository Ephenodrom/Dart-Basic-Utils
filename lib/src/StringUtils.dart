import 'dart:convert';
import 'dart:io';
import 'dart:math';

///
/// Helper class for String operations
///
class StringUtils {
  static AsciiCodec asciiCodec = AsciiCodec();

  static final RegExp _ipv4Maybe =
      RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');
  static final RegExp _ipv6 =
      RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');

  ///
  /// Returns the given string or the default string if the given string is null
  ///
  static String defaultString(String? str, {String defaultStr = ''}) {
    return str ?? defaultStr;
  }

  ///
  /// Checks if the given String [s] is null or empty
  ///
  static bool isNullOrEmpty(String? s) =>
      (s == null || s.isEmpty) ? true : false;

  ///
  /// Checks if the given String [s] is not null or empty
  ///
  static bool isNotNullOrEmpty(String? s) => !isNullOrEmpty(s);

  ///
  /// Transfers the given String [s] from camcelCase to upperCaseUnderscore
  /// Example : helloWorld => HELLO_WORLD
  ///
  static String camelCaseToUpperUnderscore(String s) {
    var sb = StringBuffer();
    var first = true;
    s.runes.forEach((int rune) {
      var char = String.fromCharCode(rune);
      if (isUpperCase(char) && !first) {
        sb.write('_');
        sb.write(char.toUpperCase());
      } else {
        first = false;
        sb.write(char.toUpperCase());
      }
    });
    return sb.toString();
  }

  ///
  /// Transfers the given String [s] from camcelCase to lowerCaseUnderscore
  /// Example : helloWorld => hello_world
  ///
  static String camelCaseToLowerUnderscore(String s) {
    var sb = StringBuffer();
    var first = true;
    s.runes.forEach((int rune) {
      var char = String.fromCharCode(rune);
      if (isUpperCase(char) && !first) {
        if (char != '_') {
          sb.write('_');
        }
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
  /// Capitalize the given string [s]. If [allWords] is set to true, it will capitalize all words within the given string [s].
  ///
  /// The string [s] is there fore splitted by " " (space).
  ///
  /// Example :
  ///
  /// * [s] = "world" => World
  /// * [s] = "WORLD" => World
  /// * [s] = "the quick lazy fox"  => The quick lazy fox
  /// * [s] = "the quick lazy fox" and [allWords] = true => The Quick Lazy Fox
  ///
  static String capitalize(String s, {bool allWords = false}) {
    if (s.isEmpty) {
      return '';
    }
    s = s.trim();
    if (allWords) {
      var words = s.split(' ');
      var capitalized = [];
      for (var w in words) {
        capitalized.add(capitalize(w));
      }
      return capitalized.join(' ');
    } else {
      return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
    }
  }

  ///
  /// Reverse the given string [s]
  /// Example : hello => olleh
  ///
  static String reverse(String s) {
    return String.fromCharCodes(s.runes.toList().reversed);
  }

  ///
  /// Counts how offen the given [char] apears in the given string [s].
  /// The value [caseSensitive] controlls whether it should only look for the given [char]
  /// or also the equivalent lower/upper case version.
  /// Example: Hello and char l => 2
  ///
  static int countChars(String s, String char, {bool caseSensitive = true}) {
    var count = 0;
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
  /// Checks if the given string [s] is a digit.
  ///
  /// Will return false if the given string [s] is empty.
  ///
  static bool isDigit(String s) {
    if (s.isEmpty) {
      return false;
    }
    if (s.length > 1) {
      for (var r in s.runes) {
        if (r ^ 0x30 > 9) {
          return false;
        }
      }
      return true;
    } else {
      return s.runes.first ^ 0x30 <= 9;
    }
  }

  ///
  /// Compares the given strings [a] and [b].
  ///
  static bool equalsIgnoreCase(String a, String b) =>
      a.toLowerCase() == b.toLowerCase();

  ///
  /// Checks if the given [list] contains the string [s]
  ///
  static bool inList(String s, List<String> list, {bool ignoreCase = false}) {
    for (var l in list) {
      if (ignoreCase) {
        if (equalsIgnoreCase(s, l)) {
          return true;
        }
      } else {
        if (s == l) {
          return true;
        }
      }
    }
    return false;
  }

  ///
  /// Checks if the given string [s] is a palindrome
  /// Example :
  /// aha => true
  /// hello => false
  ///
  static bool isPalindrome(String s) {
    for (var i = 0; i < s.length / 2; i++) {
      if (s[i] != s[s.length - 1 - i]) return false;
    }
    return true;
  }

  ///
  /// Replaces chars of the given String [s] with [replace].
  ///
  /// The default value of [replace] is *.
  /// [begin] determines the start of the 'replacing'. If [begin] is null, it starts from index 0.
  /// [end] defines the end of the 'replacing'. If [end] is null, it ends at [s] length divided by 2.
  /// If [s] is empty or consists of only 1 char, the method returns null.
  ///
  /// Example :
  /// 1234567890 => *****67890
  /// 1234567890 with begin 2 and end 6 => 12****7890
  /// 1234567890 with begin 1 => 1****67890
  ///
  static String? hidePartial(String s,
      {int begin = 0, int? end, String replace = '*'}) {
    var buffer = StringBuffer();
    if (s.length <= 1) {
      return null;
    }
    if (end == null) {
      end = (s.length / 2).round();
    } else {
      if (end > s.length) {
        end = s.length;
      }
    }
    for (var i = 0; i < s.length; i++) {
      if (i >= end) {
        buffer.write(String.fromCharCode(s.runes.elementAt(i)));
        continue;
      }
      if (i >= begin) {
        buffer.write(replace);
        continue;
      }
      buffer.write(String.fromCharCode(s.runes.elementAt(i)));
    }
    return buffer.toString();
  }

  ///
  /// Add a [char] at a [position] with the given String [s].
  ///
  /// The boolean [repeat] defines whether to add the [char] at every [position].
  /// If [position] is greater than the length of [s], it will return [s].
  /// If [repeat] is true and [position] is 0, it will return [s].
  ///
  /// Example :
  /// 1234567890 , '-', 3 => 123-4567890
  /// 1234567890 , '-', 3, true => 123-456-789-0
  ///
  static String addCharAtPosition(String s, String char, int position,
      {bool repeat = false}) {
    if (!repeat) {
      if (s.length < position) {
        return s;
      }
      var before = s.substring(0, position);
      var after = s.substring(position, s.length);
      return before + char + after;
    } else {
      if (position == 0) {
        return s;
      }
      var buffer = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i != 0 && i % position == 0) {
          buffer.write(char);
        }
        buffer.write(String.fromCharCode(s.runes.elementAt(i)));
      }
      return buffer.toString();
    }
  }

  ///
  /// Splits the given String [s] in chunks with the given [chunkSize].
  ///
  static List<String> chunk(String s, int chunkSize) {
    var chunked = <String>[];
    for (var i = 0; i < s.length; i += chunkSize) {
      var end = (i + chunkSize < s.length) ? i + chunkSize : s.length;
      chunked.add(s.substring(i, end));
    }
    return chunked;
  }

  ///
  /// Picks only required string[value] starting [from] and ending at [to]
  ///
  /// Example :
  /// pickOnly('123456789',from:3,to:7);
  /// returns '34567'
  ///
  static String pickOnly(value, {int from = 1, int to = -1}) {
    try {
      return value.substring(
          from == 0 ? 0 : from - 1, to == -1 ? value.length : to);
    } catch (e) {
      return value;
    }
  }

  ///
  /// Removes character with [index] from a String [value]
  ///
  /// Example:
  /// removeCharAtPosition('flutterr', 8);
  /// returns 'flutter'
  static String removeCharAtPosition(String value, int index) {
    try {
      return value.substring(0, -1 + index) +
          value.substring(index, value.length);
    } catch (e) {
      return value;
    }
  }

  ///
  ///Remove String[value] with [pattern]
  ///
  ///[repeat]:boolean => if(true) removes all occurence
  ///
  ///[casensitive]:boolean => if(true) a != A
  ///
  ///Example: removeExp('Hello This World', 'This'); returns 'Hello World'
  ///
  static String removeExp(String value, String pattern,
      {bool repeat = true,
      bool caseSensitive = true,
      bool multiLine = false,
      bool dotAll = false,
      bool unicode = false}) {
    var result = value;
    if (repeat) {
      result = value
          .replaceAll(
              RegExp(pattern,
                  caseSensitive: caseSensitive,
                  multiLine: multiLine,
                  dotAll: dotAll,
                  unicode: unicode),
              '')
          .replaceAll(RegExp(' +'), ' ')
          .trim();
    } else {
      result = value
          .replaceFirst(
              RegExp(pattern,
                  caseSensitive: caseSensitive,
                  multiLine: multiLine,
                  dotAll: dotAll,
                  unicode: unicode),
              '')
          .replaceAll(RegExp(' +'), ' ')
          .trim();
    }
    return result;
  }

  ///
  /// Takes in a String[value] and truncates it with [length]
  /// [symbol] default is '...'
  ///truncate('This is a Dart Utility Library', 26)
  /// returns 'This is a Dart Utility Lib...'
  static String truncate(String value, int length, {String symbol = '...'}) {
    var result = value;

    try {
      result = value.substring(0, length) + symbol;
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  ///
  /// Generates a Random string
  ///
  /// * [length] = length of string
  /// * [alphabet] = add alphabet to string
  /// * [uppercase] = adds lowercase alphabet to string
  /// * [lowercase] = adds lowercase alphabet to string
  /// * [numeric] = add integers to string
  /// * [special] = add special characters
  /// * [from] = a string that contains the allowed signs to be used for generating the random string
  ///
  static String generateRandomString(
    int length, {
    alphabet = true,
    numeric = true,
    special = true,
    uppercase = true,
    lowercase = true,
    String from = '',
  }) {
    var res = '';

    do {
      res +=
          _randomizer(alphabet, numeric, lowercase, uppercase, special, from);
    } while (res.length < length);

    var possible = res.split('');
    possible.shuffle();
    var result = [];

    for (var i = 0; i < length; i++) {
      var randomNumber = Random().nextInt(length);
      result.add(possible[randomNumber]);
    }

    return result.join();
  }

  static String _randomizer(bool alphabet, bool numeric, bool lowercase,
      bool uppercase, bool special, String from) {
    var a = 'ABCDEFGHIJKLMNOPQRXYZ';
    var la = 'abcdefghijklmnopqrxyz';
    var b = '0123456789';
    var c = '~^!@#\$%^&*;`(=?]:[.)_+-|\{}';
    var result = '';

    if (alphabet) {
      if (lowercase) {
        result += la;
      }
      if (uppercase) {
        result += a;
      }

      if (!uppercase && !lowercase) {
        result += a;
        result += la;
      }
    }
    if (numeric) {
      result += b;
    }

    if (special) {
      result += c;
    }

    if (from != '') {
      //if set return it
      result = from;
    }

    return result;
  }

  ///
  /// Converts the given String [s] to PascalCase
  /// Example: your name => YourName
  ///
  static String toPascalCase(String s) {
    final separatedWords = s.split(RegExp(r'[!@#<>?":`~;[\]\\|=+)(*&^%-\s_]+'));
    var newString = '';

    for (final word in separatedWords) {
      newString += word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    return newString;
  }

  ///
  /// Generates [amount] random strings
  ///
  /// * [length] = length of string
  /// * [alphabet] = add alphabet to string
  /// * [uppercase] = adds lowercase alphabet to string
  /// * [lowercase] = adds lowercase alphabet to string
  /// * [numeric] = add integers to string
  /// * [special] = add special characters
  /// * [from] = a string that contains the allowed signs to be used for generating the random string
  ///
  static List<String> generateRandomStrings(
    int amount,
    int length, {
    alphabet = true,
    numeric = true,
    special = true,
    uppercase = true,
    lowercase = true,
    String from = '',
  }) {
    var l = <String>[];
    for (var i = 0; i < amount; i++) {
      var s = generateRandomString(
        length,
        alphabet: alphabet,
        numeric: numeric,
        special: special,
        uppercase: uppercase,
        lowercase: lowercase,
        from: from,
      );
      l.add(s);
    }
    return l;
  }

  ///
  /// Checks whether the given String [s] is an IPv4 or IPv6 address.
  ///
  static bool isIP(String s, {InternetAddressType? ipType}) {
    if (ipType == null || ipType == InternetAddressType.any) {
      return isIP(s, ipType: InternetAddressType.IPv4) ||
          isIP(s, ipType: InternetAddressType.IPv6);
    } else if (ipType == InternetAddressType.IPv4) {
      if (!_ipv4Maybe.hasMatch(s)) {
        return false;
      }
      var parts = s.split('.');
      parts.sort((a, b) => int.parse(a) - int.parse(b));
      return int.parse(parts[3]) <= 255;
    } else if (ipType == InternetAddressType.IPv6) {
      return _ipv6.hasMatch(s);
    }
    return false;
  }
}
