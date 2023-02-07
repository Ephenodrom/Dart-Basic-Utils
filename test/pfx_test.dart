import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/algorithm_identifier.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/attribute.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/authenticated_safe.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/cert_bag.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/content_info.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/digest_info.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/key_bag.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/mac_data.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/pfx.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/pkcs12_helper_utils.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/private_key_info.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/safe_bag.dart';
import 'package:basic_utils/src/model/asn1/asn1/pkcs/safe_contents.dart';
import 'package:pointycastle/export.dart';
import 'package:test/test.dart';

void main() {
  // 1.2.840.113549.1.7.1 data (PKCS #7)
  // 1.2.840.113549.1.12.10.1.3 pkcs-12-certBag
  // 1.2.840.113549.1.9.22.1 x509Certificate
  // 1.2.840.113549.1.9.22.2 (sdsiCertificate)

// 1.2.840.113549.1.12.10.1.1 (keyBag)
// 1.2.840.113549.1.12.10.1.2 (pkcs-8ShroudedKeyBag)
// 1.2.840.113549.1.12.10.1.3 (certBag)
// 1.2.840.113549.1.12.10.1.4 (crlBag)
// 1.2.840.113549.1.12.10.1.5 (secretBag)
// 1.2.840.113549.1.12.10.1.6 (safeContentsBag)

/*
PFX
|
|-> version
|
|-> AuthenticatedSafe
|   |
|   |-> ContentInfo
|   |   |
|   |   |-> SafeContents
|   |       |
|   |       | -> SafeBag
|   |       |    |
|   |       |    |-> CertBag.fromPem(pem)
|   |       |
|   |       | -> SafeBag
|   |       |    |
|   |       |    |-> CertBag.fromPem(pem)
|   |       |
|   |       | -> SafeBag
|   |            |
|   |            |-> CertBag.fromPem(pem)
|   |-> ContentInfo
|       |
|       |-> SafeContents
|           |
|           | -> SafeBag
|                |
|                |-> KeyBag.fromPem(pem)
|
|-> MacData
|   |
|   |-> DigestInfo
|   |
|   |-> ASN1OctetString
|   |
|   |-> ASN1Integer
*/

  var chain = [
    '''-----BEGIN CERTIFICATE-----
MIIFRDCCBCygAwIBAgIQCXqT0TUw7HnYVsRwFL5KKDANBgkqhkiG9w0BAQsFADBq
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSkwJwYDVQQDEyBEaWdpQ2VydCBBc3N1cmVkIElEIENs
aWVudCBDQSBHMjAeFw0yMzAxMTcwMDAwMDBaFw0yNDAxMTcyMzU5NTlaMFwxKTAn
BgNVBAMMIGRhbmllbC5saW5zZW5tZWllckBpbnRlcm5ldHguY29tMS8wLQYJKoZI
hvcNAQkBFiBkYW5pZWwubGluc2VubWVpZXJAaW50ZXJuZXR4LmNvbTCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBAIc5bviiZNCXhrX6CVOwZSf9wNSGFewD
AEhYT9HmyL458uaLgIDS9kgbNvvjgmEAKkI83CIskj9ckp6wdQTnhu9DBpYrkuA6
rOiV2xBOwcqxL4YR0EzDmz4vqR+XDZM43YsryP5hVRqHxcGz3wHUFOEb25t3WNo/
Fj1ZikljJ+d6imi9CjvB8JXO9zyzIY4tTs8xRhTrUzzWdjN2st9CL1WePE1ha3Ud
HsNB+4ivxlnxYcjzzyH3IwsGIZATCM2FIV/3tEkalpC2anAUvT4nD4oEFj4WRc2J
g8srLFV/M8CvipVfgE+5b8luDPzlN1AKa7/DQDvhr1WCsqiH2AbkVq8CAwEAAaOC
AfIwggHuMB8GA1UdIwQYMBaAFKViIFDcu1tXl60jjzXiVGypfvlOMB0GA1UdDgQW
BBQqhs7dVN9hxso0LhZ/FvSL476tqzArBgNVHREEJDAigSBkYW5pZWwubGluc2Vu
bWVpZXJAaW50ZXJuZXR4LmNvbTAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYI
KwYBBQUHAwQGCCsGAQUFBwMCMEMGA1UdIAQ8MDowOAYKYIZIAYb9bAQBATAqMCgG
CCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMIGLBgNVHR8E
gYMwgYAwPqA8oDqGOGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
c3VyZWRJRENsaWVudENBRzIuY3JsMD6gPKA6hjhodHRwOi8vY3JsNC5kaWdpY2Vy
dC5jb20vRGlnaUNlcnRBc3N1cmVkSURDbGllbnRDQUcyLmNybDB9BggrBgEFBQcB
AQRxMG8wJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBHBggr
BgEFBQcwAoY7aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNz
dXJlZElEQ2xpZW50Q0FHMi5jcnQwDQYJKoZIhvcNAQELBQADggEBAGdQybdHtF+c
zoBHOgbShIErN1fbtaD60W6F4syUH/fvAkXIijfTH1ulWwmxAcOSmk8jz+Lw7isb
LVKoJhMRCEHK45WBmy4/WuIGrq/VVLvbDMCg5NzuxdUCu7LHohmjXL1e1OQVijVh
8mrTE0mOtiRBGNHEEFQI+x3hkN8jQSGAoYZj96/SeUYt9GPRFpNfWhF8Z3mz3Z3P
0pVN84jKs09M36mw1LxGu8WuvngcbvAQS0RAfsSjky0kHAUIGib0xDOz4tdakISH
8T7IuGQFIHQSNfGOshW7Z3BLCeKM4aXMXK3CzJr7q6IUwy/S07q2gLaZ96sjKSCd
w0xgjVx9nC8=
-----END CERTIFICATE-----''',
  ];

  var privateKey = '''-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAhzlu+KJk0JeGtfoJU7BlJ/3A1IYV7AMASFhP0ebIvjny5ouA
gNL2SBs2++OCYQAqQjzcIiySP1ySnrB1BOeG70MGliuS4Dqs6JXbEE7ByrEvhhHQ
TMObPi+pH5cNkzjdiyvI/mFVGofFwbPfAdQU4Rvbm3dY2j8WPVmKSWMn53qKaL0K
O8Hwlc73PLMhji1OzzFGFOtTPNZ2M3ay30IvVZ48TWFrdR0ew0H7iK/GWfFhyPPP
IfcjCwYhkBMIzYUhX/e0SRqWkLZqcBS9PicPigQWPhZFzYmDyyssVX8zwK+KlV+A
T7lvyW4M/OU3UAprv8NAO+GvVYKyqIfYBuRWrwIDAQABAoIBABWOwnJA8XGPtpos
UnBVHstRWPyIo9YMZG8kJRWBhV9OPbsjYkknWLwGGq3th0uPiy0kJrQMBwSy7Wz/
FKjDgG+Eb/hg2fmFYStzOIlRBPQba0gkbuDODmHLl1rB6hgeaLNXN6PWQIsKOiy3
UEYqWWnJ1yjhzfh9Nj5xl+o7NJFia5kHGRBkcY68Cwli1+ij21rNwNknBfrzWpBR
8hKMstuwker/dSePgawnC/6BFJ3kM3Gell9K0cUirNII2SJbeD1NFacgLfhUz+Ks
1rUfX05NQtOUnuQ+8wQrUVQmXGfOWFJlA29BpbUMP5nA1yi5NhDR2c5wr7ZLbf3S
g8GFeYECgYEA3RRNvklE7Cqjm8zrPOkZM9PV3Ukue9QuA9YmLZ9+y3YyU3UoD48D
20lciEwWYtFs2Wwo4b0oAGXqivITRcLHyIo8atr3aggInyztjs/OKT8+Zxjfz03P
vfwOLRq34kUkyxA1uZf1U0j7zQnf6lXqQXNUagyuaR+WguKr9UGxAKsCgYEAnJVy
Ybe+cIr7rmpYIYVtZFNXmHSDO7jL/KnY5AMHFHnMzR5dbDFBaslEH5jMq00apmgc
qsyrbxfdmT78vnR6DJCaSIsBVX093Lhzymniybr6lNu4Kp5bgYSqx5LMZrKORfh8
vsXBPtZBIZ2LvzeqlXiKBNRh+M7vnCPvcvDh6g0CgYAyKIoe8xatElt+XLa+YhBy
vswV4aWnOJOcETkmPrqQxOdUIg+NwB/a38Ebt0+Y6fTtO2nnFXh+5qCZF6UhvbiA
GkTs5XMe3mW+X34iWalnmE67K1yT9w58BzTcLOStdIyNeccGraBeXf+rHGNuEkIM
yXLMgMYNWbpXRcBH67iR8wKBgHcqdUZQ5CoaW7g9Tp0UQlBb7QolgcpttTCwwlOk
yjqXB3oDZe30/mgajDHPw9OKdoG2Mjr6UG3Xp9n8ybTYSBpP4lrbD0TUb8QOzHB7
bRFBr3qiTOKCafmD0cTYv55YvVYa6jT1o0ADJsZCdBwubTAb8E4EpBsKwef+oTjE
genxAoGAFwiUcU9lFgTolNMchYr0VsWBTQz3wwuerO85DnrlmE833h1CGfnvOa62
AaWPUv9z4MVuvZVg04RCYSIixYV4dQERVkEBUSYk/b6IC2VHQ9XAtdYwe3kxVvdr
QAInWSzEvOvADto0J6pR0T/uaPc6Fywt4pHZ13rOYZQHhsCiP/4=
-----END RSA PRIVATE KEY-----''';

  var openSslWithoutEncryptionAndMac =
      '''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''';

  Uint8List _generateLocalKeyId() {
    return Uint8List.fromList([
      0x4B,
      0x0B,
      0xD0,
      0x94,
      0x92,
      0xDD,
      0x36,
      0xFA,
      0xB7,
      0xEA,
      0xD0,
      0xD9,
      0x82,
      0x10,
      0x68,
      0xB9,
      0xC2,
      0xA6,
      0x0F,
      0x1E
    ]);
  }
/*
  Uint8List derivateKey(Uint8List key, Uint8List salt, int iter) {
    var params = Pbkdf2Parameters(
      salt,
      iter,
      20,
    );

    var derivator = KeyDerivator('SHA-1/HMAC/PBKDF2');
    derivator.init(params);
    var k = derivator.process(key);
    return k;
  }
  */

  Uint8List generateHmac(Uint8List bytesForHmac, Uint8List key) {
    final hmac = Mac('SHA-1/HMAC')..init(KeyParameter(key));
    var m = hmac.process(bytesForHmac);
    return m;
  }

  String generatePkcs12(
      String privateKey, List<String> certificates, String password) {
    var certBags = <CertBag>[];

    // GENERATE LOCAL KEY ID
    var localKeyId = _generateLocalKeyId();

    // CREATE SAFEBAGS WITH PEMS WRAPPED IN CERTBAG
    for (var pem in certificates) {
      certBags.add(CertBag.fromX509Pem(pem));
    }

    var safeBags = <SafeBag>[];

    for (var certBag in certBags) {
      var attribute = Attribute.localKeyID(localKeyId);
      safeBags.add(
        SafeBag.forCertBag(
          certBag,
          bagAttributes: ASN1Set(elements: [attribute]),
        ),
      );
    }

    var safeContentsCert = SafeContents(safeBags);
    var contentInfoCert =
        ContentInfo.forData(ASN1OctetString(octets: safeContentsCert.encode()));

    // CREATE SAFEBAG FOR PRIVATEKEY WRAPPED IN KEYBAG
    var safeBagsKey = <SafeBag>[];
    var attribute = Attribute.localKeyID(localKeyId);
    safeBagsKey.add(
      SafeBag.forKeyBag(
        KeyBag(PrivateKeyInfo.fromPkcs1RsaPem(privateKey)),
        bagAttributes: ASN1Set(elements: [attribute]),
      ),
    );

    var safeContentsKey = SafeContents(safeBagsKey);
    var contentInfoKey =
        ContentInfo.forData(ASN1OctetString(octets: safeContentsKey.encode()));

    // CREATE AUTHENTICATED SAFE WITH CONTENTINFO ( CERT AND KEY )
    var authSafe = AuthenticatedSafe([contentInfoCert, contentInfoKey]);

    // WRAP AUTHENTICATED SAFE WITHIN A CONTENTINFO
    var T = ContentInfo.forData(ASN1OctetString(octets: authSafe.encode()));

    // GENERATE HMAC
    var bytesForHmac = authSafe.encode();
    var salt =
        Uint8List.fromList([0x5B, 0x87, 0xB5, 0xD7, 0x6D, 0xB2, 0x4D, 0x67]);
    var iter = 2048;
    var key = Pkcs12HelperUtils.generateDerivedKey(
      1,
      20,
      salt,
      Pkcs12HelperUtils.formatPkcs12Password(password),
      Digest('SHA-1'),
      iter,
    );
    var m = generateHmac(bytesForHmac, key);
    var sb = StringBuffer();
    for (var o in m) {
      var s = o.toRadixString(16).toUpperCase();
      if (s.length == 1) {
        s = '0$s';
      }
      sb.write(s);
    }
    print(sb.toString());
    print('5C93D173DCED32E313614CE1F6F886A8AB6428B8');
    //var macData = MacData();
    var macData = MacData(
      DigestInfo(
        m,
        AlgorithmIdentifier.fromIdentifier('1.3.14.3.2.26'),
      ),
      salt,
      BigInt.from(2048),
    );
    var pfx = Pfx(
      ASN1Integer(BigInt.from(3)),
      T,
    );
    var bytes = pfx.encode();
    var b64 = base64.encode(bytes);
    return b64;
  }

  test('Test pfx', () {
    expect(generatePkcs12(privateKey, chain, 'Beavis'),
        openSslWithoutEncryptionAndMac);
  });

  test('generate hmac', () {
    var key = Uint8List.fromList('secret-key-here'.codeUnits);
    var bytesForHmac = Uint8List.fromList('value-to-digest'.codeUnits);
    var bytes = generateHmac(bytesForHmac, key);
    var b64 = base64.encode(bytes);
    expect(b64, 'Wv2WUsbJrOLCZTMsondW2/itgwM=');
  });

  test('deriveKey', () {
    var salt =
        Uint8List.fromList([0x5B, 0x87, 0xB5, 0xD7, 0x6D, 0xB2, 0x4D, 0x67]);
    var bytes = Pkcs12HelperUtils.generateDerivedKey(
        1,
        20,
        salt,
        Pkcs12HelperUtils.formatPkcs12Password('Beavis'),
        Digest('SHA-1'),
        2048);
    var sb = StringBuffer();
    for (var o in bytes) {
      var s = o.toRadixString(16).toUpperCase();
      if (s.length == 1) {
        s = '0$s';
      }
      sb.write(s);
    }
    expect(sb.toString(), 'DF7F99DF4B4B689C65E29840DFCAEE19DF379ED3');
  });

  test('formatPkcs12Password', () {
    var bytes = Pkcs12HelperUtils.formatPkcs12Password('Beavis');
    expect(
        bytes,
        Uint8List.fromList([
          0x00,
          0x42,
          0x00,
          0x65,
          0x00,
          0x61,
          0x00,
          0x76,
          0x00,
          0x69,
          0x00,
          0x73,
          0x00,
          0x00
        ]));
  });
}
