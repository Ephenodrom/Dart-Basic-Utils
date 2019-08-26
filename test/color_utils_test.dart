import 'package:basic_utils/src/ColorUtils.dart';
import "package:test/test.dart";

void main() {
  test('Test hex to int', () async {
    expect(ColorUtils.hexToInt("#FFFFFF"), 0xFFFFFFFF);
    expect(ColorUtils.hexToInt("FFFFFF"), 0xFFFFFFFF);
    expect(ColorUtils.hexToInt("#EF5350"), 0xFFEF5350);
  });
}
