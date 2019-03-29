part of basic_utils;

///
/// Helper class for common math operations
///
class MathUtils {

  ///
  /// Calculate the circumference of a circle with the given radius
  ///
  static double calculateCircumference(double radius){
    return 2 * pi * radius;
  }

  ///
  /// Calculate the area of a circle with the given radius
  ///
  static double calculateCircularArea(double radius){
    return pi * (radius * radius);
  }

  ///
  /// Calculate the diameter of a circle with the given radius
  ///
  static double calculateCircleDiameter(double radius){
    return 2 * radius;
  }

  ///
  /// Calculate the area of a square or rectangle
  ///
  static double calculateSquareArea(double a, {double b}){
    if(b == null){
      return a *a;
    }else{
      return a * b;
    }
  }

  ///
  /// Converts the given value from one unit to another unit
  ///
  static double convertUnit(double value, LengthUnits sourceUnit, LengthUnits targetUnit){
    switch(sourceUnit){
      case LengthUnits.attometer:
        switch(targetUnit){
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
          case LengthUnits.mile:
            break;
        }
        break;
      case LengthUnits.femtometer:
        switch(targetUnit){
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
          case LengthUnits.mile:
            break;
        }
        break;
      case LengthUnits.picometer:
        switch(targetUnit){
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
          case LengthUnits.mile:
            break;
        }
        break;
      case LengthUnits.nanometer:
        switch(targetUnit){
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
          case LengthUnits.mile:
            break;
        }
        break;
      case LengthUnits.micrometers:
        switch(targetUnit){
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
          case LengthUnits.mile:
            break;
        }
        break;
      case LengthUnits.millimeter:
        switch(targetUnit){
          case LengthUnits.attometer:
            break;
          case LengthUnits.femtometer:
            break;
          case LengthUnits.picometer:
            break;
          case LengthUnits.nanometer:
            return value * 100000;
          case LengthUnits.micrometers:
            return value * 1000;
          case LengthUnits.millimeter:
            return value;
          case LengthUnits.centimeter:
            return value / 10;
          case LengthUnits.decimeter:
            return value / 100;
          case LengthUnits.meter:
            return value / 1000;
          case LengthUnits.kilometer:
            return value / 1000000;
          case LengthUnits.mile:
            break;
        }
        break;
      case LengthUnits.centimeter:
        switch(targetUnit){
          case LengthUnits.attometer:
            return value * 10000000000000000;
          case LengthUnits.femtometer:
            return value * 10000000000000;
          case LengthUnits.picometer:
            return value * 10000000000;
          case LengthUnits.nanometer:
            return value * 10000000;
          case LengthUnits.micrometers:
            return value * 10000;
          case LengthUnits.millimeter:
            return value * 10;
          case LengthUnits.centimeter:
            return value;
          case LengthUnits.decimeter:
            return value / 10;
          case LengthUnits.meter:
            return value / 100;
          case LengthUnits.kilometer:
            return value / 100000;
          case LengthUnits.mile:
            return value / 160934.4;
        }
        break;
      case LengthUnits.decimeter:
        switch(targetUnit){
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
          case LengthUnits.mile:
            break;
        }
        break;
      case LengthUnits.meter:
        switch(targetUnit){
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
          case LengthUnits.mile:
            return value / 1609.344;
        }
        break;
      case LengthUnits.kilometer:
        switch(targetUnit){
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
          case LengthUnits.mile:
            return value / 1.609;
        }
        break;
      case LengthUnits.mile:
        switch(targetUnit){
          case LengthUnits.attometer:
            return null;
          case LengthUnits.femtometer:
            return value * 1609344000000000000;
          case LengthUnits.picometer:
            return value * 1609344000000000;
          case LengthUnits.nanometer:
            return value * 1609344000000;
          case LengthUnits.micrometers:
            return value * 1609344000;
          case LengthUnits.millimeter:
            return value * 1609344;
          case LengthUnits.centimeter:
            return value * 160934.4;
          case LengthUnits.decimeter:
            return value * 16093.44;
          case LengthUnits.meter:
            return value * 1609.344;
          case LengthUnits.kilometer:
            return value * 1.609;
          case LengthUnits.mile:
            return value;
        }
        break;
    }
    return null;
  }

}