import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Test encode', () {
    expect(
        HexUtils.encode(Uint8List.fromList(
          [0x02, 0x02, 0x08, 0x00],
        )),
        '02020800');
  });

  test('Test decode', () {
    expect(
      HexUtils.decode('02020800'),
      Uint8List.fromList(
        [0x02, 0x02, 0x08, 0x00],
      ),
    );
    expect(
      HexUtils.decode('2020800'),
      Uint8List.fromList(
        [0x02, 0x02, 0x08, 0x00],
      ),
    );
  });
}
