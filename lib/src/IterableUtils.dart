import 'dart:math';

///
/// Helper class for operations on iterables
///
class IterableUtils {
  ///
  /// Returns a random element in [iterable]. Throws [RangeError] if [iterable] is null or empty.
  ///
  static T randomItem<T>(Iterable<T> iterable) {
    if (iterable == null) {
      throw RangeError('iterable must not be null');
    }
    if (iterable.isEmpty) {
      throw RangeError('iterable must not be empty');
    }
    return iterable.elementAt(Random().nextInt(iterable.length));
  }
}
