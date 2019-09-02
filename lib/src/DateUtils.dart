///
/// Helper class for date operations.
///
class DateUtils {
  static int daysOfWeek = 7;
  static String regexMonday = "mon|Mon|monday|Monday";
  static String regexTuesday = "tue|Tue|tuesday|Tuesday";
  static String regexWednesday = "wed|Wed|wednesday|Wednesday";
  static String regexThursday = "thu|Thu|thursday|Thursday";
  static String regexFriday = "fri|Fri|friday|Friday";
  static String regexSaturday = "sat|Sat|saturday|Saturday";
  static String regexSunday = "sun|Sun|sunday|Sunday";
  static String regexJanuary = "jan|Jan|january|January";
  static String regexFebruary = "feb|Feb|february|February";
  static String regexMarch = "mar|Mar|march|March";
  static String regexApril = "apr|Apr|april|April";
  static String regexMay = "may|May";
  static String regexJune = "june|June";
  static String regexJuly = "july|July";
  static String regexAugust = "aug|Aug|august|August";
  static String regexSeptember = "sep|Sep|september|September";
  static String regexOctober = "oct|Oct|october|October";
  static String regexNovember = "nov|Nov|november|November";
  static String regexDecember = "dec|Dec|december|December";
  static RegExp REGEX_YEAR = RegExp("^(y|year|years)\$");
  static RegExp REGEX_MONTH = RegExp("^(m|month|months)\$");
  static RegExp REGEX_WEEK = RegExp("^(w|week|weeks)\$");
  static RegExp REGEX_DAY = RegExp("^(d|day|days)\$");
  static RegExp REGEX_HOUR = RegExp("^(h|hour|hours)\$");
  static RegExp REGEX_MINUTES = RegExp("^(m|minute|minutes)\$");
  static RegExp REGEX_SECONDS = RegExp("^(s|second|seconds)\$");
  static RegExp REGEX_MONDAY = RegExp("^($regexMonday)\$");
  static RegExp REGEX_TUESDAY = RegExp("^($regexTuesday)\$");
  static RegExp REGEX_WEDNESDAY = RegExp("^($regexWednesday)\$");
  static RegExp REGEX_THURSDAY = RegExp("^($regexThursday)\$");
  static RegExp REGEX_FRIDAY = RegExp("^($regexFriday)\$");
  static RegExp REGEX_SATURDAY = RegExp("^($regexSaturday)\$");
  static RegExp REGEX_SUNDAY = RegExp("^($regexSunday)\$");
  static RegExp REGEX_JANUARY = RegExp("^($regexJanuary)\$");
  static RegExp REGEX_FEBRUARY = RegExp("^($regexFebruary)\$");
  static RegExp REGEX_MARCH = RegExp("^($regexMarch)\$");
  static RegExp REGEX_APRIL = RegExp("^($regexApril)\$");
  static RegExp REGEX_MAY = RegExp("^($regexMay)\$");
  static RegExp REGEX_JUNE = RegExp("^($regexJune)\$");
  static RegExp REGEX_JULY = RegExp("^($regexJuly)\$");
  static RegExp REGEX_AUGUST = RegExp("^($regexAugust)\$");
  static RegExp REGEX_SEPTEMBER = RegExp("^($regexSeptember)\$");
  static RegExp REGEX_OCTOBER = RegExp("^($regexOctober)\$");
  static RegExp REGEX_NOVEMBER = RegExp("^($regexNovember)\$");
  static RegExp REGEX_DECEMBER = RegExp("^($regexDecember)\$");

  static RegExp REGEX_AM_PM = RegExp(
      "^(\\d{1,2}\\s(pm|am)|\\d{1,2}(\\.|:)\\d{2}\\s(pm|am)|\\d{1,2}(\\.|:)\\d{2}(\\.|:)\\d{2}\\s(pm|am))\$");
  static RegExp REGEX_WEEKDAY = RegExp(
      "^($regexMonday|$regexTuesday|$regexWednesday|$regexThursday|$regexFriday|$regexSaturday|$regexSunday)\$");
  static RegExp REGEX_MONTHS = RegExp(
      "^($regexJanuary|$regexFebruary|$regexMarch|$regexApril|$regexMay|$regexJune|$regexJuly|$regexSeptember|$regexOctober||$regexNovember||$regexDecember)\$");
  static RegExp REGEX_DATE = RegExp(
      "^\\d{1,2}\\s($regexJanuary|$regexFebruary|$regexMarch|$regexApril|$regexMay|$regexJune|$regexJuly|$regexAugust|$regexSeptember|$regexOctober||$regexNovember||$regexDecember)\\s\\d{2,4}.*\$");

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
      return _parseNextLast(s, now);
    } else if (s.startsWith("last")) {
      return _parseNextLast(s, now, last: true);
    } else if (s.startsWith("yesterday")) {
      return _parseYesterdayTomorrow(s, now);
    } else if (s.startsWith("tomorrow")) {
      return _parseYesterdayTomorrow(s, now, tomorrow: true);
    } else if (s.contains("ago")) {
      return _parseAgo(s, now);
    } else {
      if (REGEX_DATE.hasMatch(s)) {
        return _parseDate(s);
      }
    }
    return DateTime.now();
  }

  static DateTime _parseDate(String s) {
    String date;
    String setTime;
    if (s.contains("at")) {
      List<String> list = s.split("at");
      date = list.elementAt(0).trim();
      setTime = list.elementAt(1).trim();
    } else {
      date = s.trim();
    }
    List<String> dateSplitted = date.split(" ");
    String monthAsInt = "";
    if (REGEX_JANUARY.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.january.toString();
    }
    if (REGEX_FEBRUARY.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.february.toString();
    }
    if (REGEX_MARCH.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.march.toString();
    }
    if (REGEX_APRIL.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.april.toString();
    }
    if (REGEX_MAY.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.may.toString();
    }
    if (REGEX_JUNE.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.june.toString();
    }
    if (REGEX_JULY.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.july.toString();
    }
    if (REGEX_AUGUST.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.august.toString();
    }
    if (REGEX_SEPTEMBER.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = "0" + DateTime.september.toString();
    }
    if (REGEX_OCTOBER.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = DateTime.october.toString();
    }
    if (REGEX_NOVEMBER.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = DateTime.november.toString();
    }
    if (REGEX_DECEMBER.hasMatch(dateSplitted.elementAt(1))) {
      monthAsInt = DateTime.december.toString();
    }
    DateTime time = DateTime.parse(
        "${dateSplitted.elementAt(2)}-$monthAsInt-${dateSplitted.elementAt(0)} 00:00:00");
    if (setTime != null) {
      time = _parseSetTime(setTime, time);
    }
    return time;
  }

  static DateTime _parseAgo(String s, DateTime now) {
    s = s.substring(0, s.length - 3).trim();
    return _parseAddRem(s, now, rem: true);
  }

  static DateTime _parseYesterdayTomorrow(String s, DateTime now,
      {bool tomorrow = false}) {
    DateTime time;
    if (tomorrow) {
      time = now.add(Duration(days: 1));
    } else {
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
    // Remove the + or -
    if (s.startsWith("+") || s.startsWith("-")) {
      s = s.substring(1);
    }

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
        // print("Add / Rem $valueAsInt week(s)");
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

  static DateTime _parseNextLast(String s, DateTime now, {bool last = false}) {
    if (s.startsWith("next") || s.startsWith("last")) {
      s = s.substring(4);
    }
    String lastNext;
    String setTime;
    if (s.contains("at")) {
      List<String> list = s.split("at");
      lastNext = list.elementAt(0).trim();
      setTime = list.elementAt(1).trim();
    } else {
      lastNext = s.trim();
    }
    if (REGEX_WEEKDAY.hasMatch(lastNext)) {
      int currentDay = now.weekday;
      int daysToAdd;
      int targetDay;
      if (REGEX_SUNDAY.hasMatch(lastNext)) {
        targetDay = DateTime.sunday;
      }
      if (REGEX_SATURDAY.hasMatch(lastNext)) {
        targetDay = DateTime.saturday;
      }
      if (REGEX_FRIDAY.hasMatch(lastNext)) {
        targetDay = DateTime.friday;
      }
      if (REGEX_THURSDAY.hasMatch(lastNext)) {
        targetDay = DateTime.thursday;
      }
      if (REGEX_WEDNESDAY.hasMatch(lastNext)) {
        targetDay = DateTime.wednesday;
      }
      if (REGEX_TUESDAY.hasMatch(lastNext)) {
        targetDay = DateTime.tuesday;
      }
      if (REGEX_MONDAY.hasMatch(lastNext)) {
        targetDay = DateTime.monday;
      }

      if (last) {
        if (currentDay < targetDay) {
          daysToAdd = daysOfWeek - targetDay + currentDay;
        } else {
          daysToAdd = targetDay - (daysOfWeek - currentDay);
        }
        now = now.add(Duration(days: daysToAdd * -1));
      } else {
        daysToAdd = targetDay - currentDay;
        now = now.add(Duration(days: daysToAdd));
      }
      if (setTime != null) {
        now = _parseSetTime(setTime, now);
      }
      return now;
    }
    if (REGEX_MONTHS.hasMatch(lastNext)) {
      // handle months
    }
    return null;
  }

  static DateTime _parseSetTime(String setTime, DateTime time) {
    if (setTime.contains(":")) {
      DateTime hhmmss = DateTime.parse("1970-01-01 " + setTime);
      return DateTime(time.year, time.month, time.day, hhmmss.hour,
          hhmmss.minute, hhmmss.second);
    } else if (REGEX_AM_PM.hasMatch(setTime)) {
      int baseTime = 0;
      if (setTime.endsWith("pm") || setTime.endsWith("PM")) {
        baseTime = 12;
      }
      setTime = setTime.substring(0, setTime.length - 2).trim();
      setTime = setTime.replaceAll("\.", ":");
      if (setTime.length == 1) {
        setTime = "0$setTime:00:00";
      } else if (setTime.length == 3) {
        setTime = "0$setTime:00";
      } else if (setTime.length == 4) {
        setTime = "$setTime:00:00";
      } else if (setTime.length == 5) {
        setTime = "0$setTime";
      }
      DateTime hhmmss = DateTime.parse("1970-01-01 " + setTime);
      return DateTime(time.year, time.month, time.day, hhmmss.hour + baseTime,
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
          time = DateTime(time.year, time.month, time.day, time.hour,
              valueAsInt, time.second);
        } else if (REGEX_SECONDS.hasMatch(type)) {
          time = DateTime(time.year, time.month, time.day, time.hour,
              time.minute, valueAsInt);
        }
      }
      return time;
    }
  }
}
