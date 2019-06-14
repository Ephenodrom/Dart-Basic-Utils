part of basic_utils;

///
/// Helper class for dns record lookups
///
class SortUtils {
  ///
  /// Implementation of the quick sort algorithm
  ///
  static List quickSort(List list) {
    if (list.length <= 1) {
      return list;
    }

    var pivot = list[0];
    List less = [];
    List more = [];
    List pivotList = [];

    list.forEach((var element) {
      if (element.compareTo(pivot) < 0) {
        less.add(element);
      } else if (element.compareTo(pivot) > 0) {
        more.add(element);
      } else {
        pivotList.add(element);
      }
    });

    less = quickSort(less);
    more = quickSort(more);

    less.addAll(pivotList);
    less.addAll(more);
    return less;
  }

  ///
  /// Implementation of the bubble sort algorithm
  ///
  static List bubbleSort(List list) {
    var retList = new List.from(list);
    var tmp;
    var swapped = false;
    do {
      swapped = false;
      for (int i = 1; i < retList.length; i++) {
        if (retList[i - 1].compareTo(retList[i]) > 0) {
          tmp = retList[i - 1];
          retList[i - 1] = retList[i];
          retList[i] = tmp;
          swapped = true;
        }
      }
    } while (swapped);

    return retList;
  }

  ///
  /// Implementation of the heap sort algorithm
  ///
  static List heapSort(List a) {
    int count = a.length;

    int start = (count - 2) ~/ 2;

    while (start >= 0) {
      _sink(a, start, count - 1);
      start--;
    }

    int end = count - 1;
    while (end > 0) {
      var tmp = a[end];
      a[end] = a[0];
      a[0] = tmp;

      _sink(a, 0, end - 1);

      end--;
    }
    return a;
  }

  ///
  /// Sink a element in the tree
  ///
  static void _sink(List a, int start, int end) {
    int root = start;

    while ((root * 2 + 1) <= end) {
      int child = root * 2 + 1;
      if (child + 1 <= end && a[child].compareTo(a[child + 1]) == -1) {
        child = child + 1;
      }

      if (a[root].compareTo(a[child]) == -1) {
        var tmp = a[root];
        a[root] = a[child];
        a[child] = tmp;
        root = child;
      } else {
        return;
      }
    }
  }
}
