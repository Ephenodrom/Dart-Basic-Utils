import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/pkcs12_utils.dart';
import 'package:test/test.dart';

void main() {
  // 1.2.840.113549.1.7.1 data (PKCS #7)
  // 1.2.840.113549.1.7.6 encryptedData (PKCS #7)
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

  var openSslWithoutEncryption =
      '''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''';

  var openSslWithOnlyCertEncrypted =
      '''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''';

  test('Test generatePkcs12() without encryption', () {
    // openssl pkcs12 -export -keypbe NONE -certPbe NONE -passout pass:Beavis -out bundle.pfx -inkey priv.key -in chain.pem
    var localKeyId =
        StringUtils.hexToUint8List('FC5CD1EF029C6EF8A98AF6D1397F9E88F94AD9EC');
    var salt = StringUtils.hexToUint8List('96EF372B9AA1FD2D');
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

  test('formatPkcs12Password', () {
    var bytes = Pkcs12Utils.formatPkcs12Password(
        Uint8List.fromList('Beavis'.codeUnits));
    expect(bytes, StringUtils.hexToUint8List('0042006500610076006900730000'));
  });

  test('Test generatePkcs12() without only certs encrypted', () {
    // openssl pkcs12 -export -keypbe NONE  -passout pass:Beavis -out bundle.pfx -inkey priv.key -in chain.pem
    var localKeyId =
        StringUtils.hexToUint8List('FC5CD1EF029C6EF8A98AF6D1397F9E88F94AD9EC');
    var salt = StringUtils.hexToUint8List('99A6C67AD0E20DE1');
    var certSalt = StringUtils.hexToUint8List('7BE52B8FBA5E71A0');
    var bytes = Pkcs12Utils.generatePkcs12(
      privateKey,
      chain,
      password: 'Beavis',
      localKeyId: localKeyId,
      salt: salt,
      certSalt: certSalt,
    );
    expect(base64.encode(bytes), openSslWithOnlyCertEncrypted);
  });
}
