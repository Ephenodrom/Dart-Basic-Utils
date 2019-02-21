import 'package:basic_utils/basic_utils.dart';

void main() async {
  print("Convert to lowercase underscore: " +
      StringUtils.camelCaseToLowerUnderscore("camelCase"));
  print("Is lowercase: " + StringUtils.isLowerCase("lowercase").toString());
  print("Is uppercase: " + StringUtils.isUpperCase("UPPERCASE").toString());
  print("Is ascii: " + StringUtils.isAscii("Hello").toString());
  print(
      "Is null or empty: " + StringUtils.isNullOrEmpty("notempty").toString());
}
