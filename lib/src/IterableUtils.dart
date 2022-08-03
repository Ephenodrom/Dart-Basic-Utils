import 'dart:math';

///
/// Helper class for operations on iterables
///
class IterableUtils {
  ///
  /// An empty unmodifiable collection.
  ///
  static final Iterable _emptyIterable = List.unmodifiable([]);

  ///
  /// Returns a random element in [iterable]. Throws [RangeError] if [iterable] is null or empty.
  ///
  static T randomItem<T>(Iterable<T> iterable) {
    if (iterable.isEmpty) {
      throw RangeError('iterable must not be empty');
    }
    return iterable.elementAt(Random().nextInt(iterable.length));
  }

  ///
  /// Checks if the given Iterable [iterable] is null or empty
  ///
  static bool isNullOrEmpty(Iterable? iterable) =>
      (iterable == null || iterable.isEmpty) ? true : false;

  ///
  /// Checks if the given Iterable [iterable] is not null or empty
  ///
  static bool isNotNullOrEmpty(Iterable? iterable) => !isNullOrEmpty(iterable);

  ///
  /// Splits the given [list] into sublist of the given [size].
  ///
  static List<List<T>> chunk<T>(List<T> list, int size) {
    if (size <= 1) {
      throw ArgumentError('size must be >1');
    }
    var parts = <List<T>>[];
    final baseListSize = list.length;
    for (var i = 0; i < baseListSize; i += size) {
      var subList = list.sublist(i, min<int>(baseListSize, i + size));
      parts.add(subList);
    }
    return parts;
  }

  ///
  /// Make an [Iterable] that aggregates elements from each of the iterables.
  ///
  /// IterableUtils.zip([1, 3, 5], [2, 4, 6]) = [1, 2, 3, 4, 5, 6]
  /// IterableUtils.zip([1, 3, 5], ['a', 'b', 'c']) = [1, 'a', 3, 'b', 5, 'c']
  ///
  static Iterable<T> zip<T>(Iterable<T> a, Iterable<T> b) sync* {
    final ita = a.iterator;
    final itb = b.iterator;
    bool hasA, hasB;
    while ((hasA = ita.moveNext()) | (hasB = itb.moveNext())) {
      if (hasA) yield ita.current;
      if (hasB) yield itb.current;
    }
  }

  ///
  /// Returns the immutable [_emptyIterable].
  ///
  static Iterable emptyIterable() {
    return _emptyIterable;
  }

  ///
  /// Returns an immutable empty collection if the argument is null,
  /// or the argument itself otherwise.
  ///
  static Iterable emptyIfNull(final Iterable? collection) {
    return collection ?? _emptyIterable;
  }

  ///
  /// Returns an [Iterable] containing the union of the given [Iterable].
  /// The cardinality of each element in the returned [Iterable] will
  /// be equal to the maximum of the cardinality of that element in the two
  /// given [Iterable].
  ///
  static Iterable<E> union<E>(
      final Iterable<E> iterable1, final Iterable<E> iterable2) {
    final a = Set.of(iterable1);
    final b = Set.of(iterable2);
    return a.union(b);
  }

  ///
  /// Returns a [Iterable] containing the intersection of the given [Iterable].
  ///
  static Iterable intersection(
      final Iterable iterable1, final Iterable iterable2) {
    final a = Set.of(iterable1);
    final b = Set.of(iterable2);
    return a.intersection(b);
  }

  ///
  /// Returns a new [Iterable] containing a minus a subset of b.
  /// Only the elements of b that satisfy the predicate condition,
  /// p are subtracted from a.
  ///
  static Iterable subtract(final Iterable iterable1, final Iterable iterable2) {
    final a = Set.of(iterable1);
    final b = Set.of(iterable2);
    return a.difference(b);
  }

  ///
  /// Returns true if all elements of [iterable2] are also contained in [iterable1].
  ///
  static bool containsAll(final Iterable iterable1, final Iterable iterable2) {
    if (iterable2.isEmpty) {
      return true;
    }

    return iterable2.every((element) => iterable1.contains(element));
  }

  ///
  /// Returns true if at least one element is in both collections.
  ///
  static bool containsAny(final Iterable iterable1, final Iterable iterable2) {
    if (iterable1.length < iterable2.length) {
      return iterable1.any((element) => iterable2.contains(element));
    } else {
      return iterable2.any((element) => iterable1.contains(element));
    }
  }

  ///
  /// Gets the size of the [Iterator], [Map] or specified.
  ///
  static int size(final dynamic iterable) {
    if (iterable == null) {
      return 0;
    }
    if (iterable is Iterable) {
      return iterable.length;
    } else if (iterable is Map) {
      return iterable.length;
    } else {
      try {
        return iterable.length;
      } catch (ex) {
        throw ArgumentError('Unsupported object type $iterable');
      }
    }
  }

  ///
  /// Gets the size of the [Iterator], [Map] or specified.
  ///
  static bool sizeIsEmpty(final dynamic iterable) {
    final result = size(iterable);
    return result == 0;
  }

  static void _permutate(
      int n, List<dynamic> elements, List<List<dynamic>> store) {
    if (n == 1) {
      var t = <dynamic>[];
      t.addAll(elements);
      store.add(t);
    } else {
      for (var i = 0; i < n - 1; i++) {
        _permutate(n - 1, elements, store);
        if (n % 2 == 0) {
          swap(elements, i, n - 1);
        } else {
          swap(elements, 0, n - 1);
        }
      }
      _permutate(n - 1, elements, store);
    }
  }

  ///
  /// Swaps the given index [a] and [b] in the given [input]
  ///
  static void swap(List<dynamic> input, int a, int b) {
    var tmp = input[a];
    input[a] = input[b];
    input[b] = tmp;
  }

  ///
  /// Creates a permutation if the given list [data] by swapping each items to get the amount of [data.length]!.
  ///
  /// If the data consists of 4 items, the permutation will create 24 possible combinations (4*3*2*1=24).
  ///
  /// Example
  ///
  /// data = ["A", "B", "C"]
  ///
  /// result = [[A, B, C], [B, A, C], [C, A, B], [A, C, B], [B, C, A], [C, B, A]]
  ///
  static List<List<dynamic>> permutate(List<dynamic> data) {
    var store = <List<dynamic>>[];
    var tmp = <dynamic>[];
    tmp.addAll(data);
    _permutate(data.length, tmp, store);
    return store;
  }
}
