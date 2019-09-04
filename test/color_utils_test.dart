import 'package:basic_utils/src/ColorUtils.dart';
import "package:test/test.dart";

void main() {
  test('Test hex to int', () {
    expect(ColorUtils.hexToInt("#FFFFFF"), 0xFFFFFFFF);
    expect(ColorUtils.hexToInt("FFFFFF"), 0xFFFFFFFF);
    expect(ColorUtils.hexToInt("#EF5350"), 0xFFEF5350);
  });

  test('Test int to hex', () {
    expect(ColorUtils.intToHex(0xFFFFFFFF), "#FFFFFF");
    expect(ColorUtils.intToHex(16777215), "#FFFFFF");
    expect(ColorUtils.intToHex(15684432), "#EF5350");
  });

  test('Test shade hex', () {
    expect(ColorUtils.shadeColor("#6699CC", 20), "#7ab8f5");
    expect(ColorUtils.shadeColor("#69C", -50), "#334d66");
    expect(ColorUtils.shadeColor("#9c27b0", -32.1), "#6a1a78");
  });

  test('Test fill up hex', () {
    expect(ColorUtils.fillUpHex("#69C"), "#6699CC");
    expect(ColorUtils.fillUpHex("69C"), "#6699CC");
  });
}
