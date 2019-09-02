import 'package:basic_utils/src/DateUtils.dart';
import "package:test/test.dart";

void main() {
  test('Test stringToDateTime with now', () {
    DateTime now = DateTime.now();
    DateTime actual = DateUtils.stringToDateTime("now");
    expect(actual.year, now.year);
    expect(actual.month, now.month);
    expect(actual.day, now.day);
    expect(actual.hour, now.hour);
    expect(actual.minute, now.minute);
    expect(actual.second, now.second);
  });

  test('Test stringToDateTime with add rem', () {
    DateTime time = DateTime.parse("2019-07-11 13:27:00");
    DateTime actual = DateUtils.stringToDateTime(
        "+1 week 2 days 4 hours 2 seconds",
        time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 20);
    expect(actual.hour, 17);
    expect(actual.minute, 27);
    expect(actual.second, 2);
    time = DateTime.parse("2019-07-30 13:27:00");
    actual = DateUtils.stringToDateTime("+1 week 2 days 4 hours 2 seconds",
        time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 8);
    expect(actual.hour, 17);
    expect(actual.minute, 27);
    expect(actual.second, 2);
    time = DateTime.parse("2019-07-30 13:27:00");
    actual = DateUtils.stringToDateTime("+1 w 2 d 4 h 2 s", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 8);
    expect(actual.hour, 17);
    expect(actual.minute, 27);
    expect(actual.second, 2);
    time = DateTime.parse("2019-07-11 13:27:00");
    actual = DateUtils.stringToDateTime("+24 hours", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 12);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    time = DateTime.parse("2019-07-11 13:27:00");
    actual = DateUtils.stringToDateTime("-24 hours", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 10);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    time = DateTime.parse("2019-07-11 13:27:00");
    actual = DateUtils.stringToDateTime(
        "+1 week 2 days at 0 hours 0 minutes 0 seconds",
        time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 20);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);

    time = DateTime.parse("2019-07-11 13:27:00");
    actual =
        DateUtils.stringToDateTime("+1 week 2 days at 00:00:00", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 20);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);
  });

  test('Test stringToDateTime with yesterday tomorrow', () {
    DateTime time = DateTime.parse("2019-07-11 13:27:00");
    DateTime actual = DateUtils.stringToDateTime("tomorrow", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 12);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);

    time = DateTime.parse("2019-07-11 13:27:00");
    actual = DateUtils.stringToDateTime("tomorrow at 00:00:00", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 12);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);
  });

  test('Test stringToDateTime with last and next', () {
    DateTime time = DateTime.parse("2019-09-02 13:27:00");
    DateTime actual = DateUtils.stringToDateTime("next sunday", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 8);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime("last sunday", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 1);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime("last friday at 10:27:00", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 30);
    expect(actual.hour, 10);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime("next friday at 2 pm", time: time);
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 6);
    expect(actual.hour, 14);
    expect(actual.minute, 0);
    expect(actual.second, 0);
  });
}
