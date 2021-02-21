# Changelog

## [3.0.0-null-safety.0]

### Breaking Change :
* Migrated to **null-safety**

## [2.7.0] - 2020-01-29

* Improved DomainUtils added *toIDN()* and *fromIDN()* methods

## [2.7.0-rc.6] - 2020-01-20

* Improved DNS Utils added *reverseDns()* and *getReverseAddr()* methods

## [2.7.0-rc.5] - 2020-01-16

* Updated dependencies
* Fix unit tests
* Add unit tests

## [2.7.0-rc.4] - 2020-12-10

* Updated dependencies (#33)

## [2.7.0-rc.3] - 2020-12-07

* Added new field "plain" to the X509CertificateData model

## [2.7.0-rc.2] - 2020-12-02

* Improve parsing of x509 certificates if no extensions are available
* Improved parsing of ECC Public key pem

## [2.7.0-rc.1] - 2020-10-14

* Change ASN1 lib from asn1lib to pointycastle (#31)
* Improve code (PR #23 #24 #27 #30)
* Fix crash in X509Utils if x509 certificate does not have a subject field (#28)

## [2.6.3] - 2020-09-30

* Update ColorUtils, add invertColor method. (PR #22)

## [2.6.2] - 2020-08-11

* Improved CryptoUtils, add new methods rsaPublicKeyFromPemPkcs1(), rsaPrivateKeyFromPemPkcs1(), rsaPublicKeyFromDERBytesPkcs1() and rsaPrivateKeyFromDERBytesPkcs1() (#18)

## [2.6.1] - 2020-08-03

* Improved CryptoUtils, add new methods encodeRSAPrivateKeyToPemPkcs1() and encodeRSAPublicKeyToPemPkcs1() (#18)
* Improved DateUtils to not rely on the intl package

## [2.6.0] - 2020-07-28

* Moved X509Utils.generateRSAKeyPair() to CryptoUtils.generateRSAKeyPair()
* Moved X509Utils.encodeRSAPrivateKeyToPem() to CryptoUtils.encodeRSAPrivateKeyToPem()
* Moved X509Utils.encodeRSAPublicKeyToPem() to CryptoUtils.encodeRSAPublicKeyToPem()
* Moved X509Utils.privateKeyFromDERBytes() to CryptoUtils.rsaPrivateKeyFromDERBytes()
* Moved X509Utils.privateKeyFromPem() to CryptoUtils.rsaPrivateKeyFromPem()
* Moved X509Utils.publicKeyFromPem() to CryptoUtils.rsaPublicKeyFromPem()
* Add new method RSAPublicKey rsaPublicKeyFromDERBytes(Uint8List bytes) to CryptoUtils class
* Moved X509Utils.ecPublicKeyFromDerBytes() to CryptoUtils.ecPublicKeyFromDerBytes()
* Moved X509Utils.ecPrivateKeyFromDerBytes() to CryptoUtils.ecPrivateKeyFromDerBytes()
* Moved X509Utils.ecPrivateKeyFromPem() to CryptoUtils.ecPrivateKeyFromPem()
* Moved X509Utils.ecPublicKeyFromPem() to CryptoUtils.ecPublicKeyFromPem()
* Moved X509Utils.ecPublicKeyFromPem() to CryptoUtils.ecPublicKeyFromPem()
* Moved X509Utils.encodeEcPublicKeyToPem() to CryptoUtils.encodeEcPrivateKeyToPem()
* Moved X509Utils.rsaPublicKeyModulusToBytes() to CryptoUtils.rsaPublicKeyModulusToBytes()
* Moved X509Utils.rsaPublicKeyExponentToBytes() to CryptoUtils.rsaPublicKeyExponentToBytes()
* Moved X509Utils.rsaPrivateKeyModulusToBytes() to CryptoUtils.rsaPrivateKeyModulusToBytes()

## [2.5.7] - 2020-07-24

* Improve X509Utils, add new methods ecPrivateKeyFromPem and ecPublicKeyFromPem

## [2.5.6] - 2020-07-17

* Improve StringUtils, enhanced capitalize method (#17)

## [2.5.5] - 2020-07-07

* Improve X509Utils, enhanced distinguish names list (#16)
* Improve X509Utils, added new method for elliptic curve cryptographie (#15)

## [2.5.4] - 2020-06-13

* Improve DNSUtils (#14)
* Updated dependencies

## [2.5.3] - 2020-03-09

* Improve X509Utils (#13)
* Improve DNSUtils
* Improve unit tests
* Update license, changed year to 2020

## [2.5.2] - 2020-02-24

* Improve X509Utils (#10)
* Update dependencies
* Improve CryptoUtils
* Add unit tests

## [2.5.1] - 2020-02-20

* Improve X509Utils (#10)
* Update dependencies
* Add unit tests

## [2.5.0] - 2020-02-18

* Improve X509Utils (#10 #11)
* Update dependencies
* Add unit tests

## [2.4.9] - 2020-02-17

* Improve X509Utils, fix RangeError while parsing PEM string (#9)

## [2.4.8] - 2020-01-16

* Update dependencies

## [2.4.7] - 2020-01-13

* Improve HttpUtils, make body within POST requests optional

## [2.4.6] - 2020-01-13

* Improve HttpUtils, make body within PUT requests optional

## [2.4.5] - 2020-01-02

* Improve DateUtils
* Add unit tests

## [2.4.4] - 2020-01-02

* Update dependencies

## [2.4.3] - 2019-12-21

* Fix new linter warnings

## [2.4.2] - 2019-12-16

* Improve IterableUtils
* Add new unit tests

## [2.4.1] - 2019-12-13

* Improve X509 parsing

## [2.4.0] - 2019-12-13

* Update dependencies

## [2.3.9] - 2019-12-13

* Improve json serialization of the X509Certificate models

## [2.3.8] - 2019-11-29

* Improve X509Utils (#8)
* Improve UnitTests

## [2.3.7] - 2019-11-25

* Improve DomainUtils (#7)
* Improve UnitTests

## [2.3.6] - 2019-11-25

* Improve DomainUtils (#6)
* Improve UnitTests

## [2.3.5] - 2019-11-25

* Improve StringUtils (#5)
* Improve DomainUtils (#6)
* Improve UnitTests

## [2.3.4] - 2019-11-21

* Fix health suggestions

## [2.3.3] - 2019-11-12

* Add Json Serialization To X509CertificateData Model

## [2.3.2] - 2019-11-11

* Improve X509CertificateData Model
* Improve X509Utils

## [2.3.1] - 2019-11-08

* Update pubspec.yaml

## [2.3.0] - 2019-11-06

* Added CryptoUtils
* Improve X509Utils
* Improve X509CertificateData Model
* Improve and add Unit tests

## [2.2.5] - 2019-11-04

* Improve X509Utils
* Improve X509CertificateData Model
* Improve and add Unit tests

## [2.2.4] - 2019-10-21

* Export models

## [2.2.3] - 2019-10-21

* Improve X509Utils

## [2.2.2] - 2019-10-21

* Improve X509Utils
* Add Unit test

## [2.2.1] - 2019-10-18

* Minor fix

## [2.2.0] - 2019-10-18

* Add IterableUtils (Pull Request)
* Add Unit test

## [2.1.0] - 2019-10-16

* Improve StringUtils
* Add X509Utils
* Add Unit test

## [2.0.3] - 2019-10-14

* Improve DomainUtils
* Add Unit test

## [2.0.2] - 2019-09-23

* Improve ColorUtils
* Add Unit test

## [2.0.1] - 2019-09-12

* Improve ColorUtils
* Improve MathUtils
* Add Unit test

## [2.0.0] - 2019-09-04

* Improve ColorUtils
* Add Unit test

## [1.9.3] - 2019-09-03

* Improve documentation of DateUtils

## [1.9.2] - 2019-09-03

* Fix minor bug

## [1.9.1] - 2019-09-02

* Fix minor bug

## [1.9.0] - 2019-09-02

* Add DateUtils
* Add unit tests

## [1.8.2] - 2019-08-30

* Fix minor bug
* Update dependecies

## [1.8.1] - 2019-08-28

* Fix minor bug

## [1.8.0] - 2019-08-28

* Add new ColorUtils
* Add new unit tests

## [1.7.0] - 2019-08-26

* Add ColorUtils
* Add unit tests

## [1.6.0] - 2019-08-08

* Switch from import files to export files
* Improve error handling in HttpUtils

## [1.5.1] - 2019-08-05

* Fix "Health suggestions" from pub.dev

## [1.5.0] - 2019-07-17

* Improve StringUtils

## [1.4.0] - 2019-07-15

* Improve StringUtils

## [1.3.0] - 2019-07-08

* Improve HttpUtils

## [1.2.0] - 2019-06-14

* Add SortUtils
* Improve MathUtils

## [1.1.1] - 2019-05-06

* Improve DnsUtils

## [1.1.0] - 2019-05-06

* Fix DnsUtils

## [1.0.9] - 2019-05-06

* Clear and improve code.

## [1.0.8] - 2019-05-02

* Improve HttpUtils to handle simple string responses.

## [1.0.7] - 2019-04-28

* Added new StringUtils method
* Added new unit tests

## [1.0.6] - 2019-04-26

* Added new DnsUtils
* Added new unit tests

## [1.0.5] - 2019-04-16

* Added new HttpUtils
* Added new unit tests

## [1.0.4] - 2019-04-10

* Added new StringUtils
* Added new unit tests
* Improve documentation

## [1.0.3] - 2019-04-02

* Added new MathUtils
* Added new EmailUtils
* Added new unit tests

## [1.0.2] - 2019-03-06

* Added new helper functions
* Added new unit tests

## [1.0.1] - 2019-02-21

* Minor changes

## [1.0.0] - 2019-02-21

* Initial release
