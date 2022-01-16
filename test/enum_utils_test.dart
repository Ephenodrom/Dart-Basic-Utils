import 'package:basic_utils/src/EnumUtils.dart';
import 'package:test/test.dart';

enum Day { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

void main() {
  test('Test getEnum', () {
    final result = EnumUtils.getEnum('Wednesday', Day.values, Day.Monday);
    expect(result, Day.Wednesday);
  });

  test('Test getEnum', () {
    final result = EnumUtils.getEnum(
      'wednesday',
      Day.values,
      Day.Monday,
      ignoreCase: true,
    );
    expect(result, Day.Wednesday);
  });

  test('Test getEnum', () {
    final result = EnumUtils.getEnum(
      'random_string',
      Day.values,
      Day.Monday,
    );
    expect(result, Day.Monday);
  });

  test('Test isValidEnum', () {
    final result = EnumUtils.isValidEnum(
      'Monday',
      Day.values,
    );
    expect(result, true);
  });

  test('Test isValidEnum', () {
    final result = EnumUtils.isValidEnum(
      'monday',
      Day.values,
      ignoreCase: true,
    );
    expect(result, true);
  });

  test('Test isValidEnum', () {
    final result = EnumUtils.isValidEnum(
      'random_string',
      Day.values,
    );
    expect(result, false);
  });

  test('Test getEnumMap', () {
    final result = EnumUtils.getEnumMap(Day.values);
    final expected = {
      'Monday': Day.Monday,
      'Tuesday': Day.Tuesday,
      'Wednesday': Day.Wednesday,
      'Thursday': Day.Thursday,
      'Friday': Day.Friday,
      'Saturday': Day.Saturday,
      'Sunday': Day.Sunday
    };
    expect(result, expected);
  });
}
