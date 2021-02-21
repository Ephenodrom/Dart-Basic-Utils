///
/// Implementation of IDNA - RFC 3490 standard converter according to <http://www.rfc-base.org/rfc-3490.html>
///
class IDNAConverter {
  static const INVALID_INPUT = 'Invalid input';
  static const OVERFLOW = 'Overflow: input needs wider integers to process';
  static const NOT_BASIC = 'Illegal input >= 0x80 (not a basic code point)';

  static const int base = 36;
  static const int tMin = 1;
  static const int tMax = 26;

  static const int skew = 38;
  static const int damp = 700;

  static const int initialBias = 72;
  static const int initialN = 128; // 0x80
  static const delimiter = '-'; // '\x2D'

  /// Highest positive signed 32-bit float value
  static const maxInt = 2147483647; // aka. 0x7FFFFFFF or 2^31-1

  static RegExp regexPunycode = RegExp(r'^xn--');
  static RegExp regexNonASCII = RegExp(r'[^\0-\x7E]'); // non-ASCII chars
  static RegExp regexSeparators =
      RegExp(r'[\u002E\u3002\uFF0E\uFF61]'); // RFC 3490 separators
  static RegExp regexUrlprefix = RegExp(r'^http://|^https://');

  ///
  /// Converts a string that contains unicode symbols to a string with only ASCII symbols.
  ///
  static String encode(String input) {
    var n = initialN;
    var delta = 0;
    var bias = initialBias;
    var output = <int>[];

    // Copy all basic code points to the output
    var b = 0;
    for (var i = 0; i < input.length; i++) {
      var c = input.codeUnitAt(i);
      if (isBasic(c)) {
        output.add(c);
        b++;
      }
    }

    // Append delimiter
    if (b > 0) {
      output.add(delimiter.codeUnitAt(0));
    }

    var h = b;
    while (h < input.length) {
      var m = maxInt;

      // Find the minimum code point >= n
      for (var i = 0; i < input.length; i++) {
        var c = input.codeUnitAt(i);
        if (c >= n && c < m) {
          m = c;
        }
      }

      if (m - n > (maxInt - delta) / (h + 1)) {
        throw ArgumentError(OVERFLOW);
      }
      delta = delta + (m - n) * (h + 1);
      n = m;

      for (var j = 0; j < input.length; j++) {
        var c = input.codeUnitAt(j);
        if (c < n) {
          delta++;
          if (0 == delta) {
            throw ArgumentError(OVERFLOW);
          }
        }
        if (c == n) {
          var q = delta;

          for (var k = base;; k += base) {
            int t;
            if (k <= bias) {
              t = tMin;
            } else if (k >= bias + tMax) {
              t = tMax;
            } else {
              t = k - bias;
            }
            if (q < t) {
              break;
            }
            output.add((digitToBasic(t + (q - t) % (base - t))));
            q = ((q - t) / (base - t)).floor();
          }

          output.add(digitToBasic(q));
          bias = adapt(delta, h + 1, h == b);
          delta = 0;
          h++;
        }
      }

      delta++;
      n++;
    }

    return String.fromCharCodes(output);
  }

  ///
  /// Decode a ASCII string to the corresponding unicode string.
  ///
  static String decode(String input) {
    var n = initialN;
    var i = 0;
    var bias = initialBias;
    var output = <int>[];

    var d = input.lastIndexOf(delimiter);
    if (d > 0) {
      for (var j = 0; j < d; j++) {
        var c = input.codeUnitAt(j);
        if (!isBasic(c)) {
          throw ArgumentError(INVALID_INPUT);
        }
        output.add(c);
      }
      d++;
    } else {
      d = 0;
    }

    while (d < input.length) {
      var oldi = i;
      var w = 1;

      for (var k = base;; k += base) {
        if (d == input.length) {
          throw ArgumentError(INVALID_INPUT);
        }
        var c = input.codeUnitAt(d++);
        var digit = basicToDigit(c);
        if (digit > (maxInt - i) / w) {
          throw ArgumentError(OVERFLOW);
        }

        i = i + digit * w;

        int t;
        if (k <= bias) {
          t = tMin;
        } else if (k >= bias + tMax) {
          t = tMax;
        } else {
          t = k - bias;
        }
        if (digit < t) {
          break;
        }
        w = w * (base - t);
      }

      bias = adapt(i - oldi, output.length + 1, oldi == 0);

      if (i / (output.length + 1) > maxInt - n) {
        throw ArgumentError(OVERFLOW);
      }

      n = (n + i / (output.length + 1)).floor();
      i = i % (output.length + 1);
      output.insert(i, n);
      i++;
    }

    return String.fromCharCodes(output);
  }

  static int adapt(int delta, int numpoints, bool first) {
    if (first) {
      delta = (delta / damp).floor();
    } else {
      delta = (delta / 2).floor();
    }

    delta = delta + (delta / numpoints).floor();

    var k = 0;
    while (delta > ((base - tMin) * tMax) / 2) {
      delta = (delta / (base - tMin)).floor();
      k = k + base;
    }

    return (k + ((base - tMin + 1) * delta) / (delta + skew)).floor();
  }

  ///
  /// Checks if the given [value] is within the ASCII set
  ///
  static bool isBasic(int value) {
    return value < 0x80;
  }

  /// Converts a digit/integer into a basic code point.
  /// @see `basicToDigit()`
  /// @private
  /// @param {Number} digit The numeric value of a basic code point.
  /// @returns {Number} The basic code point whose value
  static int digitToBasic(int digit) {
    if (digit < 26) {
      // 0..25 : 'a'..'z'
      return digit + 'a'.codeUnitAt(0);
    } else if (digit < 36) {
      // 26..35 : '0'..'9';
      return digit - 26 + '0'.codeUnitAt(0);
    } else {
      throw ArgumentError(INVALID_INPUT);
    }
  }

  /// Converts a basic code point into a digit/integer.
  /// @see `digitToBasic()`
  /// @private
  /// @param {Number} codePoint The basic numeric code point value.
  /// @returns {Number} The numeric value of a basic code point (for use in
  /// representing integers) in the range `0` to `base - 1`, or `base` if
  /// the code point does not represent a value.
  static int basicToDigit(int codePoint) {
    if (codePoint - '0'.codeUnitAt(0) < 10) {
      // '0'..'9' : 26..35
      return codePoint - '0'.codeUnitAt(0) + 26;
    } else if (codePoint - 'a'.codeUnitAt(0) < 26) {
      // 'a'..'z' : 0..25
      return codePoint - 'a'.codeUnitAt(0);
    } else {
      throw ArgumentError(INVALID_INPUT);
    }
  }

  ///
  /// Converts a domain name or url that contains unicode symbols to a string with only ASCII symbols.
  ///
  static String urlDecode(String value) {
    return _urlConvert(value, false);
  }

  ///
  /// Decode a ASCII domain name or url to the corresponding unicode string.
  ///
  static String urlEncode(String value) {
    return _urlConvert(value, true);
  }

  static String _urlConvert(String url, bool shouldencode) {
    var _url = <String>[];
    var _result = <String>[];
    if (regexUrlprefix.hasMatch(url)) {
      _url = url.split('/');
    } else {
      _url.add(url);
    }
    _url.forEach((String _suburl) {
      _suburl = _suburl.replaceAll(regexSeparators, '\x2E');

      var _split = _suburl.split('.');

      var _join = <String>[];

      _split.forEach((elem) {
        // do decode and encode
        if (shouldencode) {
          if (regexPunycode.hasMatch(elem) ||
              regexNonASCII.hasMatch(elem) == false) {
            _join.add(elem);
          } else {
            _join.add('xn--' + encode(elem));
          }
        } else {
          if (regexNonASCII.hasMatch(elem)) {
            throw ArgumentError(NOT_BASIC);
          } else {
            _join.add(regexPunycode.hasMatch(elem)
                ? decode(elem.replaceFirst(regexPunycode, ''))
                : elem);
          }
        }
      });
      _result.add(_join.isNotEmpty ? _join.join('.') : _suburl);
    });

    return _result.length > 1
        ? _result.join('/')
        : _result.elementAt(0);
  }
}
