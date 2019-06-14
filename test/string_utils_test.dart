import 'package:basic_utils/basic_utils.dart';
import "package:test/test.dart";

void main() {
  test('Test defaultString', () {
    expect(StringUtils.defaultString("Hello", "World"), "Hello");
    expect(StringUtils.defaultString(null, "World"), "World");
  });

  test('Test camelCaseToUpperUnderscore', () {
    expect(StringUtils.camelCaseToUpperUnderscore("camelCase"), "CAMEL_CASE");
  });

  test('Test camelCaseToLowerUnderscore', () {
    expect(StringUtils.camelCaseToLowerUnderscore("camelCase"), "camel_case");
  });

  test('Test isLowerCase', () {
    expect(StringUtils.isLowerCase("c"), true);
    expect(StringUtils.isLowerCase("C"), false);
  });

  test('Test isUpperCase', () {
    expect(StringUtils.isUpperCase("C"), true);
    expect(StringUtils.isUpperCase("c"), false);
  });

  test('Test isNullOrEmpty', () {
    expect(StringUtils.isNullOrEmpty(""), true);
    expect(StringUtils.isNullOrEmpty(null), true);
    expect(StringUtils.isNullOrEmpty("Hello"), false);
  });

  test('Test isNotNullOrEmpty', () {
    expect(StringUtils.isNotNullOrEmpty(""), false);
    expect(StringUtils.isNotNullOrEmpty(null), false);
    expect(StringUtils.isNotNullOrEmpty("Hello"), true);
  });

  test('Test isAscii', () {
    expect(StringUtils.isAscii("I am pure ascii"), true);
    expect(StringUtils.isAscii("I am nö ascii"), false);
  });

  test('Test capitalize', () {
    expect(StringUtils.capitalize("HELLO"), "Hello");
    expect(StringUtils.capitalize("World"), "World");
    expect(StringUtils.capitalize("helloworld"), "Helloworld");
  });

  test('Test reverse', () {
    expect(StringUtils.reverse("hello"), "olleh");
  });

  test('Test count char', () {
    expect(StringUtils.countChars("Hello my name is Jon Doe.", "e"), 3);
    expect(StringUtils.countChars("Hello my name is Jon Doe.", "E"), 0);
    expect(
        StringUtils.countChars("Hello my namE is Jon Doe.", "e",
            caseSensitive: false),
        3);
    expect(
        StringUtils.countChars("Hello my namE is Jon Doe.", "E",
            caseSensitive: false),
        3);
  });

  test('Test equalsIgnoreCase', () {
    expect(StringUtils.equalsIgnoreCase("hello", "HELLO"), true);
  });

  test('Test isDigit', () {
    expect(StringUtils.isDigit("1"), true);
    expect(StringUtils.isDigit("12345"), true);
    expect(StringUtils.isDigit("1a356"), false);
    expect(StringUtils.isDigit("q3dm16"), false);
  });

  test('Test inList', () {
    List<String> list = ["a", "b", "c", "A"];
    expect(StringUtils.inList("c", list), true);
    expect(StringUtils.inList("d", list), false);
    expect(StringUtils.inList("A", list, ignoreCase: true), true);
    expect(StringUtils.inList("D", list, ignoreCase: true), false);
  });

  test('Test isPalindrome', () {
    expect(StringUtils.isPalindrome("aha"), true);
    expect(StringUtils.isPalindrome("123454321"), true);
    expect(StringUtils.isPalindrome("1a356"), false);
    expect(StringUtils.isPalindrome("hello"), false);
  });
}
