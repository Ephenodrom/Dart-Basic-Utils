import 'package:basic_utils/basic_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Test defaultString', () {
    expect(StringUtils.defaultString('Hello', defaultStr: 'World'), 'Hello');
    expect(StringUtils.defaultString(null, defaultStr: 'World'), 'World');
  });

  test('Test camelCaseToUpperUnderscore', () {
    expect(StringUtils.camelCaseToUpperUnderscore('camelCase'), 'CAMEL_CASE');
  });

  test('Test camelCaseToLowerUnderscore', () {
    expect(StringUtils.camelCaseToLowerUnderscore('camelCase'), 'camel_case');
  });

  test('Test isLowerCase', () {
    expect(StringUtils.isLowerCase('c'), true);
    expect(StringUtils.isLowerCase('C'), false);
  });

  test('Test isUpperCase', () {
    expect(StringUtils.isUpperCase('C'), true);
    expect(StringUtils.isUpperCase('c'), false);
  });

  test('Test isNullOrEmpty', () {
    expect(StringUtils.isNullOrEmpty(''), true);
    expect(StringUtils.isNullOrEmpty(null), true);
    expect(StringUtils.isNullOrEmpty('Hello'), false);
  });

  test('Test isNotNullOrEmpty', () {
    expect(StringUtils.isNotNullOrEmpty(''), false);
    expect(StringUtils.isNotNullOrEmpty(null), false);
    expect(StringUtils.isNotNullOrEmpty('Hello'), true);
  });

  test('Test isAscii', () {
    expect(StringUtils.isAscii('I am pure ascii'), true);
    expect(StringUtils.isAscii('I am nö ascii'), false);
  });

  test('Test capitalize', () {
    expect(StringUtils.capitalize('HELLO'), 'Hello');
    expect(StringUtils.capitalize('World'), 'World');
    expect(StringUtils.capitalize('helloworld'), 'Helloworld');

    expect(StringUtils.capitalize('the quick lazy fox', allWords: true),
        'The Quick Lazy Fox');

    expect(StringUtils.capitalize('THE QUICK LAZY FOX', allWords: true),
        'The Quick Lazy Fox');

    expect(
        StringUtils.capitalize('hello, my name is Jon. my last name is doe!',
            allWords: true),
        'Hello, My Name Is Jon. My Last Name Is Doe!');
  });

  test('Test reverse', () {
    expect(StringUtils.reverse('hello'), 'olleh');
  });

  test('Test count char', () {
    expect(StringUtils.countChars('Hello my name is Jon Doe.', 'e'), 3);
    expect(StringUtils.countChars('Hello my name is Jon Doe.', 'E'), 0);
    expect(
        StringUtils.countChars('Hello my namE is Jon Doe.', 'e',
            caseSensitive: false),
        3);
    expect(
        StringUtils.countChars('Hello my namE is Jon Doe.', 'E',
            caseSensitive: false),
        3);
  });

  test('Test equalsIgnoreCase', () {
    expect(StringUtils.equalsIgnoreCase('hello', 'HELLO'), true);
  });

  test('Test isDigit', () {
    expect(StringUtils.isDigit('1'), true);
    expect(StringUtils.isDigit('12345'), true);
    expect(StringUtils.isDigit('1a356'), false);
    expect(StringUtils.isDigit('q3dm16'), false);
    expect(StringUtils.isDigit(''), false);
  });

  test('Test inList', () {
    var list = ['a', 'b', 'c', 'A'];
    expect(StringUtils.inList('c', list), true);
    expect(StringUtils.inList('d', list), false);
    expect(StringUtils.inList('A', list, ignoreCase: true), true);
    expect(StringUtils.inList('D', list, ignoreCase: true), false);
  });

  test('Test isPalindrome', () {
    expect(StringUtils.isPalindrome('aha'), true);
    expect(StringUtils.isPalindrome('123454321'), true);
    expect(StringUtils.isPalindrome('1a356'), false);
    expect(StringUtils.isPalindrome('hello'), false);
  });

  test('Test hidePartial', () {
    expect(StringUtils.hidePartial('1234567890'), '*****67890');
    expect(
        StringUtils.hidePartial('1234567890', begin: 2, end: 6), '12****7890');
    expect(StringUtils.hidePartial('1234567890', begin: 1), '1****67890');
    expect(
        StringUtils.hidePartial('1234567890', begin: 2, end: 14), '12********');
  });

  test('Test addCharAtPosition', () {
    expect(StringUtils.addCharAtPosition('1234567890', '-', 3), '123-4567890');
    expect(StringUtils.addCharAtPosition('1234567890', '-', 3, repeat: true),
        '123-456-789-0');
    expect(StringUtils.addCharAtPosition('1234567890', '-', 12), '1234567890');
    expect(
        StringUtils.addCharAtPosition(
            '1F6254CEDA7E9E9AEBF8B687BDFB5CC03AD1B3E7', ' ', 2,
            repeat: true),
        '1F 62 54 CE DA 7E 9E 9A EB F8 B6 87 BD FB 5C C0 3A D1 B3 E7');
  });

  test('Test chunk', () {
    var chunked = StringUtils.chunk('aaaabbbbccccdddd', 4);
    expect(chunked.length, 4);
    expect(chunked.elementAt(0), 'aaaa');
    expect(chunked.elementAt(1), 'bbbb');
    expect(chunked.elementAt(2), 'cccc');
    expect(chunked.elementAt(3), 'dddd');
  });

  test('Test Pick Only', () {
    expect(StringUtils.pickOnly('123456789'), '123456789');
    expect(StringUtils.pickOnly('123456789', from: 3, to: 8), '345678');
    expect(StringUtils.pickOnly('123456789', to: 5), '12345');
    expect(StringUtils.pickOnly('123456789', from: 7), '789');
  });

  test('Test Remove Character at Position', () {
    expect(StringUtils.removeCharAtPosition('flutterr', 8), 'flutter');
    expect(StringUtils.removeCharAtPosition('iintel', 1), 'intel');
    expect(StringUtils.removeCharAtPosition('strinng', 5), 'string');
  });

  test('Test Remove Pattern', () {
    expect(StringUtils.removeExp('Hello This World', 'This'), 'Hello World');
    expect(StringUtils.removeExp('All all all', 'all'), 'All');
    expect(
        StringUtils.removeExp('All all all', 'all', repeat: false), 'All all');
    expect(
        StringUtils.removeExp('All all all', 'all', caseSensitive: false), '');
  });

  test('Test Truncate', () {
    expect(StringUtils.truncate('This is a Dart Utility Library', 26),
        'This is a Dart Utility Lib...');
    expect(
        StringUtils.truncate('This is a Dart Utility Library', 26,
            symbol: '***'),
        'This is a Dart Utility Lib***');
  });

  test('Test Generate Random String', () {
    var testing1 = StringUtils.generateRandomString(10);
    expect(testing1, testing1.length == 10 ? testing1 : false);

    var testing2 =
        StringUtils.generateRandomString(5, from: '1234565fhshsbAJSJSSU');
    expect(testing2, testing2.length == 5 ? testing2 : false);

    var isAlphabetInly =
        StringUtils.generateRandomString(20, numeric: false, special: false);
    expect(RegExp(r'^[a-zA-Z]+$').hasMatch(isAlphabetInly), true);

    var isNumericOnly =
        StringUtils.generateRandomString(20, alphabet: false, special: false);
    expect(RegExp(r'^[0-9]+$').hasMatch(isNumericOnly), true);

    var isAlphaNumericOInly = StringUtils.generateRandomString(
      20,
      special: false,
    );
    expect(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(isAlphaNumericOInly), true);

    var isSpecialOnly =
        StringUtils.generateRandomString(20, numeric: false, alphabet: false);
    expect(!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(isSpecialOnly), true);
  });
}
