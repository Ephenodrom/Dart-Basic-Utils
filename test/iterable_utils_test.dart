import 'package:basic_utils/src/IterableUtils.dart';
import 'package:test/test.dart';

void main() {
  test('Test randomItem', () {
    var list = [1, 2, 3];
    expect(IterableUtils.randomItem(list), isIn(list));
  });

  test('Empty iterable throws exception', () {
    expect(() => IterableUtils.randomItem([]), throwsRangeError);
  });

  test('Test isNullOrEmpty', () {
    var list = [1, 2, 3, 4];
    var emptyList = [];
    var nullList;
    expect(IterableUtils.isNullOrEmpty(list), false);
    expect(IterableUtils.isNullOrEmpty(emptyList), true);
    expect(IterableUtils.isNullOrEmpty(nullList), true);
  });

  test('Test isNotNullOrEmpty', () {
    var list = [1, 2, 3, 4];
    var emptyList = [];
    var nullList;
    expect(IterableUtils.isNotNullOrEmpty(list), true);
    expect(IterableUtils.isNotNullOrEmpty(emptyList), false);
    expect(IterableUtils.isNotNullOrEmpty(nullList), false);
  });

  test('Test chunk', () {
    var list = [1, 2, 3, 4, 5, 6, 7, 8];
    var subLists = IterableUtils.chunk(list, 2);
    expect(subLists.length, 4);
    expect(subLists.elementAt(0).length, 2);
  });

  test('Test zip', () {
    final expected = [1, 2, 3, 4, 5, 6];
    final list1 = [1, 3, 5];
    final list2 = [2, 4, 6];
    final subZip = IterableUtils.zip(list1, list2);
    expect(subZip, expected);
  });

  test('Test zip with letters', () {
    final expected = [1, 'a', 3, 'b', 5, 'c'];
    final list1 = [1, 3, 5];
    final list2 = ['a', 'b', 'c'];
    final subZip = IterableUtils.zip(list1, list2);
    expect(subZip, expected);
  });

  test('Test emptyIfNull', () {
    final expected = [1, 3, 5];
    final list1 = [1, 3, 5];
    final result = IterableUtils.emptyIfNull(list1);
    expect(result, expected);
  });

  test('Test emptyIfNull when null', () {
    final expected = [];
    final Iterable? list1 = null;
    final result = IterableUtils.emptyIfNull(list1);
    expect(result, expected);
  });

  test('Test union', () {
    final expected = [1, 2, 3, 'a', 'b', 'c'];
    final list1 = [1, 2, 3];
    final list2 = ['a', 'b', 'c'];
    final result = IterableUtils.union(list1, list2);
    expect(result, expected);
  });

  test('Test union with same values', () {
    final expected = [1, 2, 3, 1, 2, 3];
    final list1 = [1, 2, 3];
    final list2 = [1, 2, 3];
    final result = IterableUtils.union(list1, list2);
    expect(result, expected);
  });

  test('Test containsAll', () {
    final expected = true;
    final list1 = [1, 2, 3];
    final list2 = [1, 2, 3];
    final result = IterableUtils.containsAll(list1, list2);
    expect(result, expected);
  });

  test('Test containsAll with empty list2', () {
    final expected = true;
    final list1 = [1, 2, 3];
    final list2 = [];
    final result = IterableUtils.containsAll(list1, list2);
    expect(result, expected);
  });

  test('Test containsAll with a values', () {
    final expected = true;
    final list1 = [1, 2, 3];
    final list2 = [1];
    final result = IterableUtils.containsAll(list1, list2);
    expect(result, expected);
  });

  test('Test containsAll with few values', () {
    final expected = false;
    final list1 = [1, 2, 3];
    final list2 = [4, 5, 6];
    final result = IterableUtils.containsAll(list1, list2);
    expect(result, expected);
  });

  test('Test containsAny', () {
    final expected = true;
    final list1 = [1, 2, 3];
    final list2 = [3];
    final result = IterableUtils.containsAny(list1, list2);
    expect(result, expected);
  });

  test('Test containsAny without', () {
    final expected = false;
    final list1 = [1, 2, 3];
    final list2 = [5];
    final result = IterableUtils.containsAny(list1, list2);
    expect(result, expected);
  });

  test('Test containsAny empty', () {
    final expected = false;
    final list1 = [1, 2, 3];
    final list2 = [];
    final result = IterableUtils.containsAny(list1, list2);
    expect(result, expected);
  });
}
