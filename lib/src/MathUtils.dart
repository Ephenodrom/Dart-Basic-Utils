part of basic_utils;

///
/// Helper class for common math operations
///
class MathUtils {
  ///
  /// Calculate the circumference of a circle with the given [radius]
  ///
  static double calculateCircumference(double radius) {
    return 2 * pi * radius;
  }

  ///
  /// Calculate the area of a circle with the given [radius]
  ///
  static double calculateCircularArea(double radius) {
    return pi * (radius * radius);
  }

  ///
  /// Calculate the diameter of a circle with the given [radius]
  ///
  static double calculateCircleDiameter(double radius) {
    return 2 * radius;
  }

  ///
  /// Calculate the area of a square or rectangle with length [a] and/or length[b]
  ///
  static double calculateSquareArea(double a, {double b}) {
    return b == null ? a * a : a * b;
  }

  ///
  /// Converts the given [value] from the [sourceUnit] to the [targetUnit].
  /// Returns null if converting is not possible
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
        break;
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
        break;
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
        break;
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
        break;
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
            return value / pow(10.0,9);
        }
        break;
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
        break;
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
        break;
      case LengthUnits.decimeter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10.0,17);
          case LengthUnits.femtometer:
            return value * pow(10.0,14);
          case LengthUnits.picometer:
            return value * pow(10.0,11);
          case LengthUnits.nanometer:
            return value * pow(10.0,8);
          case LengthUnits.micrometers:
            return value * pow(10.0,5);
          case LengthUnits.millimeter:
            return value * pow(10.0,2);
          case LengthUnits.centimeter:
            return value * pow(10.0,1);
          case LengthUnits.decimeter:
            return value;
          case LengthUnits.meter:
            return value / pow(10.0,1);
          case LengthUnits.kilometer:
            return value / pow(10.0,4);
        }
        break;
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
        break;
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
        break;
    }
    return null;
  }
}
