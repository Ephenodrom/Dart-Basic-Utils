import 'package:basic_utils/src/IterableUtils.dart';
import 'package:test/test.dart';

void main() {
  test('Test randomItem', () {
    var list = [1, 2, 3];
    expect(IterableUtils.randomItem(list), isIn(list));
  });

  test('Null throws exception', () {
    expect(() => IterableUtils.randomItem(null), throwsRangeError);
  });

  test('Empty iterable throws exception', () {
    expect(() => IterableUtils.randomItem([]), throwsRangeError);
  });

  test('Test isNullOrEmpty', () {
    List<int> list = [1, 2, 3, 4];
    List<int> emptyList = [];
    List<int> nullList;
    expect(IterableUtils.isNullOrEmpty(list), false);
    expect(IterableUtils.isNullOrEmpty(emptyList), true);
    expect(IterableUtils.isNullOrEmpty(nullList), true);
  });

  test('Test isNotNullOrEmpty', () {
    List<int> list = [1, 2, 3, 4];
    List<int> emptyList = [];
    List<int> nullList;
    expect(IterableUtils.isNotNullOrEmpty(list), true);
    expect(IterableUtils.isNotNullOrEmpty(emptyList), false);
    expect(IterableUtils.isNotNullOrEmpty(nullList), false);
  });

  test('Test chunk', () {
    List<int> list = [1, 2, 3, 4, 5, 6, 7, 8];
    List<List<int>> subLists = IterableUtils.chunk(list, 2);
    expect(subLists.length, 4);
    expect(subLists.elementAt(0).length, 2);
  });
}
