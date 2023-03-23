# Basic Utils

[![pub package](https://img.shields.io/pub/v/basic_utils.svg?logo=dart&logoColor=00b9fc)](https://pub.dev/packages/basic_utils)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![License](https://img.shields.io/github/license/ephenodrom/Dart-Basic-Utils?logo=open-source-initiative&logoColor=green)](https://github.com/Ephenodrom/Dart-Basic-Utils/blob/master/LICENSE)

A dart package for many helper methods fitting different situations.

## Table of Contents

- [Basic Utils](#basic-utils)
  - [Table of Contents](#table-of-contents)
  - [Preamble](#preamble)
  - [Install](#install)
    - [pubspec.yaml](#pubspecyaml)
  - [Import](#import)
  - [Util Classes](#util-classes)
    - [StringUtils](#stringutils)
    - [DomainUtils](#domainutils)
    - [EmailUtils](#emailutils)
    - [MathUtils](#mathutils)
    - [HttpUtils](#httputils)
    - [DnsUtils](#dnsutils)
    - [SortUtils](#sortutils)
    - [ColorUtils](#colorutils)
    - [DateUtils](#dateutils)
    - [X509Utils](#x509utils)
    - [PKCS12Utils](#pkcs12utils)
    - [IterableUtils](#iterableutils)
    - [CryptoUtils](#cryptoutils)
    - [ASN1Utils](#asn1utils)
    - [HexUtils](#hexutils)
    - [EnumUtils](#enumutils)
    - [BooleanUtils](#booleanutils)
    - [FunctionDefs](#functiondefs)
  - [Changelog](#changelog)
  - [Real Live Examples](#real-live-examples)
    - [SSL Toolkit](#ssl-toolkit)
  - [Copyright and license](#copyright-and-license)

## Preamble

As this package is written in pure [Dart](https://dart.dev), it can be used on all [platforms](https://dart.dev/platforms) on which dart is currently running. This includes the use of frameworks like [Flutter](https://flutter.dev), [Angular Dart](https://angulardart.dev) and many more. This package can also be used for command line tools or rest services compiled with [dart2native](https://dart.dev/tools/dart2native).

**Note:** Feel free to contribute by creating pull requests or file an issue for bugs, questions and feature requests.

## Install

### pubspec.yaml

Update pubspec.yaml and add the following line to your dependencies.

```yaml
dependencies:
  basic_utils: ^5.5.3
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
String defaultString(String? str, {String defaultStr = ''});
bool isNullOrEmpty(String? s);
bool isNotNullOrEmpty(String? s);
String camelCaseToUpperUnderscore(String s);
String camelCaseToLowerUnderscore(String s);
bool isLowerCase(String s);
bool isUpperCase(String s);
bool isAscii(String s);
String capitalize(String s, {bool allWords = false});
String reverse(String s);
int countChars(String s, String char, {bool caseSensitive = true});
bool isDigit(String s);
bool equalsIgnoreCase(String a, String b);
bool inList(String s, List<String> list, {bool ignoreCase = false});
bool isPalindrome(String s);
String hidePartial(String s, {int begin = 0, int end, String replace = "*"});
String addCharAtPosition(String s, String char, int position,{bool repeat = false});
List<String> chunk(String s, chunkSize);
String pickOnly(value, {int from = 1, int to = -1});
String removeCharAtPosition(String value, int index);
String removeExp(String value, String pattern,{bool repeat = true,bool caseSensitive = true,bool multiLine = false,bool dotAll = false,bool unicode = false});
String truncate(String value, int length, {String symbol = '...'}); 
String generateRandomString(int length,{alphabet = true,numeric = true,special = true,uppercase = true,lowercase = true,String from = ''});
String toPascalCase(String s);
List<String> generateRandomStrings(int amount,int length,{alphabet = true,numeric = true,special = true,uppercase = true,lowercase = true,String from = ''});
```

### DomainUtils

Helper class for operations on domain names.

```dart
bool isDomainName(String s);
bool isSubTld(String tld, String? subTld);
bool isSubDomain(String? s);
bool isSubDomainOf(String sub, String domain);
bool isCCTLD(String s);
bool isNGTLD(String s);
bool isTld(String s);
bool isGTLD(String s);
List<String> splitDomainName(String domainName);
Domain? getDomainFromUrl(String url);
Domain? parseDomain(String domainName);
List<String> splitSubdomainInDomains(String name);
String toIDN(String domain);
String fromIDN(String domain)
```

### EmailUtils

Helper class for operations on email addresses.

```dart
bool isEmail(String s);
EmailAddress? parseEmailAddress(String s);
```

### MathUtils

Helper class for simple math operations like calculating circular area or converting length units.

```dart
double calculateCircumference(double radius);
double calculateCircularArea(double radius);
double calculateCircleDiameter(double radius);
double calculateSquareArea(double a, {double? b});
double convertUnit(double value, LengthUnits sourceUnit, LengthUnits targetUnit);
double calculateMixingTemperature(double mA, double tA, double mB, double tB,{double? cA, double? cB});
num mean(List<num> l);
double round(double value, int decimals);
int getRandomNumber({int min = 0, int max = 999999999999});
num median(List<num> sorted);
double logBase(num x, num base);
double log2(num x);
double log10(num x);
```

### HttpUtils

Helper class for simple http operations like sending requests.

```dart
Future<Map<Response> getForFullResponse(String url, {Map<String, dynamic>? queryParameters, Map<String, String>? headers});
Future<Map<String, dynamic>> getForJson(String url, {Map<String, dynamic>? queryParameters, Map<String, String>? headers});
Future<String> getForString(String url, {Map<String, dynamic>? queryParameters, Map<String, String>? headers});
Future<Map<Response> postForFullResponse(String url, {String? body, Map<String, String>? queryParameters, Map<String, String>? headers});
Future<Map<String, dynamic>> postForJson(String url, {String? body, Map<String, String>? queryParameters, Map<String, String>? headers});
Future<String> postForString(String url, {String? body, Map<String, String>? queryParameters, Map<String, String>? headers});
Future<Response> putForFullResponse(String url, {String? body, Map<String, String>? queryParameters, Map<String, String>? headers});
Future<Map<String, dynamic>> putForJson(String url, {String? body, Map<String, String>? queryParameters, Map<String, String>? headers});
Future<String> putForString(String url, {String? body, Map<String, String>? queryParameters, Map<String, String>? headers});
Future<Response deleteForFullResponse(String url, {Map<String, String>? queryParameters, Map<String, String>? headers});
Future<Map<String, dynamic>> deleteForJson(String url, {Map<String, String>? queryParameters, Map<String, String>? headers});
Future<String> deleteForString(String url, {Map<String, String>? queryParameters, Map<String, String>? headers});
Map<String, dynamic>? getQueryParameterFromUrl(String url);
String addQueryParameterToUrl(String url, Map<String, dynamic>? queryParameters);
```

### DnsUtils

Helper class for lookup resource records. Uses google dns resolver api.

```dart
Future<List<RRecord>?> lookupRecord(String name, RRecordType type,{bool dnssec = false, DnsApiProvider provider = DnsApiProvider.GOOGLE});
RRecordType intToRRecordType(int type);
int rRecordTypeToInt(RRecordType type);
Future<List<RRecord>?> reverseDns(String ip,{DnsApiProvider provider = DnsApiProvider.GOOGLE});
String? getReverseAddr(String ip);
String toBind(RRecord record);
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
String invertColor(String color);
```

### DateUtils

Helper class for date operations like converting textual datetime description.

```dart
DateTime stringToDateTime(String s, {DateTime time});
int getCalendarWeek(DateTime date);
```

### X509Utils

Helper class for operations on x509 certificates, like generating csr and many more.

```dart
String formatKeyString(String key, String begin, String end,{int chunkSize = 64, String lineDelimiter = "\n"});
String generateRsaCsrPem(Map<String, String> attributes, RSAPrivateKey privateKey, RSAPublicKey publicKey, {List<String>? san, String signingAlgorithm = 'SHA-256'});
String generateEccCsrPem(Map<String, String> attributes, ECPrivateKey privateKey, ECPublicKey publicKey, {List<String>? san, String signingAlgorithm = 'SHA-256'});
String encodeASN1ObjectToPem(ASN1Object asn1Object, String begin, String end, {String newLine = '\n'});
RSAPrivateKey privateKeyFromASN1Sequence(ASN1Sequence asnSequence);
ASN1Object encodeDN(Map<String, String> dn);
X509CertificateData x509CertificateFromPem(String pem);
Pkcs7CertificateData pkcs7fromPem(String pem);
CertificateSigningRequestData csrFromPem(String pem);
ASN1Sequence buildOCSPRequest(String pem, {String? intermediate});
String getOCSPUrl(String pem);
OCSPResponse parseOCSPResponse(Uint8List bytes);
BigInt getModulusFromRSACsrPem(String pem);
BigInt getModulusFromRSAX509Pem(String pem);
String pemToPkcs7(List<String> pems);
String generateSelfSignedCertificate(PrivateKey privateKey, String csr,int days, { List<String>? sans, List<ExtendedKeyUsage>? extKeyUsage, String serialNumber = '1'});
List<String> parseChainStringAsString(String s);
List<X509CertificateData> parseChainString(String chain);
CertificateRevokeListeData crlDataFromPem(String pem);
String crlDerToPem(Uint8List bytes);
bool checkCsrSignature(String pem);
bool checkX509Signature(String pem, {String? parent});
String fixPem(String pem);
CertificateChainCheckData checkChain(List<X509CertificateData> x509);
```

### PKCS12Utils

Helper class for operations on PKCS12 files.

```dart
Uint8List generatePkcs12(String privateKey, List<String> certificates, {String? password, String keyPbe = 'PBE-SHA1-3DES', String certPbe = 'PBE-SHA1-RC2-40', String digestAlgorithm = 'SHA-1', int macIter = 2048, Uint8List? salt, Uint8List? certSalt, Uint8List? keySalt, String? friendlyName, Uint8List? localKeyId});
```

### IterableUtils

Helper class for operations on iterables

```dart
T randomItem<T>(Iterable<T> iterable);
bool isNullOrEmpty(Iterable? iterable);
bool isNotNullOrEmpty(Iterable? iterable);
List<List<T>> chunk<T>(List<T> list, int size);
swap(List<dynamic> input, int a, int b);
List<List<dynamic>> permutate(List<dynamic> data);
```

### CryptoUtils

Helper class for cryptographic operations. This is some kind of high level api for pointycastle and asn1lib.

```dart
String getSha1ThumbprintFromBytes(Uint8List bytes);
String getSha256ThumbprintFromBytes(Uint8List bytes);
String getMd5ThumbprintFromBytes(Uint8List bytes);
Uint8List rsaPublicKeyModulusToBytes(RSAPublicKey publicKey);
Uint8List rsaPublicKeyExponentToBytes(RSAPublicKey publicKey);
Uint8List rsaPrivateKeyToBytes(RSAPrivateKey privateKey);
Uint8List rsaPrivateKeyExponentToBytes(RSAPrivateKey privateKey);
AsymmetricKeyPair generateRSAKeyPair({int keySize = 2048});
AsymmetricKeyPair generateEcKeyPair({String curve = 'prime256v1'});
String encodeRSAPublicKeyToPem(RSAPublicKey publicKey);
String encodeRSAPrivateKeyToPem(RSAPrivateKey rsaPrivateKey);
RSAPrivateKey rsaPrivateKeyFromPem(String pem);
RSAPublicKey rsaPublicKeyFromPem(String pem);
RSAPrivateKey rsaPrivateKeyFromDERBytes(Uint8List bytes);
RSAPublicKey rsaPublicKeyFromDERBytes(Uint8List bytes);
Uint8List getBytesFromPEMString(String pem, {bool checkHeader = true});
String encodeEcPrivateKeyToPem(ECPrivateKey ecPrivateKey);
String encodeEcPublicKeyToPem(ECPublicKey publicKey);
ECPublicKey ecPublicKeyFromPem(String pem);
ECPrivateKey ecPrivateKeyFromPem(String pem);
ECPrivateKey ecPrivateKeyFromDerBytes(Uint8List bytes,{bool pkcs8 = false})
ECPublicKey ecPublicKeyFromDerBytes(Uint8List bytes);
String rsaEncrypt(String message, RSAPublicKey publicKey);
String rsaDecrypt(String cipherMessage, RSAPrivateKey privateKey);
Uint8List rsaSign(RSAPrivateKey privateKey, Uint8List dataToSign, {String algorithmName = 'SHA-256/RSA'});
bool rsaVerify(RSAPublicKey publicKey, Uint8List signedData, Uint8List signature,{String algorithm = 'SHA-256/RSA'});
String encodeRSAPrivateKeyToPemPkcs1(RSAPrivateKey rsaPrivateKey);
String encodeRSAPublicKeyToPemPkcs1(RSAPublicKey rsaPublicKey);
RSAPublicKey rsaPublicKeyFromPemPkcs1(String pem);
RSAPrivateKey rsaPrivateKeyFromPemPkcs1(String pem);
RSAPublicKey rsaPublicKeyFromDERBytesPkcs1(Uint8List bytes);
RSAPrivateKey rsaPrivateKeyFromDERBytesPkcs1(Uint8List bytes);
ECSignature ecSign(ECPrivateKey privateKey, Uint8List dataToSign, {String algorithmName = 'SHA-1/ECDSA'});
bool ecVerify(ECPublicKey publicKey, Uint8List signedData, ECSignature signature, {String algorithm = 'SHA-1/ECDSA'});
String getHash(Uint8List bytes, {String algorithmName = 'SHA-256'});
BigInt getModulusFromRSAPrivateKeyPem(String pem);
String ecSignatureToBase64(ECSignature signature);
ECSignature ecSignatureFromBase64(String b64);
bool ecVerifyBase64(ECPublicKey publicKey, Uint8List origData, String signature, {String algorithm = 'SHA-1/ECDSA'});
ECSignature ecSignatureFromDerBytes(Uint8List data);
Uint8List i2osp(BigInt number,{int? outLen, Endian endian = Endian.big});
BigInt osp2i(Iterable<int> bytes, {Endian endian = Endian.big});
Uint8List rsaPssSign(RSAPrivateKey privateKey, Uint8List dataToSign, Uint8List salt, {String algorithm = 'SHA-256/PSS'});
bool rsaPssVerify(RSAPublicKey publicKey, Uint8List signedData, Uint8List signature, Uint8List salt, {String algorithm = 'SHA-256/PSS'});
```

### ASN1Utils

Helper class for operation on ASN1 objects.

```dart
String dump(String pem, {bool checkHeader = true});
ASN1DumpWrapper complexDump(String pem, {bool checkHeader = true});
```

### HexUtils

Helper class for converting hexadecimal string/bytes.

```dart
Uint8List decode(String hex);
String encode(Uint8List bytes);
```

### EnumUtils

Helper class for operation on enums.

```dart
T getEnum<T extends Enum>(final String enumName, final List<T> enumList, final T defaultEnum, {bool ignoreCase = false});
bool isValidEnum(final String enumName, final List<Enum> enumList, {bool ignoreCase = false});
Map getEnumMap(final List<Enum> enumList);
```

### BooleanUtils

Helper class for operation on booleans.

```dart
bool and(final List<bool> array);
bool or(final List<bool> array);
bool xor(final List<bool> array);
List<bool> booleanValues();
int compare(final bool x, final bool y);
bool toBoolean(final int value);
bool toBooleanObject(final String? str);
bool toBooleanDefaultIfNull(final bool? value, final bool valueIfNull);
int toInteger(final bool bool);
String toBooleanString(final bool value);
```

### FunctionDefs

Helper with various function prototype definitions.

```dart
BiConsumer<T,U>
BiFunction<T,U,R>
BinaryOperator<T>
BiPredicate<T,U>
Consumer<T>
Supplier<T>
BooleanSupplier
SingleFunction<T,R>
Predicate<T>
UnaryOperator<T>
```

## Changelog

For a detailed changelog, see the [CHANGELOG.md](CHANGELOG.md) file

## Real Live Examples

### SSL Toolkit

All-in-one crossplatform ([Android](https://play.google.com/store/apps/details?id=de.feuerbergsoftware.ssl_checker)/[iOS/macOS](https://apps.apple.com/us/app/ssl-toolkit/id1547278785)/[Windows](https://www.microsoft.com/en-us/p/ssl-toolkit/9nc62bnkndvx)) toolkit for SSL, including SSL install check, TLS check, PEM parser, CSR generator and certificate transparency log check.

## Copyright and license

MIT License

Copyright (c) 2023 Ephenodrom

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
