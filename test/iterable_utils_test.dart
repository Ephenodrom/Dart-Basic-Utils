import 'package:basic_utils/src/IterableUtils.dart';
import 'package:test/test.dart';

void main() {
  test('Happy test', () {
    var list = [1, 2, 3];
    expect(IterableUtils.randomItem(list), isIn(list));
  });

  test('Null throws exception', () {
    expect(() => IterableUtils.randomItem(null), throwsRangeError);
  });

  test('Empty iterable throws exception', () {
    expect(() => IterableUtils.randomItem([]), throwsRangeError);
  });
}