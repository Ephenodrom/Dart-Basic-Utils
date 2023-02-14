import 'dart:typed_data';

import 'package:basic_utils/src/hex_utils.dart';
import 'package:basic_utils/src/library/crypto/rc4_engine.dart';
import 'package:pointycastle/export.dart';

import 'package:test/test.dart';

void main() {
  test('test process()', () {
    var engine = RC4Engine();
    var actual = Uint8List(0);

    var params = KeyParameter(
      HexUtils.decode("0123456789ABCDEF"),
    );
    var input = HexUtils.decode("4e6f772069732074");
    var output = HexUtils.decode("3afbb5c77938280d");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);

    params = KeyParameter(HexUtils.decode("0123456789ABCDEF"));
    input = HexUtils.decode("68652074696d6520");
    output = HexUtils.decode("1cf1e29379266d59");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);

    params = KeyParameter(HexUtils.decode("0123456789ABCDEF"));
    input = HexUtils.decode("666f7220616c6c20");
    output = HexUtils.decode("12fbb0c771276459");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);
  });
}
