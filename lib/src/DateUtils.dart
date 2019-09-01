///
/// Helper class for date operations.
/// 
class DateUtils {
  static RegExp REGEX_YEAR = RegExp("^(y|year|years)\$");
  static RegExp REGEX_MONTH = RegExp("^(m|month|months)\$");
  static RegExp REGEX_WEEK = RegExp("^(w|week|weeks)\$");
  static RegExp REGEX_DAY = RegExp("^(d|day|days)\$");
  static RegExp REGEX_HOUR = RegExp("^(h|hour|hours)\$");
  static RegExp REGEX_MINUTES = RegExp("^(m|minute|minutes)\$");
  static RegExp REGEX_SECONDS = RegExp("^(s|second|seconds)\$");
  static RegExp REGEX_MONDAY = RegExp("^(mon|Mon|monday|Monday)\$");
  static RegExp REGEX_TUESDAY = RegExp("^(tue|Tue|tuesday|Tuesday)\$");
  static RegExp REGEX_WEDNESDAY = RegExp("^(wed|Wed|wednesday|Wednesday)\$");
  static RegExp REGEX_THURSDAY = RegExp("^(thu|Thu|thursday|Thursday)\$");
  static RegExp REGEX_FRIDAY = RegExp("^(fri|Fri|friday|Friday)\$");
  statix RegExp REGEX_SATURDAY = RegExp("^(sat|Sat|saturday|Saturday)\$");
  static RegExp REGEX_SUNDAY = RegExp("^(sun|Sun|sunday|Sunday)\$");

  ///
  /// Converts English textual datetime description to a [DateTime] object.
  ///
  static DateTime stringToDateTime(String s, {DateTime time}) {
    DateTime now = DateTime.now();
    if (s == "now") {
      return now;
    }
    now = time != null ? time : now;
    if (s.startsWith("+")) {
      return _parseAddRem(s, now);
    } else if (s.startsWith("-")) {
      return _parseAddRem(s, now, rem: true);
    } else if (s.startsWith("next")) {
      return _parseNext(s, now);
    } else if (s.startsWith("last")) {
      return _parseLast(s, now);
    } else if (s.startsWith("yesterday")){
      return _parseYesterdayTomorrow(s, now);
    } else if (s.startsWith("tomorrow")){
      return _parseYesterdayTomorrow(s, now, tomorrow: true);
    } 
    return DateTime.now();
  }

  static DateTime _parseYesterdayTomorrow(String s, DateTime now, {bool tomorrow = false}){
    DateTime time;
    if(tomorrow){
      time = now.add(Duration(days: 1));
    }else{
      time = now.subtract(Duration(days: 1));
    }
    if (s.contains("at")) {
      List<String> list = s.split("at");
      String setTime = list.elementAt(1).trim();
      time = _parseSetTime(setTime, time);
    }
    return time;
  } 

  static DateTime _parseAddRem(String s, DateTime now, {bool rem = false}) {
    // Remove the +
    s = s.substring(1);

    String addRem;
    String setTime;
    if (s.contains("at")) {
      List<String> list = s.split("at");
      addRem = list.elementAt(0).trim();
      setTime = list.elementAt(1).trim();
    } else {
      addRem = s.trim();
    }
    // Split the string
    List<String> list = addRem.split(" ");
    for (int i = 1; i < list.length; i += 2) {
      String value = list.elementAt(i - 1);
      int valueAsInt = int.parse(value);
      if (rem) {
        valueAsInt = valueAsInt * -1;
      }
      String type = list.elementAt(i);
      if (REGEX_YEAR.hasMatch(type)) {
        //print("Add $valueAsInt year(s)");
        now = new DateTime(now.year + valueAsInt, now.month, now.day, now.hour,
            now.minute, now.second);
      } else if (REGEX_MONTH.hasMatch(type)) {
        //print("Add $valueAsInt month(s)");
        now = new DateTime(now.year, now.month + valueAsInt, now.day, now.hour,
            now.minute, now.second);
      } else if (REGEX_WEEK.hasMatch(type)) {
        //print("Add $valueAsInt week(s)");
        now = now.add(Duration(days: 7 * valueAsInt));
      } else if (REGEX_DAY.hasMatch(type)) {
        //print("Add $valueAsInt day(s)");
        now = now.add(Duration(days: valueAsInt));
      } else if (REGEX_HOUR.hasMatch(type)) {
        //print("Add $valueAsInt hour(s)");
        now = now.add(Duration(hours: valueAsInt));
      } else if (REGEX_MINUTES.hasMatch(type)) {
        //print("Add $valueAsInt minute(s)");
        now = now.add(Duration(minutes: valueAsInt));
      } else if (REGEX_SECONDS.hasMatch(type)) {
        //print("Add $valueAsInt second(s)");
        now = now.add(Duration(seconds: valueAsInt));
      }
    }
    if (setTime != null) {
      if (setTime.contains(":")) {
        DateTime hhmmss = DateTime.parse("1970-01-01 " + setTime);
        now = new DateTime(now.year, now.month, now.day, hhmmss.hour,
            hhmmss.minute, hhmmss.second);
      } else {
        List<String> list = setTime.split(" ");
        for (int i = 1; i < list.length; i += 2) {
          String value = list.elementAt(i - 1);
          int valueAsInt = int.parse(value);
          if (rem) {
            valueAsInt = valueAsInt * -1;
          }
          String type = list.elementAt(i);
          if (REGEX_HOUR.hasMatch(type)) {
            now = new DateTime(now.year, now.month, now.day, valueAsInt,
                now.minute, now.second);
          } else if (REGEX_MINUTES.hasMatch(type)) {
            now = new DateTime(
                now.year, now.month, now.day, now.hour, valueAsInt, now.second);
          } else if (REGEX_SECONDS.hasMatch(type)) {
            now = new DateTime(
                now.year, now.month, now.day, now.hour, now.minute, valueAsInt);
          }
        }
      }
    }
    return now;
  }

  static DateTime _parseNext(String s, DateTime now) {
    return null;
  }

  static DateTime _parseLast(String s, DateTime now) {
    return null;
  }

  static DateTime _parseSetTime(String setTime, DateTime time){
    if (setTime.contains(":")) {
        DateTime hhmmss = DateTime.parse("1970-01-01 " + setTime);
        return DateTime(time.year, time.month, time.day, hhmmss.hour,
            hhmmss.minute, hhmmss.second);
      } else {
        List<String> list = setTime.split(" ");
        for (int i = 1; i < list.length; i += 2) {
          String value = list.elementAt(i - 1);
          int valueAsInt = int.parse(value);
          String type = list.elementAt(i);
          if (REGEX_HOUR.hasMatch(type)) {
            time = DateTime(time.year, time.month, time.day, valueAsInt,
                time.minute, time.second);
          } else if (REGEX_MINUTES.hasMatch(type)) {
            time = DateTime(
                time.year, time.month, time.day, time.hour, valueAsInt, time.second);
          } else if (REGEX_SECONDS.hasMatch(type)) {
            time = DateTime(
                time.year, time.month, time.day, time.hour, time.minute, valueAsInt);
          }
        }
        return time;
      }
  }
}
