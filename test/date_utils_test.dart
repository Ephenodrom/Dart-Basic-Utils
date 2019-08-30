import 'package:basic_utils/src/DateUtils.dart';
import "package:test/test.dart";

void main() {
  test('Test stringToDateTime', () {
    DateTime now = DateTime.now();
    DateTime actual = DateUtils.stringToDateTime("now");
    expect(actual.year, now.year);
    expect(actual.month, now.month);
    expect(actual.day, now.day);
    expect(actual.hour, now.hour);
    expect(actual.minute, now.minute);
    expect(actual.second, now.second);
    DateTime time = DateTime.parse("2019-07-11 13:27:00");
    actual = DateUtils.stringToDateTime("+1 week 2 days 4 hours 2 seconds",
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

/*
echo strtotime("now"), "\n";
echo strtotime("10 September 2000"), "\n";
echo strtotime("+1 day"), "\n";
echo strtotime("+1 week"), "\n";
echo strtotime("+1 week 2 days 4 hours 2 seconds"), "\n";
echo strtotime("next Thursday"), "\n";
echo strtotime("last Monday"), "\n";
*/
}
