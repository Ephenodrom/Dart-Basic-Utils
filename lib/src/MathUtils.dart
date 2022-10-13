import 'dart:math';

import 'package:basic_utils/src/model/LengthUnits.dart';

///
/// Helper class for common math operations.
///
class MathUtils {
  ///
  /// Calculate the circumference of a circle with the given [radius].
  ///
  static double calculateCircumference(double radius) {
    return 2 * pi * radius;
  }

  ///
  /// Calculate the area of a circle with the given [radius].
  ///
  static double calculateCircularArea(double radius) {
    return pi * (radius * radius);
  }

  ///
  /// Calculate the diameter of a circle with the given [radius].
  ///
  static double calculateCircleDiameter(double radius) {
    return 2 * radius;
  }

  ///
  /// Calculate the area of a square or rectangle with length [a] and/or length[b].
  ///
  static double calculateSquareArea(double a, {double? b}) {
    return b == null ? a * a : a * b;
  }

  ///
  /// Converts the given [value] from the [sourceUnit] to the [targetUnit].
  /// Returns null if converting is not possible.
  ///
  static double convertUnit(
      double value, LengthUnits sourceUnit, LengthUnits targetUnit) {
    switch (sourceUnit) {
      case LengthUnits.attometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value;
          case LengthUnits.femtometer:
            return value / pow(10.0, 3);
          case LengthUnits.picometer:
            return value / pow(10.0, 6);
          case LengthUnits.nanometer:
            return value / pow(10.0, 9);
          case LengthUnits.micrometers:
            return value / pow(10.0, 12);
          case LengthUnits.millimeter:
            return value / pow(10.0, 15);
          case LengthUnits.centimeter:
            return value / pow(10.0, 16);
          case LengthUnits.decimeter:
            return value / pow(10.0, 17);
          case LengthUnits.meter:
            return value / pow(10.0, 18);
          case LengthUnits.kilometer:
            return value / pow(10.0, 21.0);
        }
      case LengthUnits.femtometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 3);
          case LengthUnits.femtometer:
            return value;
          case LengthUnits.picometer:
            return value / pow(10.0, 3);
          case LengthUnits.nanometer:
            return value / pow(10.0, 6);
          case LengthUnits.micrometers:
            return value / pow(10.0, 9);
          case LengthUnits.millimeter:
            return value / pow(10.0, 12);
          case LengthUnits.centimeter:
            return value / pow(10.0, 13);
          case LengthUnits.decimeter:
            return value / pow(10.0, 14);
          case LengthUnits.meter:
            return value / pow(10.0, 15);
          case LengthUnits.kilometer:
            return value / pow(10.0, 18);
        }
      case LengthUnits.picometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 6);
          case LengthUnits.femtometer:
            return value * pow(10.0, 3);
          case LengthUnits.picometer:
            return value;
          case LengthUnits.nanometer:
            return value / pow(10.0, 3);
          case LengthUnits.micrometers:
            return value / pow(10.0, 6);
          case LengthUnits.millimeter:
            return value / pow(10.0, 9);
          case LengthUnits.centimeter:
            return value / pow(10.0, 10);
          case LengthUnits.decimeter:
            return value / pow(10.0, 11);
          case LengthUnits.meter:
            return value / pow(10.0, 12);
          case LengthUnits.kilometer:
            return value / pow(10.0, 15);
        }
      case LengthUnits.nanometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 9);
          case LengthUnits.femtometer:
            return value * pow(10.0, 6);
          case LengthUnits.picometer:
            return value * pow(10.0, 3);
          case LengthUnits.nanometer:
            return value;
          case LengthUnits.micrometers:
            return value / pow(10.0, 3);
          case LengthUnits.millimeter:
            return value / pow(10.0, 6);
          case LengthUnits.centimeter:
            return value / pow(10.0, 7);
          case LengthUnits.decimeter:
            return value / pow(10.0, 8);
          case LengthUnits.meter:
            return value / pow(10.0, 9);
          case LengthUnits.kilometer:
            return value / pow(10.0, 12);
        }
      case LengthUnits.micrometers:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 12);
          case LengthUnits.femtometer:
            return value * pow(10.0, 9);
          case LengthUnits.picometer:
            return value * pow(10.0, 6);
          case LengthUnits.nanometer:
            return value * pow(10.0, 3);
          case LengthUnits.micrometers:
            return value;
          case LengthUnits.millimeter:
            return value / pow(10.0, 3);
          case LengthUnits.centimeter:
            return value / pow(10.0, 4);
          case LengthUnits.decimeter:
            return value / pow(10.0, 5);
          case LengthUnits.meter:
            return value / pow(10.0, 6);
          case LengthUnits.kilometer:
            return value / pow(10.0, 9);
        }
      case LengthUnits.millimeter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 15);
          case LengthUnits.femtometer:
            return value * pow(10.0, 12);
          case LengthUnits.picometer:
            return value * pow(10.0, 9);
          case LengthUnits.nanometer:
            return value * pow(10.0, 6);
          case LengthUnits.micrometers:
            return value * pow(10.0, 3);
          case LengthUnits.millimeter:
            return value;
          case LengthUnits.centimeter:
            return value / pow(10.0, 1);
          case LengthUnits.decimeter:
            return value / pow(10.0, 2);
          case LengthUnits.meter:
            return value / pow(10.0, 3);
          case LengthUnits.kilometer:
            return value / pow(10.0, 6);
        }
      case LengthUnits.centimeter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 16);
          case LengthUnits.femtometer:
            return value * pow(10.0, 13);
          case LengthUnits.picometer:
            return value * pow(10.0, 10);
          case LengthUnits.nanometer:
            return value * pow(10.0, 7);
          case LengthUnits.micrometers:
            return value * pow(10.0, 4);
          case LengthUnits.millimeter:
            return value * pow(10.0, 1);
          case LengthUnits.centimeter:
            return value;
          case LengthUnits.decimeter:
            return value / pow(10.0, 1);
          case LengthUnits.meter:
            return value / pow(10.0, 2);
          case LengthUnits.kilometer:
            return value / pow(10.0, 5);
        }
      case LengthUnits.decimeter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 17);
          case LengthUnits.femtometer:
            return value * pow(10.0, 14);
          case LengthUnits.picometer:
            return value * pow(10.0, 11);
          case LengthUnits.nanometer:
            return value * pow(10.0, 8);
          case LengthUnits.micrometers:
            return value * pow(10.0, 5);
          case LengthUnits.millimeter:
            return value * pow(10.0, 2);
          case LengthUnits.centimeter:
            return value * pow(10.0, 1);
          case LengthUnits.decimeter:
            return value;
          case LengthUnits.meter:
            return value / pow(10.0, 1);
          case LengthUnits.kilometer:
            return value / pow(10.0, 4);
        }
      case LengthUnits.meter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 18);
          case LengthUnits.femtometer:
            return value * pow(10.0, 15);
          case LengthUnits.picometer:
            return value * pow(10.0, 12);
          case LengthUnits.nanometer:
            return value * pow(10.0, 9);
          case LengthUnits.micrometers:
            return value * pow(10.0, 6);
          case LengthUnits.millimeter:
            return value * pow(10.0, 3);
          case LengthUnits.centimeter:
            return value * pow(10.0, 2);
          case LengthUnits.decimeter:
            return value * pow(10.0, 1);
          case LengthUnits.meter:
            return value;
          case LengthUnits.kilometer:
            return value / pow(10.0, 3);
        }
      case LengthUnits.kilometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0, 21);
          case LengthUnits.femtometer:
            return value * pow(10.0, 18);
          case LengthUnits.picometer:
            return value * pow(10.0, 15);
          case LengthUnits.nanometer:
            return value * pow(10.0, 12);
          case LengthUnits.micrometers:
            return value * pow(10.0, 9);
          case LengthUnits.millimeter:
            return value * pow(10.0, 6);
          case LengthUnits.centimeter:
            return value * pow(10.0, 5);
          case LengthUnits.decimeter:
            return value * pow(10.0, 4);
          case LengthUnits.meter:
            return value * pow(10.0, 3);
          case LengthUnits.kilometer:
            return value;
        }
    }
  }

  ///
  /// Calculates the mixing temperature for substance A represented with [mA], [tA], [cA] and substance B
  /// represented with [mB], [tB], [cB].
  ///
  /// If [cA] or [cB] is null, it is assumed that both values are equal.
  ///
  /// [mA] and [mB] are the masses of the substances and must be expressed in kilograms (kg).
  /// [tA] and [tB] are the temperatur of the substances and must be expressed in celsius (C).
  /// [cA] and [cB] are the specific heat capacity of the substances and must be expressed in joule per kilogram times Celsius (J/kg*C).
  ///
  static double calculateMixingTemperature(
      double mA, double tA, double mB, double tB,
      {double? cA, double? cB}) {
    if (cA == null || cB == null) {
      return ((mA * tA) + (mB * tB)) / (mA + mB);
    }
    return ((mA * cA * tA) + (mB * cB * tB)) / ((mA * cA) + (mB * cB));
  }

  ///
  /// Calculates the arithmetic average of the given list of numbers.
  ///
  static num mean(List<num> l) => l.reduce((num p, num n) => p + n) / l.length;

  ///
  /// Rounds the give double [value] to the given [decimals].
  ///
  static double round(double value, int decimals) =>
      (value * pow(10, decimals)).round() / pow(10, decimals);

  ///
  /// Generates random between be [min] and [max]
  ///
  static int getRandomNumber({int min = 0, int max = 2 ^ 32}) =>
      min + Random().nextInt(max - min);

  ///
  /// Returns the median of numbers in a sorted list of numbers.
  /// [sorted] must not be empty.
  ///
  static num median(List<num> sorted) {
    var isEven = sorted.length % 2 == 0;
    if (isEven) {
      var middleIdx = (sorted.length >> 1) - 1;
      return mean([sorted[middleIdx], sorted[middleIdx + 1]]);
    } else {
      return sorted[sorted.length >> 1];
    }
  }

  ///
  /// Converts [x] to a double and returns the logarithm with [base] of the
  /// value.
  /// Returns negative infinity if [x] is equal to zero.
  /// Returns NaN if [x] is NaN or less than zero.
  /// Returns 0 if [base] is 0.
  ///
  static double logBase(num x, num base) {
    return log(x) / log(base);
  }

  ///
  /// Return the binary logarithm of [x], that is, the logarithm with base 2.
  /// See also [logBase].
  ///
  static double log2(num x) {
    return logBase(x, 2);
  }

  ///
  /// Return the common logarithm of [x], that is, the logarithm with base 10.
  /// See also [logBase].
  ///
  static double log10(num x) {
    return logBase(x, 10);
  }
}
