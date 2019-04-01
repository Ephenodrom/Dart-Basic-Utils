part of basic_utils;

///
/// Helper class for common math operations
///
class MathUtils {
  ///
  /// Calculate the circumference of a circle with the given radius
  ///
  static double calculateCircumference(double radius) {
    return 2 * pi * radius;
  }

  ///
  /// Calculate the area of a circle with the given radius
  ///
  static double calculateCircularArea(double radius) {
    return pi * (radius * radius);
  }

  ///
  /// Calculate the diameter of a circle with the given radius
  ///
  static double calculateCircleDiameter(double radius) {
    return 2 * radius;
  }

  ///
  /// Calculate the area of a square or rectangle
  ///
  static double calculateSquareArea(double a, {double b}) {
    return b == null ? a * a : a * b;
  }

  ///
  /// Converts the given value from one unit to another unit
  ///
  static double convertUnit(
      double value, LengthUnits sourceUnit, LengthUnits targetUnit) {
    switch (sourceUnit) {
      case LengthUnits.attometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value;
          case LengthUnits.femtometer:
            break;
          case LengthUnits.picometer:
            break;
          case LengthUnits.nanometer:
            break;
          case LengthUnits.micrometers:
            break;
          case LengthUnits.millimeter:
            break;
          case LengthUnits.centimeter:
            break;
          case LengthUnits.decimeter:
            break;
          case LengthUnits.meter:
            break;
          case LengthUnits.kilometer:
            break;
        }
        break;
      case LengthUnits.femtometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            break;
          case LengthUnits.femtometer:
            return value;
          case LengthUnits.picometer:
            break;
          case LengthUnits.nanometer:
            break;
          case LengthUnits.micrometers:
            break;
          case LengthUnits.millimeter:
            break;
          case LengthUnits.centimeter:
            break;
          case LengthUnits.decimeter:
            break;
          case LengthUnits.meter:
            break;
          case LengthUnits.kilometer:
            break;
        }
        break;
      case LengthUnits.picometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            break;
          case LengthUnits.femtometer:
            break;
          case LengthUnits.picometer:
            return value;
          case LengthUnits.nanometer:
            break;
          case LengthUnits.micrometers:
            break;
          case LengthUnits.millimeter:
            break;
          case LengthUnits.centimeter:
            break;
          case LengthUnits.decimeter:
            break;
          case LengthUnits.meter:
            break;
          case LengthUnits.kilometer:
            break;
        }
        break;
      case LengthUnits.nanometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            break;
          case LengthUnits.femtometer:
            break;
          case LengthUnits.picometer:
            break;
          case LengthUnits.nanometer:
            return value;
          case LengthUnits.micrometers:
            break;
          case LengthUnits.millimeter:
            break;
          case LengthUnits.centimeter:
            break;
          case LengthUnits.decimeter:
            break;
          case LengthUnits.meter:
            break;
          case LengthUnits.kilometer:
            break;
        }
        break;
      case LengthUnits.micrometers:
        switch (targetUnit) {
          case LengthUnits.attometer:
            break;
          case LengthUnits.femtometer:
            break;
          case LengthUnits.picometer:
            break;
          case LengthUnits.nanometer:
            break;
          case LengthUnits.micrometers:
            return value;
          case LengthUnits.millimeter:
            break;
          case LengthUnits.centimeter:
            break;
          case LengthUnits.decimeter:
            break;
          case LengthUnits.meter:
            break;
          case LengthUnits.kilometer:
            break;
        }
        break;
      case LengthUnits.millimeter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10, 15);
          case LengthUnits.femtometer:
            return value * pow(10, 12);
          case LengthUnits.picometer:
            return value * pow(10, 9);
          case LengthUnits.nanometer:
            return value * pow(10, 6);
          case LengthUnits.micrometers:
            return value * pow(10, 3);
          case LengthUnits.millimeter:
            return value;
          case LengthUnits.centimeter:
            return value / pow(10, 1);
          case LengthUnits.decimeter:
            return value / pow(10, 2);
          case LengthUnits.meter:
            return value / pow(10, 3);
          case LengthUnits.kilometer:
            return value / pow(10, 6);
        }
        break;
      case LengthUnits.centimeter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * pow(10, 16);
          case LengthUnits.femtometer:
            return value * pow(10, 13);
          case LengthUnits.picometer:
            return value * pow(10, 10);
          case LengthUnits.nanometer:
            return value * pow(10, 7);
          case LengthUnits.micrometers:
            return value * pow(10, 4);
          case LengthUnits.millimeter:
            return value * pow(10, 1);
          case LengthUnits.centimeter:
            return value;
          case LengthUnits.decimeter:
            return value / pow(10, 1);
          case LengthUnits.meter:
            return value / pow(10, 2);
          case LengthUnits.kilometer:
            return value / pow(10, 5);
        }
        break;
      case LengthUnits.decimeter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            break;
          case LengthUnits.femtometer:
            break;
          case LengthUnits.picometer:
            break;
          case LengthUnits.nanometer:
            return value * 100000000;
          case LengthUnits.micrometers:
            return value * 100000;
          case LengthUnits.millimeter:
            return value * 100;
          case LengthUnits.centimeter:
            return value * 10;
          case LengthUnits.decimeter:
            return value;
          case LengthUnits.meter:
            return value / 10;
          case LengthUnits.kilometer:
            return value / 10000;
        }
        break;
      case LengthUnits.meter:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * 1000000000000000000;
          case LengthUnits.femtometer:
            return value * 1000000000000000;
          case LengthUnits.picometer:
            return value * 1000000000000;
          case LengthUnits.nanometer:
            return value * 1000000000;
          case LengthUnits.micrometers:
            return value * 1000000;
          case LengthUnits.millimeter:
            return value * 1000;
          case LengthUnits.centimeter:
            return value * 100;
          case LengthUnits.decimeter:
            return value * 10;
          case LengthUnits.meter:
            return value;
          case LengthUnits.kilometer:
            return value / 1000;
        }
        break;
      case LengthUnits.kilometer:
        switch (targetUnit) {
          case LengthUnits.attometer:
            return value * 1000000000;
          case LengthUnits.femtometer:
            return value * 100000000;
          case LengthUnits.picometer:
            return value * 10000000;
          case LengthUnits.nanometer:
            return value * 1000000;
          case LengthUnits.micrometers:
            return value * 100000;
          case LengthUnits.millimeter:
            return value * 10000;
          case LengthUnits.centimeter:
            return value * 1000;
          case LengthUnits.decimeter:
            return value * 100;
          case LengthUnits.meter:
            return value * 1000;
          case LengthUnits.kilometer:
            return value;
        }
        break;
    }
    return null;
  }
}
