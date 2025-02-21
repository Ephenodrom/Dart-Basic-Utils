import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:test/test.dart';

void main() {
  var chain = [
    '''-----BEGIN CERTIFICATE-----
MIICsDCCAZigAwIBAgIEfeYMRDANBgkqhkiG9w0BAQsFADAaMRgwFgYDVQQDEw9i
YXNpYy11dGlscy5kZXYwHhcNMjMwMjExMTgyMDQ0WhcNMjQwMjExMTgyMDQ0WjAa
MRgwFgYDVQQDEw9iYXNpYy11dGlscy5kZXYwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQCsUgwA+OTnRmy9GiUGcBzvq7Zfeh00j5N4eDdag/QvdUK+NWFl
tgLP3QgYkT0SMmjNYc8CtuIq8sFa6+7FC95bjCjb7Q/Go+jR/qhR3ZyOXhfIFHHg
fX9fffzHnlF+JspNi9MQt0soy3ymJ0NvTIbk5StyA2jHwncQmHZkBV7jTnzMAeSJ
HZnF4gbupUenuT0bjMFpTSBrcrEv5wJTcXprg5z1DbN74IrPuxQq9jt0pHf2WoK7
mwbbCqBjReRGRY09vwxxHEoeieR8sSk9zqf/kExCyFdYG8/DYqGEfAVunSAiU3oL
vN1E/x+OWyghDSOuJp9TV6N36EwdpBVMNj4FAgMBAAEwDQYJKoZIhvcNAQELBQAD
ggEBAJypmrcrlCJD7GTnQhPfdcjDwJvc/fhXSiKVRaUJSKaLgKZGvfNLlrJmnzyU
oJGu6IEqaBkyVmEDBTgiUPip3MHf+l0i5LVDQ/x+O+Qflj1h1nDevAtRwPMnFdHG
HFOk4xzmVrjkGPT/yGZ0OB2+LWZFl7i/uSZZqgdUlI0I0vP5v+oK7rT/i1SrNmme
Hfz8YBYrNUNkuJKEIhgoJGmhh6D6s0cbCHAt+6ORCXy/h0doOQkEhQ/IcJihtiYo
8uyXBvKMEu6K1bP59nJ7iQj/nIaFq+VKdF9Hj1NvjKujCY2pRs2tCgVrvvFi/Z2H
QMmfGQCuPBNtoegresOWpQbC8f8=
-----END CERTIFICATE-----''',
  ];

  var privateKey = '''-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCsUgwA+OTnRmy9
GiUGcBzvq7Zfeh00j5N4eDdag/QvdUK+NWFltgLP3QgYkT0SMmjNYc8CtuIq8sFa
6+7FC95bjCjb7Q/Go+jR/qhR3ZyOXhfIFHHgfX9fffzHnlF+JspNi9MQt0soy3ym
J0NvTIbk5StyA2jHwncQmHZkBV7jTnzMAeSJHZnF4gbupUenuT0bjMFpTSBrcrEv
5wJTcXprg5z1DbN74IrPuxQq9jt0pHf2WoK7mwbbCqBjReRGRY09vwxxHEoeieR8
sSk9zqf/kExCyFdYG8/DYqGEfAVunSAiU3oLvN1E/x+OWyghDSOuJp9TV6N36Ewd
pBVMNj4FAgMBAAECggEAaLOBb6XLD2sO7udPz9WW/1kJ+oEr9Z+3Lt98YpcCa0OI
RiIRB8fLdZkLLkIxJTlTzFa9fRy51vag3Sm1biyD8oP634Xuq/czo0Rj6ToJwccS
FBO4DXqzRcY7LN7ZDRlsmil3GRUFqcfZ+OqqYpnQ7IsCFshThex2g7LfXG6W9Oze
Za02pjuhDijXmWIEDG/NStCXSrjxvXhA2ixK3W8y4ZjXktoIVXfe9gzuT1Mr39bM
JjPbdIkNaydzRobIZ8sVjbCW8KMwOTv2kOZeAaeKlivWFXlcmITYcQJaw+QWHENN
S+GSmnGZEGzWaTV3bL0+f3ZrKnoTsPdr7nHRwWzMkQKBgQDteMKWYPRKtVrvG/TT
EM8PdHFeLP6let/lIlfakNpDafOs141cBh9N+Tz+mMoWwQCqHcbHqmjk9R4vhk3H
rzCtZ1rML7b66TzoyKNiEWNrck4mHCO5xWnGU47Lo0gE8a/wEnTGBjRF6Y1Rj5X1
UiXkAXUjK1Aj6mQD+hxQ3gITGwKBgQC5w/Y4GKp1MIGAXmsKHFQxcR4ZlxTfwWx3
OhdqjvdJaddeYt885hsCKv682aB8hvrt1HZndnyeSKQCgRlyNPq2e0rxU3XQOKR+
vr7dDrUQl7WIqNHPeaOaqtO76wivC0eYHPDXsHBexQVlCUNbEJpJVtKXBgZuEn+Y
g55lVq7lXwKBgQCwP92kgOcvf7SzHPuzn5kerlzp+dkx9qWwSbIM3U+xkzSxBva6
4yxe0epsR/hNtQeKOzlqvdbGgArcWQDngOZO/RPN0mgrh+qWFzv0MFWqzJamAGKf
oZ6k/SVRjKmKSds8Ama7BqXLcdFaRIiXIFZRCKfo51++mFuM/BgCCRRfGwKBgDmT
GsTYIDyiBAEdQl+n2BBa1tFnmfifolZxksBb/xipzS5bxoTBbK2HVdyCNtNhonQD
3Y7DkmwcZ3i/OnvDH9Fe9SNGksUuSQ1fYRhybnvuCT2J1T1QnfxZ5bXgapiWDmJ+
1caD0NAOkFV4QX//7VG9rxdPrr5+zT0fzf/qldpRAoGBALwxy/Kj+YjpktEDgr0Z
Oqo6wr/vNJgDmWlvj6HIR7ueHPZdnCoexd259YqBP/rpTWcdPjCzqctNuThv+Oi9
Th6rDWCgxKJ3R/rAeMdNBG7tEuP+qKJQZ+mJbw2I2pmz3skpl437c+S8pWJWD5dL
tvvnyl47ae1QC/VAOpxmCv3n
-----END PRIVATE KEY-----''';

  var privateKeyPkcs12 = '''-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEArFIMAPjk50ZsvRolBnAc76u2X3odNI+TeHg3WoP0L3VCvjVh
ZbYCz90IGJE9EjJozWHPArbiKvLBWuvuxQveW4wo2+0PxqPo0f6oUd2cjl4XyBRx
4H1/X338x55RfibKTYvTELdLKMt8pidDb0yG5OUrcgNox8J3EJh2ZAVe4058zAHk
iR2ZxeIG7qVHp7k9G4zBaU0ga3KxL+cCU3F6a4Oc9Q2ze+CKz7sUKvY7dKR39lqC
u5sG2wqgY0XkRkWNPb8McRxKHonkfLEpPc6n/5BMQshXWBvPw2KhhHwFbp0gIlN6
C7zdRP8fjlsoIQ0jriafU1ejd+hMHaQVTDY+BQIDAQABAoIBAGizgW+lyw9rDu7n
T8/Vlv9ZCfqBK/Wfty7ffGKXAmtDiEYiEQfHy3WZCy5CMSU5U8xWvX0cudb2oN0p
tW4sg/KD+t+F7qv3M6NEY+k6CcHHEhQTuA16s0XGOyze2Q0ZbJopdxkVBanH2fjq
qmKZ0OyLAhbIU4XsdoOy31xulvTs3mWtNqY7oQ4o15liBAxvzUrQl0q48b14QNos
St1vMuGY15LaCFV33vYM7k9TK9/WzCYz23SJDWsnc0aGyGfLFY2wlvCjMDk79pDm
XgGnipYr1hV5XJiE2HECWsPkFhxDTUvhkppxmRBs1mk1d2y9Pn92ayp6E7D3a+5x
0cFszJECgYEA7XjClmD0SrVa7xv00xDPD3RxXiz+pXrf5SJX2pDaQ2nzrNeNXAYf
Tfk8/pjKFsEAqh3Gx6po5PUeL4ZNx68wrWdazC+2+uk86MijYhFja3JOJhwjucVp
xlOOy6NIBPGv8BJ0xgY0RemNUY+V9VIl5AF1IytQI+pkA/ocUN4CExsCgYEAucP2
OBiqdTCBgF5rChxUMXEeGZcU38FsdzoXao73SWnXXmLfPOYbAir+vNmgfIb67dR2
Z3Z8nkikAoEZcjT6tntK8VN10Dikfr6+3Q61EJe1iKjRz3mjmqrTu+sIrwtHmBzw
17BwXsUFZQlDWxCaSVbSlwYGbhJ/mIOeZVau5V8CgYEAsD/dpIDnL3+0sxz7s5+Z
Hq5c6fnZMfalsEmyDN1PsZM0sQb2uuMsXtHqbEf4TbUHijs5ar3WxoAK3FkA54Dm
Tv0TzdJoK4fqlhc79DBVqsyWpgBin6GepP0lUYypiknbPAJmuwaly3HRWkSIlyBW
UQin6OdfvphbjPwYAgkUXxsCgYA5kxrE2CA8ogQBHUJfp9gQWtbRZ5n4n6JWcZLA
W/8Yqc0uW8aEwWyth1XcgjbTYaJ0A92Ow5JsHGd4vzp7wx/RXvUjRpLFLkkNX2EY
cm577gk9idU9UJ38WeW14GqYlg5iftXGg9DQDpBVeEF//+1Rva8XT66+fs09H83/
6pXaUQKBgQC8Mcvyo/mI6ZLRA4K9GTqqOsK/7zSYA5lpb4+hyEe7nhz2XZwqHsXd
ufWKgT/66U1nHT4ws6nLTbk4b/jovU4eqw1goMSid0f6wHjHTQRu7RLj/qiiUGfp
iW8NiNqZs97JKZeN+3PkvKViVg+XS7b758peO2ntUAv1QDqcZgr95w==
-----END RSA PRIVATE KEY-----''';

  var eccPrivateKey = '''-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIBigV8Oa9QGv47zqjqEaPtA6B8BxrzQJsuG56cjITVDHoAoGCCqGSM49
AwEHoUQDQgAE4rDUyLjLFkTvP+6UtHBKMnLdJVTriUQTGcF7dst78x7kYxs8Axx2
c1qH6dtrKflwHo/aqwkbTUsX/FSUNTN3Fg==
-----END EC PRIVATE KEY-----''';

  var eccChain = [
    '''-----BEGIN CERTIFICATE-----
MIIBKDCBzKADAgECAgQKeHsLMAwGCCqGSM49BAMCBQAwGjEYMBYGA1UEAxMPYmFz
aWMtdXRpbHMuZGV2MB4XDTIzMDIxMzE0NTIxNFoXDTI0MDIxMzE0NTIxNFowGjEY
MBYGA1UEAxMPYmFzaWMtdXRpbHMuZGV2MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
QgAE4rDUyLjLFkTvP+6UtHBKMnLdJVTriUQTGcF7dst78x7kYxs8Axx2c1qH6dtr
KflwHo/aqwkbTUsX/FSUNTN3FjAMBggqhkjOPQQDAgUAA0kAMEYCIQDqaN6H1l/7
WlBPbGCAh7ET3AjSJAtkQwZ/Mc9aCZaMJwIhAL1GQfgT50ow4999ja+9ChN4F+tJ
qwLrsstLa4GIYU0x
-----END CERTIFICATE-----'''
  ];

  var openSslWithoutEncryption =
      '''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''';

  var openSslWithOnlyCertEncrypted =
      '''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''';

  var openSslWithDefaultEncryption =
      '''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''';

  var openSslWithOnlyCertEncryptedEcc =
      '''MIIC/wIBAzCCAsUGCSqGSIb3DQEHAaCCArYEggKyMIICrjCCAc8GCSqGSIb3DQEHBqCCAcAwggG8AgEAMIIBtQYJKoZIhvcNAQcBMBwGCiqGSIb3DQEMAQYwDgQIDScs7kfnrqQCAggAgIIBiDtVJCK8kH2kPV415WonCZtOxalLGWvteQmz+KNMTVIP52bp2g8ADt/eGGVKd/LCZKiIp+ZZaLSnu0zVQ7uQ4cfqdiMmbQfyQ02o0o9p2nXEgYV/I3fKf9O4t9QtDiq9LrGXR+v1Xm43cF0LsW5JaCWNht6IEeY0Cbu6sES7cK7CgGg8PXzUcWMuuUIz1OFVYnqxEtHhss8709QUUNB4NvnyEn538FuBe8m0+nHD2+0sKZKAP5w2KvJ6tSwFjc9S4n+w4gnN9soFbSLAlBkuWGAYrE4tfac3w289MdMn8BcwlV0dt+dRJF2HjNlBhEEveCRVPlNxJoFQYlOXuL00WAwnf1KZAfQMihnd7naUnsPkgCQtRFBMZhUw9kxvNq81c2M1aD11Ho3jiXPJVZ3LazFYm/Udisykiej7+PSXnmbKBR+vgy1tgLH+06Mvs8BLsVdt3a/jqFsYKkJOMr+3HTUUpu0SDpPFGsR+LPxZcTUcygGld1IewSf+93UeTb0tEzltCccDXIacMIHYBgkqhkiG9w0BBwGggcoEgccwgcQwgcEGCyqGSIb3DQEMCgEBoIGKMIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgGKBXw5r1Aa/jvOqOoRo+0DoHwHGvNAmy4bnpyMhNUMehRANCAATisNTIuMsWRO8/7pS0cEoyct0lVOuJRBMZwXt2y3vzHuRjGzwDHHZzWofp22sp+XAej9qrCRtNSxf8VJQ1M3cWMSUwIwYJKoZIhvcNAQkVMRYEFDUEA9Hdb1FQ1ovanSIT9bkp0CyfMDEwITAJBgUrDgMCGgUABBSPLJ1kE2sl144nVilaMUhRzxfbpwQIX7j62ToWaH8CAggA''';

  var openSslWithRc4128And2Des =
      '''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''';

  var openSslWithRc2128AndRc440 =
      '''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''';

  var openSslWithPkcs1Privatekey =
      '''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''';

  var pkcs12WithUtf16 =
      '''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''';
  test('Test generatePkcs12() without encryption', () {
    // openssl pkcs12 -export -keypbe NONE -certpbe NONE -passout pass:Beavis -out bundle.pfx -inkey priv.key -in chain.pem
    var localKeyId =
        HexUtils.decode('FC5CD1EF029C6EF8A98AF6D1397F9E88F94AD9EC');
    var salt = HexUtils.decode('96EF372B9AA1FD2D');
    var bytes = Pkcs12Utils.generatePkcs12(
      privateKey,
      chain,
      password: 'Beavis',
      localKeyId: localKeyId,
      salt: salt,
      keyPbe: 'NONE',
      certPbe: 'NONE',
    );
    expect(base64.encode(bytes), openSslWithoutEncryption);
  });

  test('Test formatPkcs12Password()', () {
    var bytes = Pkcs12Utils.formatPkcs12Password(
        Uint8List.fromList('Beavis'.codeUnits));
    expect(bytes, HexUtils.decode('0042006500610076006900730000'));
  });

  test('Test generatePkcs12() with only certs encrypted', () {
    // openssl pkcs12 -export -keypbe NONE -passout pass:Beavis -out bundle.pfx -inkey priv.key -in chain.pem
    var localKeyId =
        HexUtils.decode('FC5CD1EF029C6EF8A98AF6D1397F9E88F94AD9EC');
    var salt = HexUtils.decode('99A6C67AD0E20DE1');
    var certSalt = HexUtils.decode('7BE52B8FBA5E71A0');
    var bytes = Pkcs12Utils.generatePkcs12(
      privateKey,
      chain,
      password: 'Beavis',
      localKeyId: localKeyId,
      salt: salt,
      certSalt: certSalt,
      keyPbe: 'NONE',
    );
    expect(base64.encode(bytes), openSslWithOnlyCertEncrypted);

    localKeyId = HexUtils.decode('350403D1DD6F5150D68BDA9D2213F5B929D02C9F');
    salt = HexUtils.decode('5FB8FAD93A16687F');
    certSalt = HexUtils.decode('0D272CEE47E7AEA4');
    bytes = Pkcs12Utils.generatePkcs12(
      eccPrivateKey,
      eccChain,
      password: 'Beavis',
      localKeyId: localKeyId,
      salt: salt,
      certSalt: certSalt,
      keyPbe: 'NONE',
    );
    expect(base64.encode(bytes), openSslWithOnlyCertEncryptedEcc);
  });

  test('Test generatePkcs12() with default encryption', () {
    // openssl pkcs12 -export -passout pass:Beavis -out bundle.pfx -inkey priv.key -in chain.pem
    var localKeyId =
        HexUtils.decode('FC5CD1EF029C6EF8A98AF6D1397F9E88F94AD9EC');
    var salt = HexUtils.decode('54C56CC722D899E8');
    var certSalt = HexUtils.decode('56AC1C14CA0EB1F4');
    var keySalt = HexUtils.decode('2D6EAAD970050488');
    var bytes = Pkcs12Utils.generatePkcs12(
      privateKey,
      chain,
      password: 'Beavis',
      localKeyId: localKeyId,
      salt: salt,
      certSalt: certSalt,
      keySalt: keySalt,
    );
    expect(base64.encode(bytes), openSslWithDefaultEncryption);
  });

  test('Test generatePkcs12() with default encryption and PKCS1 private key',
      () {
    // openssl pkcs12 -export -passout pass:Beavis -out bundle.pfx -inkey priv.key -in chain.pem
    var localKeyId =
        HexUtils.decode('FC5CD1EF029C6EF8A98AF6D1397F9E88F94AD9EC');
    var salt = HexUtils.decode('0F9B4D771FB232F7');
    var certSalt = HexUtils.decode('BBC984A31DE07F4E');
    var keySalt = HexUtils.decode('804C7F2286FD4C6C');

    var bytes = Pkcs12Utils.generatePkcs12(
      privateKeyPkcs12,
      chain,
      password: 'Beavis',
      localKeyId: localKeyId,
      salt: salt,
      certSalt: certSalt,
      keySalt: keySalt,
    );
    expect(base64.encode(bytes), openSslWithPkcs1Privatekey);
  });

  test('Test generatePkcs12() with default settings', () {
    Pkcs12Utils.generatePkcs12(
      privateKey,
      chain,
      password: 'Beavis',
    );
    //print(base64.encode(bytes));
  });

  test(
      'Test generatePkcs12() with certPbe = PBE-SHA1-2DES and keyPbe = PBE-SHA1-RC4-128',
      () {
    // openssl pkcs12 -export -keypbe PBE-SHA1-RC4-128 -certpbe PBE-SHA1-2DES -passout pass:Beavis -out bundle.pfx -inkey priv.key -in chain.pem
    var localKeyId =
        HexUtils.decode('FC5CD1EF029C6EF8A98AF6D1397F9E88F94AD9EC');
    var salt = HexUtils.decode('F136357C1DB46724');
    var certSalt = HexUtils.decode('268E7F16BA775E30');
    var keySalt = HexUtils.decode('148B161211E7AB98');
    var bytes = Pkcs12Utils.generatePkcs12(
      privateKey,
      chain,
      password: 'Beavis',
      localKeyId: localKeyId,
      salt: salt,
      certSalt: certSalt,
      keySalt: keySalt,
      keyPbe: 'PBE-SHA1-RC4-128',
      certPbe: 'PBE-SHA1-2DES',
    );
    expect(base64.encode(bytes), openSslWithRc4128And2Des);
  });

  test(
      'Test generatePkcs12() with certPbe = PBE-SHA1-RC2-128 and keyPbe = PBE-SHA1-RC4-40',
      () {
    // openssl pkcs12 -export -keypbe PBE-SHA1-RC4-40 -certpbe PBE-SHA1-RC2-128 -passout pass:Beavis -out bundle.pfx -inkey priv.key -in chain.pem
    var localKeyId =
        HexUtils.decode('FC5CD1EF029C6EF8A98AF6D1397F9E88F94AD9EC');
    var salt = HexUtils.decode('F0FAD11BF269B8EC');
    var certSalt = HexUtils.decode('10DE6FFC5AF8A447');
    var keySalt = HexUtils.decode('9BBC5F4673559117');
    var bytes = Pkcs12Utils.generatePkcs12(
      privateKey,
      chain,
      password: 'Beavis',
      localKeyId: localKeyId,
      salt: salt,
      certSalt: certSalt,
      keySalt: keySalt,
      keyPbe: 'PBE-SHA1-RC4-40',
      certPbe: 'PBE-SHA1-RC2-128',
    );
    expect(base64.encode(bytes), openSslWithRc2128AndRc440);
  });

  test(
      'Test parsePkcs12() with certPbe = PBE-SHA1-RC2-128 and keyPbe = PBE-SHA1-RC4-40',
      () {
    var bytes = base64.decode(openSslWithRc2128AndRc440);
    var pems = Pkcs12Utils.parsePkcs12(
      bytes,
      password: 'Beavis',
    );
    expect(pems.length, 2);
    expect(pems.elementAt(0), privateKey);
    expect(pems.elementAt(1), chain.elementAt(0));
  });

  test(
      'Test parsePkcs12() with certPbe = PBE-SHA1-2DES and keyPbe = PBE-SHA1-RC4-128',
      () {
    var bytes = base64.decode(openSslWithRc4128And2Des);
    var pems = Pkcs12Utils.parsePkcs12(
      bytes,
      password: 'Beavis',
    );
    expect(pems.length, 2);
    expect(pems.elementAt(0), privateKey);
    expect(pems.elementAt(1), chain.elementAt(0));
  });

  test('Test parsePkcs12() with default encryption', () {
    var bytes = base64.decode(openSslWithDefaultEncryption);
    var pems = Pkcs12Utils.parsePkcs12(
      bytes,
      password: 'Beavis',
    );
    expect(pems.length, 2);
    expect(pems.elementAt(0), privateKey);
    expect(pems.elementAt(1), chain.elementAt(0));
  });

  test('Test parsePkcs12() with default encryption and PKCS1 private key', () {
    var bytes = base64.decode(openSslWithPkcs1Privatekey);
    var pems = Pkcs12Utils.parsePkcs12(
      bytes,
      password: 'Beavis',
    );
    expect(pems.length, 2);
    expect(pems.elementAt(0), privateKey);
    expect(pems.elementAt(1), chain.elementAt(0));
  });

  test('Test parsePkcs12() without encryption', () {
    var bytes = base64.decode(openSslWithoutEncryption);
    var pems = Pkcs12Utils.parsePkcs12(
      bytes,
    );
    expect(pems.length, 2);
    expect(pems.elementAt(0), privateKey);
    expect(pems.elementAt(1), chain.elementAt(0));
  });

  test('formatPkcs12Password adds null terminator for non-empty password', () {
    final password = Uint8List.fromList('password'.codeUnits);
    final formatted = Pkcs12Utils.formatPkcs12Password(password);

    expect(formatted.length, equals((password.length + 1) * 2));
    expect(formatted.sublist(formatted.length - 2), equals([0x00, 0x00]));
  });

  test('formatPkcs12Password returns [0x00, 0x00] for empty password', () {
    final password = Uint8List(0);
    final formatted = Pkcs12Utils.formatPkcs12Password(password);

    expect(formatted, equals(Uint8List.fromList([0x00, 0x00])));
  });

  test('Test parsePkcs12() with utf-16 friendlyname', () {
    var bytes = base64.decode(pkcs12WithUtf16);
    var pems = Pkcs12Utils.parsePkcs12(bytes, password: "Beavis");
    expect(pems.length, 2);
    expect(pems.elementAt(0), privateKey);
    expect(pems.elementAt(1), chain.elementAt(0));
  });
}
