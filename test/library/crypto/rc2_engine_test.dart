import 'dart:typed_data';

import 'package:basic_utils/src/StringUtils.dart';
import 'package:basic_utils/src/library/crypto/rc2_engine.dart';
import 'package:basic_utils/src/library/crypto/rc2_parameters.dart';

import 'package:test/test.dart';

void main() {
  test('test generateDerivedParameters()', () {
    var engine = RC2Engine();
    var actual = Uint8List(0);

    var params1 =
        RC2Parameters(StringUtils.hexToUint8List("0000000000000000"), bits: 63);
    var input1 = StringUtils.hexToUint8List("0000000000000000");
    var output1 = StringUtils.hexToUint8List("EBB773F993278EFF");

    // engine.init(true, params1);
    // actual = engine.process(input1);
    // expect(actual, output1);

    params1 =
        RC2Parameters(StringUtils.hexToUint8List("ffffffffffffffff"), bits: 64);
    input1 = StringUtils.hexToUint8List("ffffffffffffffff");
    output1 = StringUtils.hexToUint8List("278b27e42e2f0d49");

    engine.init(true, params1);
    actual = engine.process(input1);
    expect(actual, output1);
  });
}
