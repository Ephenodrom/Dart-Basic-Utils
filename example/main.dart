import 'package:basic_utils/basic_utils.dart';

void main() async {
  // StringUtils
  // print('Convert to lowercase underscore: ' +
  //     StringUtils.camelCaseToLowerUnderscore('camelCase'));
  // print('Is lowercase: ' + StringUtils.isLowerCase('lowercase').toString());
  // print('Is uppercase: ' + StringUtils.isUpperCase('UPPERCASE').toString());
  // print('Is ascii: ' + StringUtils.isAscii('Hello').toString());
  // print(
  //     'Is null or empty: ' + StringUtils.isNullOrEmpty('notempty').toString());

  // // DomainUtils
  // print('Is dartlang.org a domain name? ' +
  //     DomainUtils.isDomainName('dartlang.org').toString());
  // var domain = DomainUtils.parseDomain('dartlang.org')!;
  // print('Sld = ' + domain.sld! + ' & tld = ' + domain.tld!);

  // // EmailUtils
  // print('Is hello@world.com an email ? ' +
  //     EmailUtils.isEmail('hello@world.com').toString());

  // // MathUtils
  // print('1 km is ' +
  //     MathUtils.convertUnit(1, LengthUnits.kilometer, LengthUnits.meter)
  //         .toString() +
  //     ' meter.');
  //
  print(StringUtils.removeCharAtPosition('flutterr', 8));
  print(StringUtils.pickOnly('123456789', from: 3, to: 7));

  print(StringUtils.removeExp('Hello This World', 'This'));
  print(StringUtils.truncate('This is a Dart Utility Library', 26));

  print(StringUtils.generateRandomString(15));
  print(MathUtils.getRandomNumber().toString());
}
