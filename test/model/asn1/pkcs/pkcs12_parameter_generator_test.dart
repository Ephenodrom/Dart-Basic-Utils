import 'dart:typed_data';

import 'package:basic_utils/src/hex_utils.dart';
import 'package:basic_utils/src/model/asn1/pkcs/pkcs12/pkcs12_parameter_generator.dart';
import 'package:basic_utils/src/pkcs12_utils.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';

void main() {
  test('test generateDerivedParameters()', () {
    var password1 = Uint8List.fromList('smeg'.codeUnits);
    var salt1 = HexUtils.decode('0A58CF64530D823F');
    var itCount1 = 1;
    var result1 =
        HexUtils.decode('8AAAE6297B6CB04642AB5B077851284EB7128F1A2A7FBCA3');

    var generator = PKCS12ParametersGenerator(Digest('SHA-1'));
    generator.init(
        Pkcs12Utils.formatPkcs12Password(password1), salt1, itCount1);
    var bytes = generator.generateDerivedParameters(24);
    expect(bytes.key, result1);

    password1 = Uint8List.fromList('queeg'.codeUnits);
    salt1 = HexUtils.decode('1682C0FC5B3F7EC5');
    itCount1 = 1000;
    result1 =
        HexUtils.decode('483DD6E919D7DE2E8E648BA8F862F3FBFBDC2BCB2C02957F');

    generator = PKCS12ParametersGenerator(Digest('SHA-1'));
    generator.init(
        Pkcs12Utils.formatPkcs12Password(password1), salt1, itCount1);
    bytes = generator.generateDerivedParameters(24);
    expect(bytes.key, result1);
  });

  test('test generateDerivedMacParameters()', () {
    var password1 = Uint8List.fromList('smeg'.codeUnits);
    var salt1 = HexUtils.decode('3D83C0E4546AC140');
    var itCount1 = 1;
    var result1 = HexUtils.decode('8D967D88F6CAA9D714800AB3D48051D63F73A312');

    var generator = PKCS12ParametersGenerator(Digest('SHA-1'));
    generator.init(
        Pkcs12Utils.formatPkcs12Password(password1), salt1, itCount1);
    var bytes = generator.generateDerivedMacParameters(20);
    expect(bytes.key, result1);

    password1 = Uint8List.fromList('queeg'.codeUnits);
    salt1 = HexUtils.decode('263216FCC2FAB31C');
    itCount1 = 1000;
    result1 = HexUtils.decode('5EC4C7A80DF652294C3925B6489A7AB857C83476');

    generator = PKCS12ParametersGenerator(Digest('SHA-1'));
    generator.init(
        Pkcs12Utils.formatPkcs12Password(password1), salt1, itCount1);
    bytes = generator.generateDerivedMacParameters(20);
    expect(bytes.key, result1);
  });

  test('test generateDerivedParametersWithIV()', () {
    var password1 = Uint8List.fromList('smeg'.codeUnits);
    var salt1 = HexUtils.decode('0A58CF64530D823F');
    var itCount1 = 1;
    var result1 = HexUtils.decode('79993DFE048D3B76');

    var generator = PKCS12ParametersGenerator(Digest('SHA-1'));
    generator.init(
        Pkcs12Utils.formatPkcs12Password(password1), salt1, itCount1);
    var bytes = generator.generateDerivedParametersWithIV(8, 8);
    expect(bytes.parameters is KeyParameter, true);
    expect(bytes.iv, result1);

    password1 = Uint8List.fromList('queeg'.codeUnits);
    salt1 = HexUtils.decode('05DEC959ACFF72F7');
    itCount1 = 1000;
    result1 = HexUtils.decode('11DEDAD7758D4860');

    generator = PKCS12ParametersGenerator(Digest('SHA-1'));
    generator.init(
        Pkcs12Utils.formatPkcs12Password(password1), salt1, itCount1);
    bytes = generator.generateDerivedParametersWithIV(8, 8);
    expect(bytes.parameters is KeyParameter, true);
    expect(bytes.iv, result1);
  });
}
