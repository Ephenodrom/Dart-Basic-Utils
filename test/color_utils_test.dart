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
    expect(ColorUtils.intToHex(0xFFEF5350), "#EF5350");
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

  test('Test is dark', () {
    expect(ColorUtils.isDark("#000000"), true);
    expect(ColorUtils.isDark("#FFFFFF"), false);
  });

  test('Test contrast color', () {
    expect(ColorUtils.contrastColor("#000000"), "#FFFFFF");
    expect(ColorUtils.contrastColor("#FFFFFF"), "#000000");
  });

  test('Test basic colors form hex', () {
    Map<String, int> bC = ColorUtils.basicColorsFromHex("#4287f5");

    expect(bC[ColorUtils.BASIC_COLOR_RED], 66);
    expect(bC[ColorUtils.BASIC_COLOR_GREEN], 135);
    expect(bC[ColorUtils.BASIC_COLOR_BLUE], 245);
  });

  test('Test calculate relative luminance', () {
    expect(ColorUtils.calculateRelativeLuminance(255, 0, 0), 0.3);
  });
}
