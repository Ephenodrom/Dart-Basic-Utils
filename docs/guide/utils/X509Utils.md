# X509Utils

X509Utils holds a lot of helper methods on operations on x509 certificates, like generating key pairs, generating csr and many more.

## Examples

### Generating RSA CSR

```dart
// Generate a new rsa key pair
var pair = X509Utils.generateKeyPair();

var dn = {
    'CN': 'magic-company.com',
    'O': 'Magic Company',
    'L': 'Fakecity',
    'S': 'FakeState',
    'C': 'DE',
};
// Generate csr by using the defined dn, private key and public key
var csrPem = X509Utils.generateRsaCsrPem(dn, pair.privateKey, pair.publicKey);

// Convert privateKey and publicKey to PEM format
var privateKeyPem = X509Utils.encodeRSAPrivateKeyToPem(pair.privateKey);
var publicKeyPem = X509Utils.encodeRSAPublicKeyToPem(pair.publicKey);

// Print everything out
print('Private Key:\n$privateKeyPem\n\n');
print('Private Key:\n$publicKeyPem\n\n');
print('Certificate Signing Request:\n$csrPem\n\n');
```

### Generating EC CSR

```dart
// Generate a new elliptic curve key pair
var pair = X509Utils.generateEcKeyPair();

var dn = {
    'CN': 'magic-company.com',
    'O': 'Magic Company',
    'L': 'Fakecity',
    'S': 'FakeState',
    'C': 'DE',
};
// Generate csr by using the defined dn, private key and public key
var csrPem = X509Utils.generateEccCsrPem(dn, pair.privateKey, pair.publicKey);

// Convert privateKey and publicKey to PEM format
var privateKeyPem = X509Utils.encodeEcPrivateKeyToPem(pair.privateKey);
var publicKeyPem = X509Utils.encodeEcPublicKeyToPem(pair.publicKey);

// Print everything out
print('Private Key:\n$privateKeyPem\n\n');
print('Private Key:\n$publicKeyPem\n\n');
print('Certificate Signing Request:\n$csrPem\n\n');
```

### Convert a certificate PEM string to a X509CertificateData object

```dart
String x509Pem = '''-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----''';
  
var data = X509Utils.x509CertificateFromPem(x509Pem);

// The serialnumber
var serialNumber = data.serialNumber;

// The issuer
var issuer = data.issuer;

// The subject
var subject = data.subject;
  
// The public key data
var publicKeyData = data.publicKeyData;

// The subject alternative names
var sans = data.subjectAlternativNames;
```

## All methods

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
