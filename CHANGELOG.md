# Changelog

## [5.7.0] - 2022-10-24

* ECDSA Keypair SEC1 to Pkcs8 converting (PR #101)
* Added a new param for the "Not Before" flag of self signed x.509 certificates (PR #105)

## [5.6.1] - 2022-07-16

* Added missing BooleanUtils export

## [5.6.0] - 2022-06-10

* Update dependencies to be ready for Dart 3.

## [5.5.4] - 2022-04-14

* Improve X509Utils, fix signature check

## [5.5.3] - 2022-03-23

* Update to latest pointycastle release

## [5.5.2] - 2022-03-20

* Remove ported classes from package to be compatible with the latest release of pointycastle

## [5.5.1] - 2022-02-21

* Improved X509Utils, X509 parsing and generation supports now KeyUsage extensions. (PR #81)

## [5.5.0] - 2022-02-10

* Added HexUtils
* Added PKCS12Utils

## [5.4.3] - 2022-12-28

* Improved X509Utils, generateSelfSignedCertificate() method now supports written DN keys as like CN, O and so on as issuer.
* Improved CryptoUtils, added rsaPssSign() and rsaPssVerify() method
* Improved X509Utils, csrFromPem() now reads salt length and pssDigest if PSS algorithm is used for signature
* Improved model CertificateSigningRequestData added new fields saltLength and pssDigest

## [5.4.2] - 2022-11-08

* Improved X509Utils, improved CRL parsing

## [5.4.1] - 2022-11-04

* Improved X509CertificateData. Field signature is now nullable to be backwards compatible.

## [5.4.0] - 2022-10-13

* Improved MathUtils added median(), logBase(), log2(), log10() method (PR #78, #79)
* Added unit tests

## [5.3.0] - 2022-09-15

* Improved StringUtils added isIP() method
* Added unit tests

## [5.2.2] - 2022-09-06

* Improved X509CertificateData. Field tbsCertificate is now nullable to be backwards compatible.
* Update dependencies

## [5.2.1] - 2022-09-05

* Improved ASN1Utils, improved complexDump()
* Improved StringUtils, added toPascalCase()
* Added unit tests

## [5.2.0] - 2022-08-30

* Improved ASN1Utils, added complexDump() method
* Added new models ASN1DumpWrapper, ASN1DumpLine and ASN1ObjectType
* Added unit tests

## [5.1.2] - 2022-08-26

* Improved X509Utils, parsing distinguised names from ASN1 Sequence now supports multi value DN. This improves the parsing of CSR and X509 PEMs.

## [5.1.1] - 2022-08-23

* Add missing models to export

## [5.1.0] - 2022-08-22

* Improved X509Utils, added checkChain() method
* Improved X509Utils, added fixPem() method
* Added new unit tests
* Added new models CertificateChainCheckData and CertificateChainPairCheckResult

## [5.0.0] - 2022-08-18

**IMPORTANT**
This version includes some important changes. Read the log carefully. All functions are currently backwards compatible and will also fill the deprecated fields. But this may change in the future!

* Improved model X509CertificateData to match the structure described at RFC 2459
* Improved model CertificateSigningRequestData to match the structure described at RFC 2986
* Improved model X509CertificateData marked fields as deprecated
* Improved model CertificateSigningRequestData marked fields as deprecated
* Added new model TbsCertificate
* Added new model CertificationRequestInfo
* Improved X509Utils, added new method checkX509Signature()

## [4.5.2] - 2022-08-04

* Improved CryptopUtils, fixed a bug in encodeEcPrivateKeyToPem() that encoded the EC point Q wrong

## [4.5.1] - 2022-08-03

* Improved IterableUtils, added swap() and permutate() methods
* Added new unit tests
* Improved CryptoUtils addd i2osp() and osp2i() methods

## [4.5.0] - 2022-08-01

* Improved X509Utils, generateSelfSignedCertificate() accepts custom issuer

## [4.4.3] - 2022-07-27

* Export of CRL models

## [4.4.2] - 2022-07-26

* Improved CryptoUtils, added ecSignatureFromDerBytes()
* Improved X509Utils, added checkCsrSignature()
* Added new field infoData to CertificateSigningRequestData model

## [4.4.1] - 2022-07-20

* Fixed static value of X509Utils.BEGIN_EC_PUBLIC_KEY
* Fixed static value of X509Utils.END_EC_PUBLIC_KEY

## [4.4.0] - 2022-07-20

* Improved X509Utils, added crlDerToPem()
* Improved X509Utils, added crlDataFromPem()
* Improved X509Utils to support constructed subject alternative names (#73)
* Improved X509CertificateDataExtensions model, added new field cRLDistributionPoints
* Improved X509Utils, certificate parsing now supports cRLDistributionPoints extension
* Update dependencies
* Fixed linter errors

## [4.3.0] - 2022-07-05

* Improved IterableUtils (PR #68 #69)
* Improved HttpsUtils (PR #71)
* Improved CryptoUtils, added new methods ecSignatureToBase64(), ecSignatureFromBase64()
* Improved CryptoUtils (PR #72)

## [4.2.2] - 2022-05-13

* Improved CryptoUtils and ASN1Utils, added optional parameters

## [4.2.1] - 2022-04-22

* Improved X509Utils, added parseChainString()
* Improved X509Utils, added parseChainStringAsString()

## [4.2.0] - 2022-01-24

* Added BooleanUtils (PR #65)
* Updated minimum SDK version to 2.15 (PR #66)

## [4.1.0] - 2022-02-08

* Improved model SubjectPublicKeyInfo, added new exponent field
* Improved model X509CertificatePublicKeyData, added new fields
* Improved X509Utils, parsing of CSR data
* Improved X509Utils, generateSelfSignedCertificate should now handle not ascii characters
* Improved X509Utils, x509CertificateFromPem() will fetch more information about the public key used
* Update dependencies

## [4.0.1] - 2022-01-24

* Added missing export of EnumUtils

## [4.0.0] - 2022-01-21

* Added EnumUtils (PR #59)

## [3.9.4] - 2021-12-21

* Improved X509Utils for generating self signed certificates

## [3.9.3] - 2021-12-13

* Hide Padding from the PointyCastle API export

## [3.9.2] - 2021-12-12

* Improved X509Utils, generateSelfSignedCertificate() supports ECC keys
* Improved X509Utils, csrFromPem now fetches the SANs within the given CSR
* Added new unit tests
* Added model CertificateSigningRequestExtensions

## [3.9.1] - 2021-11-26

* Updated dependencies

## [3.9.0] - 2021-11-17

* Added support for VMC certificates
* Added model X509CertificateDataExtensions
* Added model VmcData
* Marked X509CertificateData.subjectAlternativNames as deprecated
* Marked X509CertificateData.extKeyUsage as deprecated
* Added BIMI as value to ExtendedKeyUsage enum

## [3.8.2] - 2021-11-10

* Improved X509Utils, fixed public key length calculation while parsing a CSR
* Updated minimum Dart SDK constraint to 2.14.0

## [3.8.1] - 2021-11-05

* Added function definitions
* Export model X509CertificatePublicKeyData

## [3.8.0] - 2021-11-02

* Improved X509Utils add new method generateSelfSignedCertificate()
* Improved X509Utils, x509CertificateFromPem() now parses the extKeyUsage extension
* Improved X509CertificateData model, added new field extKeyUsage
* Added new model ExtendedKeyUsage

## [3.7.0] - 2021-09-28

* Improved X509Utils add new method pemToPkcs7()
* Added new unit tests
* Improved X509Utils, added optional parameter to the encodeASN1ObjectToPem() method, changed line seperator to "\n" instead of "\r\n"

## [3.6.1] - 2021-09-28

* Improved X509Utils and handling of IPv6 SANs (PR #51)
* Added new unit tests (PR #51)

## [3.6.0] - 2021-09-10

* Improved X509Utils added getModulusFromRSAX509Pem() method
* Improved X509Utils added getModulusFromRSACsrPem() method
* Improved CryptoUtils added getModulusFromRSAPrivateKeyPem() method
* Improved CryptoUtils added rsaPrivateKeyExponentToBytes() method
* Added new unit tests

## [3.5.0] - 2021-08-27

* Improved X509Utils added buildOCSPRequest() method
* Improved X509Utils added getOCSPUrl() method
* Improved X509Utils added parseOCSPResponse() method
* Added new unit tests
* Added new OCSP models
* Improved X509Utils added new optional parameter (san, signingAlgorithm) to generateRsaCsrPem() method
* Improved X509Utils added new optional parameter to generateEccCsrPem() method
* Improved X509Utils added new optional parameter to ecPrivateKeyFromDerBytes() method
* Updated dependencies

## [3.4.0] - 2021-07-30

* Updated dependencies
* Added ASN1Utils class

## [3.3.3] - 2021-07-04

* Update dependencies

## [3.3.2] - 2021-06-28

* Improved CertificateSigningRequestData model

## [3.3.1] - 2021-06-28

* Exported CertificateSigningRequestData model
* Update dependencies

## [3.3.0] - 2021-06-28

* Improved X509Utils added csrFromPem() method
* Added unit tests

## [3.2.0] - 2021-06-24

* Improved X509Utils added pkcs7fromPem() method
* Added unit tests
* Update dependencies

## [3.1.0] - 2021-05-17

* Improved StringUtils
* Improved MathUtils

## [3.0.2]

* Improved package exports

## [3.0.1]

* Improve CryptoUtils, added *getHash()* method.
* Added new unit tests

## [3.0.0]

* Improve CryptoUtils, added *ecSign()* and *ecVerify()*
* Added new unit tests

## [3.0.0-nullsafety.2]

* Improve DNSUtils

## [3.0.0-nullsafety.1]

* Updated dependencies

## [3.0.0-nullsafety.0]

* Migrated to **null-safety**

## [2.7.1] - 2020-02-16

* Improved DomainUtils fixed bug in parseDomain

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
