import 'package:basic_utils/src/ColorUtils.dart';
import 'package:test/test.dart';

void main() {
  test('Test hex to int', () {
    expect(ColorUtils.hexToInt('#FFFFFF'), 0xFFFFFFFF);
    expect(ColorUtils.hexToInt('FFFFFF'), 0xFFFFFFFF);
    expect(ColorUtils.hexToInt('#EF5350'), 0xFFEF5350);
  });

  test('Test int to hex', () {
    expect(ColorUtils.intToHex(0xFFFFFFFF), '#FFFFFF');
    expect(ColorUtils.intToHex(0xFFEF5350), '#EF5350');
    expect(ColorUtils.intToHex(16777215), '#FFFFFF');
    expect(ColorUtils.intToHex(15684432), '#EF5350');
  });

  test('Test shade hex', () {
    expect(ColorUtils.shadeColor('#6699CC', 20), '#7ab8f5');
    expect(ColorUtils.shadeColor('#69C', -50), '#334d66');
    expect(ColorUtils.shadeColor('#9c27b0', -32.1), '#6a1a78');
  });

  test('Test fill up hex', () {
    expect(ColorUtils.fillUpHex('#69C'), '#6699CC');
    expect(ColorUtils.fillUpHex('69C'), '#6699CC');
  });

  test('Test is dark', () {
    expect(ColorUtils.isDark('#000000'), true);
    expect(ColorUtils.isDark('#FFFFFF'), false);
  });

  test('Test contrast color', () {
    expect(ColorUtils.contrastColor('#000000'), '#FFFFFF');
    expect(ColorUtils.contrastColor('#FFFFFF'), '#000000');
  });

  test('Test basic colors form hex', () {
    var bC = ColorUtils.basicColorsFromHex('#4287f5');

    expect(bC[ColorUtils.BASIC_COLOR_RED], 66);
    expect(bC[ColorUtils.BASIC_COLOR_GREEN], 135);
    expect(bC[ColorUtils.BASIC_COLOR_BLUE], 245);
  });

  test('Test calculate relative luminance', () {
    expect(ColorUtils.calculateRelativeLuminance(255, 0, 0), 0.3);
  });

  test('Test swatch color', () {
    var colors = ColorUtils.swatchColor('#f44336');
    expect(colors.elementAt(0), '#ff755f');
    expect(colors.elementAt(1), '#ff6b56');
    expect(colors.elementAt(2), '#ff614e');
    expect(colors.elementAt(3), '#ff5746');
    expect(colors.elementAt(4), '#ff4d3e');
    expect(colors.elementAt(5), '#f44336');
    expect(colors.elementAt(6), '#cf392e');
    expect(colors.elementAt(7), '#ab2f26');
    expect(colors.elementAt(8), '#86251e');
    expect(colors.elementAt(9), '#621b16');
    expect(colors.elementAt(10), '#3d110e');
  });
  
    test('Test invert color', () {
    expect(ColorUtils.invertColor("#FFFFFF"), "#000000");
    expect(ColorUtils.invertColor("#FF00FF"), "#00ff00");
    expect(ColorUtils.invertColor("000000"), "ffffff");
    expect(ColorUtils.invertColor("#FFA8FF"), "#005700");

  });
}
