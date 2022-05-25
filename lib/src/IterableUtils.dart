import 'dart:math';

///
/// Helper class for operations on iterables
///
class IterableUtils {
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
}
