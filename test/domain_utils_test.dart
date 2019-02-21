import 'package:common_utils/common_utils.dart';
import 'package:common_utils/src/model/Domain.dart';
import "package:test/test.dart";

void main() {
  test('Test splitDomainName', () {
    expect(DomainUtils.splitDomainName("example.com"), ["example", "com"]);
    expect(DomainUtils.splitDomainName("subdomain.example.com"),
        ["subdomain", "example", "com"]);
  });

  test('Test parseDomain', () {
    Domain domain = DomainUtils.parseDomain("example.com");
    expect(domain.toString(), "example.com");
    expect(domain.sld, "example");
    expect(domain.tld, "com");
    expect(domain.subTld, null);

    domain = DomainUtils.parseDomain("example.co.uk");
    expect(domain.sld, "example");
    expect(domain.tld, "uk");
    expect(domain.subTld, "co");

    domain = DomainUtils.parseDomain("subdomain.example.co.uk");
    expect(domain.sld, "example");
    expect(domain.tld, "uk");
    expect(domain.subTld, "co");

    domain = DomainUtils.parseDomain("example");
    expect(domain, null);

    domain = DomainUtils.parseDomain("star.bd");
    expect(domain.sld, "star");
    expect(domain.subTld, null);
    expect(domain.tld, "bd");

    domain = DomainUtils.parseDomain("whatever.fantasy.example.com");
    expect(domain.toString(), "example.com");
    expect(domain.sld, "example");
    expect(domain.subTld, null);
    expect(domain.tld, "com");

    domain = DomainUtils.parseDomain("公司.cn");
    expect(domain.toString(), "公司.cn");
    expect(domain.sld, "公司");
    expect(domain.subTld, null);
    expect(domain.tld, "cn");

    domain = DomainUtils.parseDomain("test.我爱你");
    expect(domain.toString(), "test.我爱你");
    expect(domain.sld, "test");
    expect(domain.subTld, null);
    expect(domain.tld, "我爱你");

    domain = DomainUtils.parseDomain("xn--6qq986b3xl.com");
    expect(domain.toString(), "xn--6qq986b3xl.com");
    expect(domain.sld, "xn--6qq986b3xl");
    expect(domain.subTld, null);
    expect(domain.tld, "com");

    domain = DomainUtils.parseDomain("test.xn--6qq986b3xl");
    expect(domain.toString(), "test.xn--6qq986b3xl");
    expect(domain.sld, "test");
    expect(domain.subTld, null);
    expect(domain.tld, "xn--6qq986b3xl");

    domain = DomainUtils.parseDomain("test.москва");
    expect(domain.toString(), "test.москва");
    expect(domain.sld, "test");
    expect(domain.subTld, null);
    expect(domain.tld, "москва");

    domain = DomainUtils.parseDomain("www.example.com");
    expect(domain.toString(), "example.com");
    expect(domain.sld, "example");
    expect(domain.subTld, null);
    expect(domain.tld, "com");
  });
}
