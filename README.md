# Basic Utils

A dart package for many helper methods fitting different situations.

## Table of Contents

1. [Preamble](#preamble)
2. [Install](#install)
   * [pubspec.yaml](#pubspec.yaml)
3. [Import](#import)
4. [Util Classes](#util-classes)
   * [StringUtils](#stringutils)
   * [DomainUtils](#domainutils)
   * [EmailUtils](#emailutils)
   * [MathUtils](#mathutils)
   * [HttpUtils](#httputils)
   * [DnsUtils](#dnsutils)
   * [SortUtils](#sortutils)
   * [ColorUtils](#colorutils)
   * [DateUtils](#dateutils)
   * [X509Utils](#x509utils)
   * [IterableUtils](#iterableutils)
   * [CryptoUtils](#cryptoutils)
5. [Changelog](#changelog)
6. [Copyright and license](#copyright-and-license)

## Preamble

This package is also part of the [EZ Flutter Framework](https://ez-flutter.de).

## Install

### pubspec.yaml

Update pubspec.yaml and add the following line to your dependencies.

```yaml
dependencies:
  basic_utils: ^2.5.5
```

## Import

Import the package with :

```dart
import 'package:basic_utils/basic_utils.dart';
```

## Util Classes

The package contains different classes. Each class contains methods that provide a solution for certain problems.

### StringUtils

Helper class for String operations.

```dart
String defaultString(String str, {String defaultStr = ''});
bool isNullOrEmpty(String s);
bool isNotNullOrEmpty(String s);
String camelCaseToUpperUnderscore(String s);
String camelCaseToLowerUnderscore(String s);
bool isLowerCase(String s);
bool isUpperCase(String s);
bool isAscii(String s);
String capitalize(String s);
String reverse(String s);
int countChars(String s, String char, {bool caseSensitive = true});
bool isDigit(String s);
bool equalsIgnoreCase(String a, String b);
bool inList(String s, List<String> list, {bool ignoreCase = false});
bool isPalindrome(String s);
String hidePartial(String s, {int begin = 0, int end, String replace = "*"});
String addCharAtPosition(String s, String char, int position,{bool repeat = false});
List<String> chunk(String s, chunkSize);
```

### DomainUtils

Helper class for operations on domain names.

```dart
bool isDomainName(String s);
bool isSubTld(String tld, String subTld);
bool isSubDomain(String s);
bool isSubDomainOf(String sub, String domain);
bool isCCTLD(String s);
bool isNGTLD(String s);
bool isTld(String s);
bool isGTLD(String s);
List<String> splitDomainName(String domainName);
Domain getDomainFromUrl(String url);
Domain parseDomain(String domainName);
List<String> splitSubdomainInDomains(String name);
```

### EmailUtils

Helper class for operations on email addresses.

```dart
bool isEmail(String s);
EmailAddress parseEmailAddress(String s);
```

### MathUtils

Helper class for simple math operations like calculating circular area or converting length units.

```dart
double calculateCircumference(double radius);
double calculateCircularArea(double radius);
double calculateCircleDiameter(double radius);
double calculateSquareArea(double a, {double b});
double convertUnit(double value, LengthUnits sourceUnit, LengthUnits targetUnit);
double calculateMixingTemperature(double mA, double tA, double mB, double tB,{double cA, double cB});
num mean(List<num> l);
double round(double value, int decimals);
```

### HttpUtils

Helper class for simple http operations like sending requests.

```dart
Future<Map<Response> getForFullResponse(String url, {Map<String, dynamic> queryParameters, Map<String, String> headers});
Future<Map<String, dynamic>> getForJson(String url, {Map<String, dynamic> queryParameters, Map<String, String> headers});
Future<String> getForString(String url, {Map<String, dynamic> queryParameters, Map<String, String> headers});
Future<Map<Response> postForFullResponse(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<Map<String, dynamic>> postForJson(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<String> postForString(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<Response> putForFullResponse(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<Map<String, dynamic>> putForJson(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<String> putForString(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<Response deleteForFullResponse(String url, {Map<String, String> queryParameters, Map<String, String> headers});
Future<Map<String, dynamic>> deleteForJson(String url, {Map<String, String> queryParameters, Map<String, String> headers});
Future<String> deleteForString(String url, {Map<String, String> queryParameters, Map<String, String> headers});
Map<String, dynamic> getQueryParameterFromUrl(String url);
String addQueryParameterToUrl(String url, Map<String, dynamic> queryParameters);
```

### DnsUtils

Helper class for lookup resource records. Uses google dns resolver api.

```dart
Future<List<RRecord>> lookupRecord(String name, RRecordType type,{bool dnssec = false, DnsApiProvider provider = DnsApiProvider.GOOGLE});
RRecordType intToRRecordType(int type);
int rRecordTypeToInt(RRecordType type);
```

### SortUtils

Helper class for sorting lists. Implementation of different sorting algorithms.

```dart
List quickSort(List list);
List bubbleSort(List list);
List heapSort(List list);
```

### ColorUtils

Helper class for color operations.

```dart
int hexToInt(String hex);
String intToHex(int i);
String shadeColor(String hex, int percent);
String fillUpHex(String hex);
bool isDark(String hex);
String contrastColor(String hex);
Map<String, int> basicColorsFromHex(String hex);
double calculateRelativeLuminance(int red, int green, int blue,{int decimals = 2});
List<String> swatchColor(String hex, {double percentage = 15, int amount = 5});
```

### DateUtils

Helper class for date operations like converting textual datetime description.

```dart
DateTime stringToDateTime(String s, {DateTime time});
int getCalendarWeek(DateTime date);
```

### X509Utils

Helper class for operations on x509 certificates, like generating key pairs, generating csr and many more.

```dart
AsymmetricKeyPair generateKeyPair({int keySize = 2048});
String formatKeyString(String key, String begin, String end,{int chunkSize = 64, String lineDelimiter = "\n"});
String generateRsaCsrPem(Map<String, String> attributes,RSAPrivateKey privateKey, RSAPublicKey publicKey);
String encodeASN1ObjectToPem(ASN1Object asn1Object, String begin, String end);
String encodeRSAPublicKeyToPem(RSAPublicKey publicKey);
String encodeRSAPrivateKeyToPem(RSAPrivateKey rsaPrivateKey);
RSAPrivateKey privateKeyFromPem(String pem);
RSAPublicKey publicKeyFromPem(String pem);
Uint8List getBytesFromPEMString(String pem);
RSAPrivateKey privateKeyFromDERBytes(Uint8List bytes);
RSAPrivateKey privateKeyFromASN1Sequence(ASN1Sequence asnSequence);
Uint8List rsaPublicKeyModulusToBytes(RSAPublicKey publicKey);
Uint8List rsaPublicKeyExponentToBytes(RSAPublicKey publicKey);
Uint8List rsaPrivateKeyToBytes(RSAPrivateKey privateKey);
ASN1Object encodeDN(Map<String, String> dn);
X509CertificateData x509CertificateFromPem(String pem);
AsymmetricKeyPair generateEcKeyPair();
String encodeEcPublicKeyToPem(ECPublicKey publicKey);
String encodeEcPrivateKeyToPem(ECPrivateKey ecPrivateKey);
String generateEccCsrPem(Map<String, String> attributes, ECPrivateKey privateKey, ECPublicKey publicKey);
```

### IterableUtils

Helper class for operations on iterables

```dart
T randomItem<T>(Iterable<T> iterable);
bool isNullOrEmpty(Iterable iterable);
bool isNotNullOrEmpty(Iterable iterable);
List<List<T>> chunk<T>(List<T> list, int size);
```

### CryptoUtils

Helper class for cryptographic operations.

```dart
String getSha1ThumbprintFromBytes(Uint8List bytes);
String getSha256ThumbprintFromBytes(Uint8List bytes);
String getMd5ThumbprintFromBytes(Uint8List bytes);
```

## Changelog

For a detailed changelog, see the [CHANGELOG.md](CHANGELOG.md) file

## Copyright and license

MIT License

Copyright (c) 2020 Ephenodrom

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
