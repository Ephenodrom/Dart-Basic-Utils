import 'package:basic_utils/basic_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Test quickSort', () {
    var sorted = SortUtils.quickSort([5, 4, 1, 2, 3]);

    expect(sorted[0], 1);
    expect(sorted[1], 2);
    expect(sorted[2], 3);
    expect(sorted[3], 4);
    expect(sorted[4], 5);

    sorted = SortUtils.quickSort(['a', 'b', 'e', 'c', 'd']);

    expect(sorted[0], 'a');
    expect(sorted[1], 'b');
    expect(sorted[2], 'c');
    expect(sorted[3], 'd');
    expect(sorted[4], 'e');
  });

  test('Test bubbleSort', () {
    var sorted = SortUtils.bubbleSort([5, 4, 1, 2, 3]);

    expect(sorted[0], 1);
    expect(sorted[1], 2);
    expect(sorted[2], 3);
    expect(sorted[3], 4);
    expect(sorted[4], 5);

    sorted = SortUtils.bubbleSort(['a', 'b', 'e', 'c', 'd']);

    expect(sorted[0], 'a');
    expect(sorted[1], 'b');
    expect(sorted[2], 'c');
    expect(sorted[3], 'd');
    expect(sorted[4], 'e');
  });

  test('Test heapSort', () {
    var sorted = SortUtils.heapSort([5, 4, 1, 2, 3]);

    expect(sorted[0], 1);
    expect(sorted[1], 2);
    expect(sorted[2], 3);
    expect(sorted[3], 4);
    expect(sorted[4], 5);

    sorted = SortUtils.heapSort(['a', 'b', 'e', 'c', 'd']);

    expect(sorted[0], 'a');
    expect(sorted[1], 'b');
    expect(sorted[2], 'c');
    expect(sorted[3], 'd');
    expect(sorted[4], 'e');
  });
}
