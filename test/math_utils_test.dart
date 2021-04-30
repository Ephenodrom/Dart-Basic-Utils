import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/LengthUnits.dart';
import 'package:test/test.dart';

void main() {
  test('Test convertUnit with kilometer', () {
    expect(
        MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.kilometer),
        1);
    expect(MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.meter),
        1000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.decimeter),
        10000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.centimeter),
        100000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.millimeter),
        1000000);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.kilometer, LengthUnits.micrometers),
        1000000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.nanometer),
        1000000000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.picometer),
        1000000000000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.femtometer),
        1000000000000000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.attometer),
        pow(10.0, 21));
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
            100, LengthUnits.decimeter, LengthUnits.kilometer),
        0.01);
    expect(
        MathUtils.convertUnit(10, LengthUnits.decimeter, LengthUnits.meter), 1);
    expect(
        MathUtils.convertUnit(1, LengthUnits.decimeter, LengthUnits.decimeter),
        1);
    expect(
        MathUtils.convertUnit(1, LengthUnits.decimeter, LengthUnits.centimeter),
        10);
    expect(
        MathUtils.convertUnit(1, LengthUnits.decimeter, LengthUnits.millimeter),
        100);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.decimeter, LengthUnits.micrometers),
        100000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.decimeter, LengthUnits.nanometer),
        100000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.decimeter, LengthUnits.picometer),
        100000000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.decimeter, LengthUnits.femtometer),
        100000000000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.decimeter, LengthUnits.attometer),
        100000000000000000);
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
            10, LengthUnits.centimeter, LengthUnits.decimeter),
        1);
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
            1000, LengthUnits.millimeter, LengthUnits.kilometer),
        0.001);
    expect(
        MathUtils.convertUnit(1000, LengthUnits.millimeter, LengthUnits.meter),
        1);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.millimeter, LengthUnits.decimeter),
        10);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.millimeter, LengthUnits.centimeter),
        100);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.millimeter, LengthUnits.millimeter),
        1000);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.millimeter, LengthUnits.micrometers),
        1000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.millimeter, LengthUnits.nanometer),
        1000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.millimeter, LengthUnits.picometer),
        1000000000);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.millimeter, LengthUnits.femtometer),
        1000000000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.millimeter, LengthUnits.attometer),
        1000000000000000);
  });

  test('Test convertUnit with micrometer', () {
    expect(
        MathUtils.convertUnit(
            100000, LengthUnits.micrometers, LengthUnits.kilometer),
        0.0001);
    expect(
        MathUtils.convertUnit(
            100000, LengthUnits.micrometers, LengthUnits.meter),
        0.1);
    expect(
        MathUtils.convertUnit(
            100000, LengthUnits.micrometers, LengthUnits.decimeter),
        1);
    expect(
        MathUtils.convertUnit(
            100000, LengthUnits.micrometers, LengthUnits.centimeter),
        10);
    expect(
        MathUtils.convertUnit(
            100000, LengthUnits.micrometers, LengthUnits.millimeter),
        100);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.micrometers, LengthUnits.micrometers),
        1000);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.micrometers, LengthUnits.nanometer),
        1000);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.micrometers, LengthUnits.picometer),
        1000000);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.micrometers, LengthUnits.femtometer),
        1000000000);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.micrometers, LengthUnits.attometer),
        1000000000000);
  });

  test('Test convertUnit with nanometer', () {
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.nanometer, LengthUnits.kilometer),
        0.001);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.nanometer, LengthUnits.meter),
        1);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.nanometer, LengthUnits.decimeter),
        10);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.nanometer, LengthUnits.centimeter),
        100);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.nanometer, LengthUnits.millimeter),
        1000);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.nanometer, LengthUnits.micrometers),
        1000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.nanometer, LengthUnits.nanometer),
        1);
    expect(
        MathUtils.convertUnit(1, LengthUnits.nanometer, LengthUnits.picometer),
        1000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.nanometer, LengthUnits.femtometer),
        1000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.nanometer, LengthUnits.attometer),
        1000000000);
  });

  test('Test convertUnit with picometer', () {
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.picometer, LengthUnits.kilometer),
        0.000001);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.picometer, LengthUnits.meter),
        0.001);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.picometer, LengthUnits.decimeter),
        0.01);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.picometer, LengthUnits.centimeter),
        0.1);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.picometer, LengthUnits.millimeter),
        1);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.picometer, LengthUnits.micrometers),
        1000);
    expect(
        MathUtils.convertUnit(
            1000000000, LengthUnits.picometer, LengthUnits.nanometer),
        1000000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.picometer, LengthUnits.picometer),
        1);
    expect(
        MathUtils.convertUnit(1, LengthUnits.picometer, LengthUnits.femtometer),
        1000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.picometer, LengthUnits.attometer),
        1000000);
  });

  test('Test convertUnit with femtometer', () {
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.femtometer, LengthUnits.kilometer),
        0.000001);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.femtometer, LengthUnits.meter),
        0.001);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.femtometer, LengthUnits.decimeter),
        0.01);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.femtometer, LengthUnits.centimeter),
        0.1);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.femtometer, LengthUnits.millimeter),
        1);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.femtometer, LengthUnits.micrometers),
        1000);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.femtometer, LengthUnits.nanometer),
        0.001);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.femtometer, LengthUnits.picometer),
        1);
    expect(
        MathUtils.convertUnit(
            1, LengthUnits.femtometer, LengthUnits.femtometer),
        1);
    expect(
        MathUtils.convertUnit(1, LengthUnits.femtometer, LengthUnits.attometer),
        1000);
  });

  test('Test convertUnit with attometer', () {
    expect(
        MathUtils.convertUnit(pow(10.0, 21) as double, LengthUnits.attometer,
            LengthUnits.kilometer),
        1);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.attometer, LengthUnits.meter),
        0.000001);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.attometer, LengthUnits.decimeter),
        0.00001);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.attometer, LengthUnits.centimeter),
        0.0001);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.attometer, LengthUnits.millimeter),
        0.001);
    expect(
        MathUtils.convertUnit(
            1000000000000, LengthUnits.attometer, LengthUnits.micrometers),
        1);
    expect(
        MathUtils.convertUnit(
            1000000, LengthUnits.attometer, LengthUnits.nanometer),
        0.001);
    expect(
        MathUtils.convertUnit(
            1000, LengthUnits.attometer, LengthUnits.picometer),
        0.001);
    expect(
        MathUtils.convertUnit(
            1000000, LengthUnits.attometer, LengthUnits.femtometer),
        1000);
    expect(
        MathUtils.convertUnit(1, LengthUnits.attometer, LengthUnits.attometer),
        1);
  });

  test('Test calculate mixed temperature', () {
    expect(MathUtils.calculateMixingTemperature(12, 20, 18, 40), 32);
  });

  test('Test calculate mean', () {
    expect(MathUtils.mean([1, 2, 3, 4]), 2.5);
  });

  test('Test round', () {
    expect(MathUtils.round(0.3426, 1), 0.3);
    expect(MathUtils.round(0.3426, 2), 0.34);
    expect(MathUtils.round(0.3426, 3), 0.343);
    expect(MathUtils.round(0.3426, 4), 0.3426);
  });

  test('Test Random Number', () {
    expect(RegExp(r'^[0-9]+$').hasMatch(MathUtils.getRandomNumber().toString()),
        true);

    var test1 = MathUtils.getRandomNumber(max: 100);
    expect(test1 <= 100, true);

    var test2 = MathUtils.getRandomNumber(max: 150, min: 10);
    expect(test2 <= 100 && test2 >= 10, true);
  });
}
