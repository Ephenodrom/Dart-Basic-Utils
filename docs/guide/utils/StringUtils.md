# StringUtils

The StringUtils class contains methods to interact and manipulate given strings like chunking them, checking for null values or transform them to other strings.

## All methods

```dart
String defaultString(String str, {String defaultStr = ''});
bool isNullOrEmpty(String s);
bool isNotNullOrEmpty(String s);
String camelCaseToUpperUnderscore(String s);
String camelCaseToLowerUnderscore(String s);
bool isLowerCase(String s);
bool isUpperCase(String s);
bool isAscii(String s);
String capitalize(String s);
String reverse(String s);
int countChars(String s, String char, {bool caseSensitive = true});
bool isDigit(String s);
bool equalsIgnoreCase(String a, String b);
bool inList(String s, List<String> list, {bool ignoreCase = false});
bool isPalindrome(String s);
String hidePartial(String s, {int begin = 0, int end, String replace = "*"});
String addCharAtPosition(String s, String char, int position,{bool repeat = false});
List<String> chunk(String s, chunkSize);
```
