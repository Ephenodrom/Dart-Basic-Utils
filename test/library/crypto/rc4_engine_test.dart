import 'dart:typed_data';

import 'package:basic_utils/src/StringUtils.dart';
import 'package:basic_utils/src/library/crypto/rc4_engine.dart';
import 'package:pointycastle/export.dart';

import 'package:test/test.dart';

void main() {
  test('test process()', () {
    var engine = RC4Engine();
    var actual = Uint8List(0);

    var params = KeyParameter(
      StringUtils.hexToUint8List("0123456789ABCDEF"),
    );
    var input = StringUtils.hexToUint8List("4e6f772069732074");
    var output = StringUtils.hexToUint8List("3afbb5c77938280d");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);

    params = KeyParameter(StringUtils.hexToUint8List("0123456789ABCDEF"));
    input = StringUtils.hexToUint8List("68652074696d6520");
    output = StringUtils.hexToUint8List("1cf1e29379266d59");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);

    params = KeyParameter(StringUtils.hexToUint8List("0123456789ABCDEF"));
    input = StringUtils.hexToUint8List("666f7220616c6c20");
    output = StringUtils.hexToUint8List("12fbb0c771276459");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);
  });
}
