import 'package:basic_utils/src/DateUtils.dart';
import 'package:test/test.dart';

void main() {
  test('Test stringToDateTime with now', () {
    var now = DateTime.now();
    var actual = DateUtils.stringToDateTime('now');
    expect(actual.year, now.year);
    expect(actual.month, now.month);
    expect(actual.day, now.day);
    expect(actual.hour, now.hour);
    expect(actual.minute, now.minute);
    expect(actual.second, now.second);
  });

  test('Test stringToDateTime with add rem', () {
    var time = DateTime.parse('2019-07-11 13:27:00');
    var actual = DateUtils.stringToDateTime('+1 week 2 days 4 hours 2 seconds',
        time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 20);
    expect(actual.hour, 17);
    expect(actual.minute, 27);
    expect(actual.second, 2);
    time = DateTime.parse('2019-07-30 13:27:00');
    actual = DateUtils.stringToDateTime('+1 week 2 days 4 hours 2 seconds',
        time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 8);
    expect(actual.hour, 17);
    expect(actual.minute, 27);
    expect(actual.second, 2);
    time = DateTime.parse('2019-07-30 13:27:00');
    actual = DateUtils.stringToDateTime('+1 w 2 d 4 h 2 s', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 8);
    expect(actual.hour, 17);
    expect(actual.minute, 27);
    expect(actual.second, 2);
    time = DateTime.parse('2019-07-11 13:27:00');
    actual = DateUtils.stringToDateTime('+24 hours', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 12);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    time = DateTime.parse('2019-07-11 13:27:00');
    actual = DateUtils.stringToDateTime('-24 hours', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 10);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    time = DateTime.parse('2019-07-11 13:27:00');
    actual = DateUtils.stringToDateTime(
        '+1 week 2 days at 0 hours 0 minutes 0 seconds',
        time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 20);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);

    time = DateTime.parse('2019-07-11 13:27:00');
    actual =
        DateUtils.stringToDateTime('+1 week 2 days at 00:00:00', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 20);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);
  });

  test('Test stringToDateTime with yesterday tomorrow', () {
    var time = DateTime.parse('2019-07-11 13:27:00');
    var actual = DateUtils.stringToDateTime('tomorrow', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 12);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);

    time = DateTime.parse('2019-07-11 13:27:00');
    actual = DateUtils.stringToDateTime('tomorrow at 00:00:00', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 12);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);
  });

  test('Test stringToDateTime with last and next', () {
    var time = DateTime.parse('2019-09-02 13:27:00');
    var actual = DateUtils.stringToDateTime('next sunday', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 8);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime('last sunday', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 1);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime('last friday at 10:27:00', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 30);
    expect(actual.hour, 10);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime('next friday at 2 pm', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 6);
    expect(actual.hour, 14);
    expect(actual.minute, 0);
    expect(actual.second, 0);

    actual = DateUtils.stringToDateTime('10:27:00 last friday', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 30);
    expect(actual.hour, 10);
    expect(actual.minute, 27);
    expect(actual.second, 0);

    actual = DateUtils.stringToDateTime('2 pm next friday', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 6);
    expect(actual.hour, 14);
    expect(actual.minute, 0);
    expect(actual.second, 0);

    actual = DateUtils.stringToDateTime('2 pm next week', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 9);
    expect(actual.hour, 14);
    expect(actual.minute, 0);
    expect(actual.second, 0);
  });

  test('Test stringToDateTime with yesterday tomorrow', () {
    var time = DateTime.parse('2019-07-11 13:27:00');
    var actual = DateUtils.stringToDateTime('tomorrow', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 12);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);

    time = DateTime.parse('2019-07-11 13:27:00');
    actual = DateUtils.stringToDateTime('tomorrow at 00:00:00', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 7);
    expect(actual.day, 12);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);
  });

  test('Test stringToDateTime with ago', () {
    var time = DateTime.parse('2019-09-02 13:27:00');
    var actual = DateUtils.stringToDateTime('2 weeks ago', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 19);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime('3 months ago at 00:00:00', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 6);
    expect(actual.day, 2);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime('3 days ago', time: time);
    expect(actual.year, 2019);
    expect(actual.month, 8);
    expect(actual.day, 30);
    expect(actual.hour, 13);
    expect(actual.minute, 27);
    expect(actual.second, 0);
  });

  test('Test stringToDateTime with date', () {
    var actual = DateUtils.stringToDateTime('10 September 2019');
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 10);
    expect(actual.hour, 0);
    expect(actual.minute, 0);
    expect(actual.second, 0);
    actual = DateUtils.stringToDateTime('10 September 2019 at 01:01:01');
    expect(actual.year, 2019);
    expect(actual.month, 9);
    expect(actual.day, 10);
    expect(actual.hour, 1);
    expect(actual.minute, 1);
    expect(actual.second, 1);
    actual = DateUtils.stringToDateTime('29 Feb 2020 at 13:45:59');
    expect(actual.year, 2020);
    expect(actual.month, 2);
    expect(actual.day, 29);
    expect(actual.hour, 13);
    expect(actual.minute, 45);
    expect(actual.second, 59);
  });

  test('Test getCalendarWeek', () {
    var date = DateTime.parse('2020-01-02 13:27:00');
    expect(DateUtils.getCalendarWeek(date), 1);

    date = DateTime.parse('2019-12-31 13:27:00');
    expect(DateUtils.getCalendarWeek(date), 53);
  });
}
