import 'dart:typed_data';

import 'package:basic_utils/src/hex_utils.dart';
import 'package:basic_utils/src/library/crypto/desede_engine.dart';
import 'package:basic_utils/src/library/crypto/desede_parameters.dart';

import 'package:test/test.dart';

void main() {
  test('test process()', () {
    var engine = DESedeEngine();
    var actual = Uint8List(0);

    var params = DESedeParameters(
      HexUtils.decode("0123456789ABCDEF0123456789ABCDEF"),
    );

    var input =
        HexUtils.decode("4e6f77206973207468652074696d6520666f7220616c6c20");
    var output =
        HexUtils.decode("3fa40e8a984d48156a271787ab8883f9893d51ec4b563b53");

    engine.init(true, params);
    actual = Uint8List(input.length);

    var offset = 0;
    while (offset < input.length) {
      offset += engine.processBlock(input, offset, actual, offset);
    }
    expect(actual, output);

    params =
        DESedeParameters(HexUtils.decode("0123456789abcdeffedcba9876543210"));
    input = HexUtils.decode("4e6f77206973207468652074696d6520666f7220616c6c20");
    output =
        HexUtils.decode("d80a0d8b2bae5e4e6a0094171abcfc2775d2235a706e232c");

    engine.init(true, params);
    actual = Uint8List(input.length);

    offset = 0;
    while (offset < input.length) {
      offset += engine.processBlock(input, offset, actual, offset);
    }
    expect(actual, output);

    params = DESedeParameters(
        HexUtils.decode("0123456789abcdef0123456789abcdef0123456789abcdef"));
    input = HexUtils.decode("4e6f77206973207468652074696d6520666f7220616c6c20");
    output =
        HexUtils.decode("3fa40e8a984d48156a271787ab8883f9893d51ec4b563b53");

    engine.init(true, params);
    actual = Uint8List(input.length);

    offset = 0;
    while (offset < input.length) {
      offset += engine.processBlock(input, offset, actual, offset);
    }
    expect(actual, output);

    params = DESedeParameters(
        HexUtils.decode("0123456789abcdeffedcba98765432100123456789abcdef"));
    input = HexUtils.decode("4e6f77206973207468652074696d6520666f7220616c6c20");
    output =
        HexUtils.decode("d80a0d8b2bae5e4e6a0094171abcfc2775d2235a706e232c");

    engine.init(true, params);
    actual = Uint8List(input.length);

    offset = 0;
    while (offset < input.length) {
      offset += engine.processBlock(input, offset, actual, offset);
    }
    expect(actual, output);
  });
}
