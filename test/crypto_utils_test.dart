import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';

void main() {
  var x509Pem = '''-----BEGIN CERTIFICATE-----
      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
      zvE4WdYIQHPX0Y36+mjPnSMTXcrCPd+9yQ==
      -----END CERTIFICATE-----''';

  var privateKey = '''-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDRBfh7ygAqkP3V
4oosv8R2sfTY39SWDflt0IlKjMe5uegMbtleIQtMW48MA02YbgebFVSke/W7GZWt
vMQKeoEETOMtbk1pbZP1TvgAKjbceYMVAmqJMX9pUVx8TMrAde1l5VUKtdTkwS+c
WMOsQ6uBkgV3joASVK38hTp3rMpGUXHqliAHriY9bcvnSw2uDo42QJ9e3sdPm7Z+
3Oj+I/mqLjUG3MlSTZ1L0OyRvB5Dya/gpGy2NrCKhB/ZCN7D+WBpVJ/lXlgQVae8
csKHXn8vBs3lnoQ3QqzuLSCR58p+D7vJ13t5TiMcqGYTXkpu7n25aBL1yzAniOZc
8+q6S6xlAgMBAAECggEAduQbg2XRlGSmTSsvBucI+66bI2SlSbinIIRWIxZSYFzT
FYdTkkvfXk5R3jZew44KO3b1jx2HFyYlUg4lwAQQMH7/VQ8Bby9J0mVZgNaCIAPp
wGCAcoq5+xCxN26CgNhS8Ptx1Ma6UmdkCl0e53QSMH/7Jhbi2ApccF7jc8DPyRBw
VGbsdAfgzpimhUH6BOPCPZuirFWOf8Nqvuk7STqAWgIy+SEboNiG7Ekx+WUEjNE/
n6Xt66eu/BTZXImB9ErdYrW7I4mNfzfwWfCiC4XZDb4J3O8pSkbEtmeKCUFpL+6l
TXExvJvM8bb9iGnHbNBEB6Y9lVAsnTYXSV8dlfa3oQKBgQD7i0riq++cRXUEk8rn
ASO8FUqIL1FCCb1rQ51XqkpHz2ktdQVlEHHcX17i03Gy+912FWDJ6Ct/mLbMs9Ue
UpZ7dNYXyEX4+ch2kLi94NO399TyxTGVUzNOCV57AJl8E0ryk1FHM6ouyNVASgI2
vcIJMAPqMu6+zdo2v5p+zE6kLQKBgQDUudqdE/Z9V8i500YjrN7noN6TBVRuoqtl
MfoymdMo5jbIdkEJP9hc1n8Aiy7KneYAMmrN5rwwnBG6nYkVf5Nom6mLPk7+zqcS
YLPitdR0qEK+8U6xqf6wiJMrzuI8eEyAATjcceJUAkRJvfbfIYj37SdVBnrwPRMJ
lSkU3qa0GQKBgD6FO4KlW3PK66/MkBTkep5H6HN610aDpzne31+nqri4e5rZyBJ7
iOFOLwZPqaXj5gJwg9MLSqx3J5AvblwQCOj8fC4DECk25DVb+R7wn47NIXeJva4w
tMLDn2ERIBTvsqQiK4R3+eeQ8Tf+bRhwB6dC8OYn7KEuBvuumdbELxOtAoGARw/z
FMgnboXVuyX151MHf69AyzJbmz3iLcL9RswWOzJ0mJDQdwuJ9rF86ayVLACFZglx
nmj28vIgBgw8UB83GhnuEGL3Nq3IKB5/2TtOxs2yxmCMHlOgjk6Bg3/wGa1COPyv
hwzQQ6oiL9Qy1SU5wUDLA99PUFPGuUvH1n3uiHkCgYEA8PmSWfXS7tnm6IrqnOWr
64DNWpka9gwgzz6NA7AeVlmduCUU/PMDdiywiPobGMCA15Ayp89L2jHlXIMb/R1O
45etmy7kF30PfHdGJureBFI6hr+DIIbSJETKvMU/Ipc/Zcv44IscWbGKVsvw/r0D
bjBqILerN9h2zFj3Fi+DdT0=
-----END PRIVATE KEY-----''';

  var publicKey = '''-----BEGIN PUBLIC KEY-----
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjfAMrROlWtTPi4P2Gd7X
      OqEoq9L18ghnHSaOwkkQre1d3ZLEozf/v1WVsfmjpR4HJZEMRKCatOGcmW+gzjQ3
      y6hXnDkQXmxjJJv6pTpxmFNKNIsRAfpP9YQwNglHTYdXJMIUSJ2M0bvj4Dm/WlAb
      f71Z6mc/lZF6BdRc3+jPG2bVQ5QOaCt6Rkgqsd3ggVtDJZZl+qlWgwpZMZEBav+E
      AcEups9SDnj+dgvL7ySqAH4RH+/sC6jc1swMb8EQpZggAVwQXKAbcT0XYo3i5wsS
      qH+Iddw5PYiRoTrKwlQJKmlSNYl/fRzA84pxkC6r038zawpGSGRWqHpRw13bg8f/
      xwIDAQAB
      -----END PUBLIC KEY-----''';

  test('Test rsaPublicKeyModulusToBytes', () {
    var key = CryptoUtils.rsaPublicKeyFromPem(publicKey);
    var bytes = CryptoUtils.rsaPublicKeyModulusToBytes(key);
    var hexString = hex.encode(bytes);
    expect(hexString,
        '8df00cad13a55ad4cf8b83f619ded73aa128abd2f5f208671d268ec24910aded5ddd92c4a337ffbf5595b1f9a3a51e0725910c44a09ab4e19c996fa0ce3437cba8579c39105e6c63249bfaa53a7198534a348b1101fa4ff584303609474d875724c214489d8cd1bbe3e039bf5a501b7fbd59ea673f95917a05d45cdfe8cf1b66d543940e682b7a46482ab1dde0815b43259665faa956830a593191016aff8401c12ea6cf520e78fe760bcbef24aa007e111fefec0ba8dcd6cc0c6fc110a59820015c105ca01b713d17628de2e70b12a87f8875dc393d8891a13acac254092a695235897f7d1cc0f38a71902eabd37f336b0a46486456a87a51c35ddb83c7ffc7');
  });

  test('Test rsaPublicKeyExponentToBytes', () {
    var key = CryptoUtils.rsaPublicKeyFromPem(publicKey);
    var bytes = CryptoUtils.rsaPublicKeyExponentToBytes(key);
    var hexString = hex.encode(bytes);
    expect(hexString, '010001');
  });

  test('Test rsaPrivateKeyModulusToBytes', () {
    var key = CryptoUtils.rsaPrivateKeyFromPem(privateKey);
    var bytes = CryptoUtils.rsaPrivateKeyModulusToBytes(key);
    var hexString = hex.encode(bytes);
    expect(hexString,
        'd105f87bca002a90fdd5e28a2cbfc476b1f4d8dfd4960df96dd0894a8cc7b9b9e80c6ed95e210b4c5b8f0c034d986e079b1554a47bf5bb1995adbcc40a7a81044ce32d6e4d696d93f54ef8002a36dc798315026a89317f69515c7c4ccac075ed65e5550ab5d4e4c12f9c58c3ac43ab819205778e801254adfc853a77acca465171ea962007ae263d6dcbe74b0dae0e8e36409f5edec74f9bb67edce8fe23f9aa2e3506dcc9524d9d4bd0ec91bc1e43c9afe0a46cb636b08a841fd908dec3f96069549fe55e581055a7bc72c2875e7f2f06cde59e843742acee2d2091e7ca7e0fbbc9d77b794e231ca866135e4a6eee7db96812f5cb302788e65cf3eaba4bac65');
  });

  test('Test getThumbprintFromCertBytes', () {
    var bytes = CryptoUtils.getBytesFromPEMString(x509Pem);
    var thumbprint = CryptoUtils.getSha1ThumbprintFromBytes(bytes);
    expect(thumbprint, '65AA0349076EC56BA663F128074F426705B41FB1');
  });

  test('Test getSha256ThumbprintFromCertBytes', () {
    var bytes = CryptoUtils.getBytesFromPEMString(x509Pem);
    var thumbprint = CryptoUtils.getSha256ThumbprintFromBytes(bytes);
    expect(thumbprint,
        '2E97B80F5E7AFFFBC0C94D75F0867C5B34B5B49142704FB06CCE7088DBDACF76');
  });

  test('Test getMd5ThumbprintFromCertBytes', () {
    var bytes = CryptoUtils.getBytesFromPEMString(x509Pem);
    var thumbprint = CryptoUtils.getMd5ThumbprintFromBytes(bytes);
    expect(thumbprint, 'EA0A4E97FB79AC590C4DE08DD4F5E331');
  });

  test('Test encodeRSAPrivateKeyToPem', () {
    var pair = CryptoUtils.generateRSAKeyPair();
    var pem = CryptoUtils.encodeRSAPrivateKeyToPem(pair.privateKey);
    expect(pem.startsWith('-----BEGIN PRIVATE KEY-----'), true);
    expect(pem.endsWith('-----END PRIVATE KEY-----'), true);
  });

  test('Test encodeRSAPublicKeyToPem', () {
    var pair = CryptoUtils.generateRSAKeyPair();
    var pem = CryptoUtils.encodeRSAPublicKeyToPem(pair.publicKey);
    expect(pem.startsWith('-----BEGIN PUBLIC KEY-----'), true);
    expect(pem.endsWith('-----END PUBLIC KEY-----'), true);
  });

  test('Test encodeRSAPrivateKeyToPemPkcs1', () {
    var pair = CryptoUtils.generateRSAKeyPair();
    var pem = CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(pair.privateKey);
    expect(pem.startsWith('-----BEGIN RSA PRIVATE KEY-----'), true);
    expect(pem.endsWith('-----END RSA PRIVATE KEY-----'), true);
  });

  test('Test encodeRSAPublicKeyToPemPkcs1', () {
    var pair = CryptoUtils.generateRSAKeyPair();
    var pem = CryptoUtils.encodeRSAPublicKeyToPemPkcs1(pair.publicKey);
    expect(pem.startsWith('-----BEGIN RSA PUBLIC KEY-----'), true);
    expect(pem.endsWith('-----END RSA PUBLIC KEY-----'), true);
  });

  test('Test privateKeyFromPem', () {
    var object = CryptoUtils.rsaPrivateKeyFromPem(privateKey);
    expect(object.n.bitLength, 2048);
  });

  test('Test publicKeyFromPem', () {
    var object = CryptoUtils.rsaPublicKeyFromPem(publicKey);
    expect(object.n.bitLength, 2048);
  });

  test('Test privateKeyFromDERBytes', () {
    var bytes = CryptoUtils.getBytesFromPEMString(privateKey);
    var object = CryptoUtils.rsaPrivateKeyFromDERBytes(bytes);
    expect(object.n.bitLength, 2048);
  });

  test('Test publicKeyFromDERBytes', () {
    var bytes = CryptoUtils.getBytesFromPEMString(publicKey);
    var object = CryptoUtils.rsaPublicKeyFromDERBytes(bytes);
    expect(object.n.bitLength, 2048);
  });

  test('Test encodeECPrivateKeyToPem', () {
    var pair = CryptoUtils.generateEcKeyPair();
    var pem = CryptoUtils.encodeEcPrivateKeyToPem(pair.privateKey);
    expect(pem.startsWith('-----BEGIN EC PRIVATE KEY-----'), true);
    expect(pem.endsWith('-----END EC PRIVATE KEY-----'), true);
  });

  test('Test encodeECPublicKeyToPem', () {
    var pair = CryptoUtils.generateEcKeyPair();
    var pem = CryptoUtils.encodeEcPublicKeyToPem(pair.publicKey);
    expect(pem.startsWith('-----BEGIN EC PUBLIC KEY-----'), true);
    expect(pem.endsWith('-----END EC PUBLIC KEY-----'), true);
  });

  test('Test ecPublicKeyFromPem', () {
    var pair = CryptoUtils.generateEcKeyPair();
    var pubKey = pair.publicKey as ECPublicKey;
    var pubPem = CryptoUtils.encodeEcPublicKeyToPem(pubKey);
    var newPubKey = CryptoUtils.ecPublicKeyFromPem(pubPem);

    expect(newPubKey.Q, pubKey.Q);
    expect(newPubKey.Q.x.toBigInteger(), pubKey.Q.x.toBigInteger());
    expect(newPubKey.Q.y.toBigInteger(), pubKey.Q.y.toBigInteger());
    expect(newPubKey.Q.getEncoded(false), pubKey.Q.getEncoded(false));
  });

  test('Test ecPrivateKeyFromPem', () {
    var pair = CryptoUtils.generateEcKeyPair();
    var privKey = pair.privateKey as ECPrivateKey;

    var privPem = CryptoUtils.encodeEcPrivateKeyToPem(privKey);
    var newPrivKey = CryptoUtils.ecPrivateKeyFromPem(privPem);

    expect(newPrivKey.d, privKey.d);
    expect(newPrivKey.parameters.G, privKey.parameters.G);
  });

  test('Test encrypt / decrypt', () {
    var pair = CryptoUtils.generateRSAKeyPair();
    var privKey = pair.privateKey as RSAPrivateKey;
    var pubKey = pair.publicKey as RSAPublicKey;
    var toEncrypt = 'Hello World! This is Jon Doe.';

    var encrypted = CryptoUtils.rsaEncrypt(toEncrypt, pubKey);
    var decrypted = CryptoUtils.rsaDecrypt(encrypted, privKey);

    expect(decrypted, toEncrypt);
  });

  test('Test rsaSign / rsaVerify', () {
    var pair = CryptoUtils.generateRSAKeyPair();
    var privKey = pair.privateKey as RSAPrivateKey;
    var pubKey = pair.publicKey as RSAPublicKey;
    var toSign = 'Hello World! This is Jon Doe.';

    var bytes = Uint8List.fromList(toSign.codeUnits);

    var signature = CryptoUtils.rsaSign(privKey, bytes);
    var valid = CryptoUtils.rsaVerify(pubKey, bytes, signature);

    expect(valid, true);

    toSign = 'Hello World! This is Jane Doe.';

    bytes = Uint8List.fromList(toSign.codeUnits);
    valid = CryptoUtils.rsaVerify(pubKey, bytes, signature);
    expect(valid, false);
  });
}
