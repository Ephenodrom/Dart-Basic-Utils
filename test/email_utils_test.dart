import 'package:basic_utils/basic_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Test isEmail', () {
    expect(EmailUtils.isEmail('plainaddress'), false);
    expect(EmailUtils.isEmail('#@%^%#\$@#\$@#.com'), false);
    expect(EmailUtils.isEmail('@domain.com'), false);
    expect(EmailUtils.isEmail('Joe Smith < email@domain.com >'), false);
    expect(EmailUtils.isEmail('email.domain.com'), false);
    expect(EmailUtils.isEmail('email @domain@domain.com'), false);
    expect(EmailUtils.isEmail('.email @domain.com'), false);
    expect(EmailUtils.isEmail('email.@domain.com'), false);
    expect(EmailUtils.isEmail('email..email@domain.com'), true);
    expect(EmailUtils.isEmail('あいうえお@domain.com'), false);
    expect(EmailUtils.isEmail('email@domain.com(Joe Smith)'), false);
    expect(EmailUtils.isEmail('email @domain'), false);
    expect(EmailUtils.isEmail('email@-domain.com'), true);
    expect(EmailUtils.isEmail('test@foobar.rocks'), true);
    expect(EmailUtils.isEmail('email @domain.web'), false);
    expect(EmailUtils.isEmail('email@111.222.333.44444'), false);
    expect(EmailUtils.isEmail('email @domain..com'), false);
  });

  test('Test parseEmailAddress', () {
    expect(EmailUtils.parseEmailAddress('plainaddress'), null);
    var email = EmailUtils.parseEmailAddress('test@test.de');
    expect(email.local, 'test');
    expect(email.domain.toString(), 'test.de');

    email = EmailUtils.parseEmailAddress('jon.doe@test.de');
    expect(email.local, 'jon.doe');
    expect(email.domain.toString(), 'test.de');
  });
}
