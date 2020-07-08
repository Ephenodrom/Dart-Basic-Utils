# ColorUtils

The ColorUtils contains some helper methods for work with colors. This can be pretty handy if you use this with flutter or any web project.

## Examples

### Lighten or darken a hex color by x percent

```dart
String hex = ColorUtils.shadeColor('#6699CC', 20); //#7ab8f5
hex = ColorUtils.shadeColor('#69C', -50); //#334d66
hex = ColorUtils.shadeColor('#9c27b0', -32.1); //#6a1a78
```

### Converting int to hex and hex to int

```dart
hex = ColorUtils.intToHex(0xFFFFFFFF); //#FFFFFF
int i = ColorUtils.hexToInt('#FFFFFF'); //0xFFFFFFFF
```

### Get basic colors from hex

```dart
var bC = ColorUtils.basicColorsFromHex('#4287f5');

bC[ColorUtils.BASIC_COLOR_RED]; //66
bC[ColorUtils.BASIC_COLOR_GREEN]; //135
bC[ColorUtils.BASIC_COLOR_BLUE]; //245
```

### Swatch a hex color

```dart
var colors = ColorUtils.swatchColor('#f44336');
colors.elementAt(0); // #ff755f
colors.elementAt(1); // #ff6b56
colors.elementAt(2); // #ff614e
colors.elementAt(3); // #ff5746
colors.elementAt(4); // #ff4d3e
colors.elementAt(5); // #f44336
colors.elementAt(6); // #cf392e
colors.elementAt(7); // #ab2f26
colors.elementAt(8); // #86251e
colors.elementAt(9); // #621b16
colors.elementAt(10); // #3d110e
```

## All methods

```dart
int hexToInt(String hex);
String intToHex(int i);
String shadeColor(String hex, int percent);
String fillUpHex(String hex);
bool isDark(String hex);
String contrastColor(String hex);
Map<String, int> basicColorsFromHex(String hex);
double calculateRelativeLuminance(int red, int green, int blue,{int decimals = 2});
List<String> swatchColor(String hex, {double percentage = 15, int amount = 5});
```
