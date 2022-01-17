///
/// Helper class for Enum operations
///
class EnumUtils {
  ///
  /// Gets the enum for the enum list, returning defaultEnum if not found.
  ///
  /// Example :
  /// ```dart
  /// stringToEnum('Wednesday', Day.values, Day.Monday); // will receive Day.Wednesday from Day.values
  /// stringToEnum('wednesday', Day.values, Day.Monday, ignoreCase: true); // will receive wednesday from the given Day.values.
  /// ```
  static T getEnum<T extends Enum>(
      final String enumName, final List<T> enumList, final T defaultEnum,
      {bool ignoreCase = false}) {
    return enumList.firstWhere(
      (element) => ignoreCase
          ? element.name.toUpperCase() == enumName.toUpperCase()
          : element.name == enumName,
      orElse: () => defaultEnum,
    );
  }

  ///
  /// Checks if the specified name is a valid enum for the enum list.
  ///
  /// Example :
  /// ```dart
  /// isValidEnum('Wednesday', Day.values); // will receive Day.Wednesday from Day.values
  /// isValidEnum('wednesday', Day.values, ignoreCase: true); // will receive wednesday from the given Day.values.
  /// ```
  static bool isValidEnum(final String enumName, final List<Enum> enumList,
      {bool ignoreCase = false}) {
    try {
      enumList.firstWhere(
        (element) => ignoreCase
            ? element.name.toUpperCase() == enumName.toUpperCase()
            : element.name == enumName,
      );
      return true;
    } catch (ex) {
      return false;
    }
  }

  ///
  /// Gets the Map of enums by name.
  ///
  /// This method is useful when you need a map of enums by name.
  ///
  static Map getEnumMap(final List<Enum> enumList) {
    final map = {};
    enumList.forEach((element) {
      map[element.name] = element;
    });
    return map;
  }
}
