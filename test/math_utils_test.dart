import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/LengthUnits.dart';
import "package:test/test.dart";

void main() {
  test('Test convertUnit with kilometer', () {
    expect(MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.meter),
        1000);
  });

  test('Test convertUnit with meter', () {
    expect(
        MathUtils.convertUnit(1000, LengthUnits.meter, LengthUnits.kilometer),
        1);
    expect(MathUtils.convertUnit(1000, LengthUnits.meter, LengthUnits.meter),
        1000);
    expect(
        MathUtils.convertUnit(1000, LengthUnits.meter, LengthUnits.decimeter),
        10000);
    expect(
        MathUtils.convertUnit(1000, LengthUnits.meter, LengthUnits.centimeter),
        100000);
    expect(MathUtils.convertUnit(1, LengthUnits.meter, LengthUnits.millimeter),
        1000);
    expect(MathUtils.convertUnit(1, LengthUnits.meter, LengthUnits.micrometers),
        1000000.0);
    expect(MathUtils.convertUnit(1, LengthUnits.meter, LengthUnits.nanometer),
        1000000000.0);
    expect(MathUtils.convertUnit(1, LengthUnits.meter, LengthUnits.picometer),
        1000000000000.0);
    expect(MathUtils.convertUnit(1, LengthUnits.meter, LengthUnits.femtometer),
        1000000000000000.0);
    expect(MathUtils.convertUnit(1, LengthUnits.meter, LengthUnits.attometer),
        1000000000000000000.0);
  });

  test('Test convertUnit with decimeter', () {
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.decimeter, LengthUnits.decimeter),
        1000);
  });

  test('Test convertUnit with centimeter', () {
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.centimeter, LengthUnits.kilometer),
        0.01);
    expect(
        MathUtils.convertUnit(1000, LengthUnits.centimeter, LengthUnits.meter),
        10);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.centimeter, LengthUnits.centimeter),
        1000);
    expect(
        MathUtils.convertUnit(
            10, LengthUnits.centimeter, LengthUnits.millimeter),
        100);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.centimeter, LengthUnits.micrometers),
        10000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.centimeter, LengthUnits.nanometer),
        10000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.centimeter, LengthUnits.picometer),
        10000000000);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.centimeter, LengthUnits.femtometer),
        10000000000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.centimeter, LengthUnits.attometer),
        10000000000000000);
  });

  test('Test convertUnit with millimeter', () {
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.millimeter, LengthUnits.millimeter),
        1000);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.millimeter, LengthUnits.centimeter),
        100);
    expect(
        MathUtils.convertUnit(1000, LengthUnits.millimeter, LengthUnits.meter),
        1);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.millimeter, LengthUnits.kilometer),
        0.001);
  });

  test('Test convertUnit with micrometers', () {
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.micrometers, LengthUnits.micrometers),
        1000);
  });
}
