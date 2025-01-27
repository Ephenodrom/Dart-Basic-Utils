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
    expect(StringUtils.camelCaseToLowerUnderscore('a_b'), 'a_b');
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

  test('Test generateRandomString()', () {
    var l = StringUtils.generateRandomStrings(10, 10);
    expect(l.length, 10);
  });

  test('Test toPascalCase', () {
    expect(StringUtils.toPascalCase('hello world'), 'HelloWorld');
    expect(StringUtils.toPascalCase('Hello World'), 'HelloWorld');
    expect(StringUtils.toPascalCase('Hello World'), 'HelloWorld');
    expect(StringUtils.toPascalCase('helloworld'), 'Helloworld');
    expect(StringUtils.toPascalCase('hello_world'), 'HelloWorld');
    expect(StringUtils.toPascalCase('Hello_World'), 'HelloWorld');
    expect(StringUtils.toPascalCase('HELLO_WORLD'), 'HelloWorld');
  });

  test('Test isIP', () {
    expect(StringUtils.isIP('127.0.0.1'), true);
    expect(StringUtils.isIP('0.0.0.0'), true);
    expect(StringUtils.isIP('255.255.255.255'), true);
    expect(StringUtils.isIP('1.2.3.4'), true);
    expect(StringUtils.isIP('::1'), true);
    expect(StringUtils.isIP('2001:db8:0000:1:1:1:1:1'), true);
    expect(StringUtils.isIP('abc'), false);
    expect(StringUtils.isIP('256.0.0.0'), false);
    expect(StringUtils.isIP('0.0.0.256'), false);
    expect(StringUtils.isIP('26.0.0.256'), false);
  });

  group('strip extension', () {
    test('strip', () {
      // tested function's comment
      expect('@£^£Some @£^ Thing@@£@^'.strip('@£^'), 'Some @£^ Thing');

      // edge cases that doesn't modify the string
      expect('something'.strip('@'), 'something');
      expect('something'.strip('@£^'), 'something');
      expect('something'.strip(''), 'something');

      // remove a single character at either end from the source
      expect('@something'.strip('@'), 'something');
      expect('@something@'.strip('@'), 'something');
      expect('something@'.strip('@'), 'something');

      // remove more than one character at either end from the source
      expect('@@@something'.strip('@'), 'something');
      expect('@@something@@@'.strip('@'), 'something');
      expect('something@@@'.strip('@'), 'something');

      // search-string with multiple characters in it
      expect('@£something'.strip('@£'), 'something');
      expect('@£something@£^'.strip('@£^'), 'something');
      expect('something@£^'.strip('@£^'), 'something');

      // source string with strip-chars in the middle
      expect('@£some@£^thing'.strip('@£'), 'some@£^thing');
      expect('@£some@£^thing@£@'.strip('@£'), 'some@£^thing');
      expect('some@£^thing@£@'.strip('@£'), 'some@£^thing');

      // strip returns an empty string
      expect('@@@@@£^^£@£'.strip('@£^'), '');
      expect(''.strip('@£^'), '');
      expect(''.strip(''), '');
      expect('2'.strip('2'), '');

      // results in a string with one character in it
      expect('£@£@£@£@3@££££@^'.strip('£@^'), '3');

      // ensure that strip works with unicode chars: this text in in the script "Malayalam"
      expect('വ മലയാളം'.strip(''), 'വ മലയാളം');
      expect('വ മലയാളം'.strip('വ'), ' മലയാളം');
      expect('വ മലയാളംx'.strip('xവ'), ' മലയാളം');
      expect('kമലയാളംx'.strip('xk'), 'മലയാളം');
    });
    test('stripLeft', () {
      // tested function's comment
      expect('@£^£Some @£^ Thing@@£@^'.stripLeft('@£^'), 'Some @£^ Thing@@£@^');

      // edge cases that doesn't modify the string
      expect('something'.stripLeft('@'), 'something');
      expect('something'.stripLeft('@£^'), 'something');
      expect('something'.stripLeft(''), 'something');

      // remove a single character at the beginning
      expect('@something'.stripLeft('@'), 'something');
      expect('@something@'.stripLeft('@'), 'something@');
      expect('something@'.stripLeft('@'), 'something@');

      // remove more than one character from the beginning
      expect('@@@something'.stripLeft('@'), 'something');
      expect('@@something@@@'.stripLeft('@'), 'something@@@');
      expect('something@@@'.stripLeft('@'), 'something@@@');

      // search-string with multiple characters in it
      expect('@£something'.stripLeft('@£'), 'something');
      expect('@£something@£@'.stripLeft('@£'), 'something@£@');
      expect('something@£@'.stripLeft('@£'), 'something@£@');

      // source string with strip-chars in the middle
      expect('@£some@£^thing'.stripLeft('@£'), 'some@£^thing');
      expect('@£some@£^thing@£@'.stripLeft('@£'), 'some@£^thing@£@');
      expect('some@£^thing@£@'.stripLeft('@£'), 'some@£^thing@£@');

      // strip returns an empty string
      expect('@@@@@£^£@£'.stripLeft('@£^'), '');
      expect(''.stripLeft('@£^'), '');
      expect(''.stripLeft(''), '');
      expect('2'.stripLeft('2'), '');

      // results in a string with one character in it
      expect('£@£@£@£@3'.stripLeft('£@^'), '3');
    });
    test('stripRight', () {
      // tested function's comment
      expect('@£^£Some @£^ Thing@@£@^'.stripRight('@£^'),'@£^£Some @£^ Thing');

      // edge cases that doesn't modify the string
      expect('something'.stripRight('@'), 'something');
      expect('something'.stripRight('@£^'), 'something');
      expect('something'.stripRight(''), 'something');

      // remove a single character at the end
      expect('@something'.stripRight('@'), '@something');
      expect('@something@'.stripRight('@'), '@something');
      expect('something@'.stripRight('@'), 'something');

      // remove more than one character from the end
      expect('@@@something'.stripRight('@'), '@@@something');
      expect('@@something@@@'.stripRight('@'), '@@something');
      expect('something@@@'.stripRight('@'), 'something');

      // search-string with multiple characters in it
      expect('@£something'.stripRight('£@'), '@£something');
      expect('@£something@£@'.stripRight('@£'), '@£something');
      expect('something@£@'.stripRight('@£'), 'something');

      // source string with strip-chars in the middle
      expect('@£some@£^thing'.stripRight('@£'), '@£some@£^thing');
      expect('@£some@£^thing@£@'.stripRight('@£'), '@£some@£^thing');
      expect('some@£^thing@£@'.stripRight('@£'), 'some@£^thing');

      // strip returns an empty string
      expect('@@@@@£^£@£'.stripRight('@£^'), '');
      expect(''.stripRight('@£^'), '');
      expect(''.stripRight(''), '');
      expect('2'.stripRight('2'), '');

      // results in a string with one character in it
      expect('3@££££@^'.strip('£@^'), '3');
    });
  });
}
