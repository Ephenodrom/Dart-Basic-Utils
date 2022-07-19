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
    final expected = [1, 2, 3];
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

  test('Test size with null', () {
    final expected = 0;
    final list1 = null;
    final result = IterableUtils.size(list1);
    expect(result, expected);
  });

  test('Test size with iterable', () {
    final expected = 3;
    final list1 = [1, 2, 3];
    final result = IterableUtils.size(list1);
    expect(result, expected);
  });

  test('Test size with map', () {
    final expected = 1;
    final map1 = {};
    map1['key'] = 1;
    final result = IterableUtils.size(map1);
    expect(result, expected);
  });

  test('Test size with dynamic', () {
    final expected = 1;
    final dynamic object = {};
    object['key'] = 1;
    final result = IterableUtils.size(object);
    expect(result, expected);
  });

  test('Test size with dynamic without length', () {
    final object = _Foo();
    expect(() => IterableUtils.size(object),
        throwsA(TypeMatcher<ArgumentError>()));
  });

  test('Test size with dynamic without length', () {
    final expected = 1;
    final object = _FooLength(1);
    final result = IterableUtils.size(object);
    expect(result, expected);
  });

  ///
  ///
  ///
  test('Test sizeIsEmpty with null', () {
    final expected = true;
    final list1 = null;
    final result = IterableUtils.sizeIsEmpty(list1);
    expect(result, expected);
  });

  test('Test sizeIsEmpty with iterable', () {
    final expected = false;
    final list1 = [1, 2, 3];
    final result = IterableUtils.sizeIsEmpty(list1);
    expect(result, expected);
  });

  test('Test sizeIsEmpty with map', () {
    final expected = false;
    final map1 = {};
    map1['key'] = 1;
    final result = IterableUtils.sizeIsEmpty(map1);
    expect(result, expected);
  });

  test('Test sizeIsEmpty with dynamic', () {
    final expected = false;
    final dynamic object = {};
    object['key'] = 1;
    final result = IterableUtils.sizeIsEmpty(object);
    expect(result, expected);
  });

  test('Test sizeIsEmpty with dynamic without length', () {
    final object = _Foo();
    expect(() => IterableUtils.sizeIsEmpty(object),
        throwsA(TypeMatcher<ArgumentError>()));
  });

  test('Test sizeIsEmpty with dynamic without length', () {
    final expected = false;
    final object = _FooLength(1);
    final result = IterableUtils.sizeIsEmpty(object);
    expect(result, expected);
  });

  test('Test intersection', () {
    final expected = [1, 3];
    final list1 = [1, 2, 3];
    final list2 = [1, 'a', 3];
    final result = IterableUtils.intersection(list1, list2);
    expect(result, expected);
  });

  test('Test subtract', () {
    final expected = [2];
    final list1 = [1, 2, 3];
    final list2 = [1, 'a', 3];
    final result = IterableUtils.subtract(list1, list2);
    expect(result, expected);
  });
}

class _Foo {}

class _FooLength {
  final int length;

  const _FooLength(this.length);
}
