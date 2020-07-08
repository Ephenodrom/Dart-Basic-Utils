# DateUtils

The DateUtils class contains some helper methods for working with dates. It also contains a rebuilt of the famous php **strtotime** method.

## Examples

### Converts English textual datetime description to a DateTime object

```dart
// Adding time
var date = DateUtils.stringToDateTime('+1 week 2 days 4 hours 2 seconds');
date = DateUtils.stringToDateTime('+1 w 2 d 4 h 2 s');
date = DateUtils.stringToDateTime('+24 hours');

// Removing time
date = DateUtils.stringToDateTime('-1 week 2 days 4 hours 2 seconds');
date = DateUtils.stringToDateTime('-1 w 2 d 4 h 2 s');
date = DateUtils.stringToDateTime('-24 hours');

// Tomorrow and yesterday
date = DateUtils.stringToDateTime('tomorrow');
date = DateUtils.stringToDateTime('tomorrow at 00:00:00');
date = DateUtils.stringToDateTime('yesterday');
date = DateUtils.stringToDateTime('yesterday at 00:00:00');

// Last and next
date = DateUtils.stringToDateTime('next sunday');
date = DateUtils.stringToDateTime('last sunday');
date = DateUtils.stringToDateTime('next sunday at 00:00:00');
date = DateUtils.stringToDateTime('last sunday at 00:00:00');
date = DateUtils.stringToDateTime('10:27:00 last friday');
date = DateUtils.stringToDateTime('2 pm next friday');

// Ago
date = DateUtils.stringToDateTime('3 days ago');
date = DateUtils.stringToDateTime('3 months ago at 00:00:00');

// Parsing dates
date = DateUtils.stringToDateTime('10 September 2019');
date = DateUtils.stringToDateTime('10 September 2019 at 01:01:01');

// Now
date = DateUtils.stringToDateTime('now');
```

### Get the current calendar week

```dart
var now = DateTime.now();
int week = DateUtils.getCalendarWeek(now);
print(week);
```

## All methods

```dart
DateTime stringToDateTime(String s, {DateTime time});
int getCalendarWeek(DateTime date);
```
