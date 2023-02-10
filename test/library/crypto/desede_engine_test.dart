import 'dart:typed_data';

import 'package:basic_utils/src/StringUtils.dart';
import 'package:basic_utils/src/library/crypto/desede_engine.dart';
import 'package:basic_utils/src/library/crypto/desede_parameters.dart';

import 'package:test/test.dart';

void main() {
  test('test process()', () {
    var engine = DESedeEngine();
    var actual = Uint8List(0);

    var params = DESedeParameters(
      StringUtils.hexToUint8List("0123456789ABCDEF0123456789ABCDEF"),
    );

    var input = StringUtils.hexToUint8List(
        "4e6f77206973207468652074696d6520666f7220616c6c20");
    var output = StringUtils.hexToUint8List(
        "3fa40e8a984d48156a271787ab8883f9893d51ec4b563b53");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);

    params = DESedeParameters(
        StringUtils.hexToUint8List("0123456789abcdeffedcba9876543210"));
    input = StringUtils.hexToUint8List(
        "4e6f77206973207468652074696d6520666f7220616c6c20");
    output = StringUtils.hexToUint8List(
        "d80a0d8b2bae5e4e6a0094171abcfc2775d2235a706e232c");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);

    params = DESedeParameters(StringUtils.hexToUint8List(
        "0123456789abcdef0123456789abcdef0123456789abcdef"));
    input = StringUtils.hexToUint8List(
        "4e6f77206973207468652074696d6520666f7220616c6c20");
    output = StringUtils.hexToUint8List(
        "3fa40e8a984d48156a271787ab8883f9893d51ec4b563b53");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);

    params = DESedeParameters(StringUtils.hexToUint8List(
        "0123456789abcdeffedcba98765432100123456789abcdef"));
    input = StringUtils.hexToUint8List(
        "4e6f77206973207468652074696d6520666f7220616c6c20");
    output = StringUtils.hexToUint8List(
        "d80a0d8b2bae5e4e6a0094171abcfc2775d2235a706e232c");

    engine.init(true, params);
    actual = engine.process(input);
    expect(actual, output);
  });
}
