import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:basic_utils/src/X509Utils.dart';
import 'package:basic_utils/src/model/x509/X509CertificateData.dart';
import 'package:pointycastle/impl.dart';
import 'package:pointycastle/pointycastle.dart';
import "package:test/test.dart";
import 'package:convert/convert.dart';

void main() {
  String privateKey = "-----BEGIN PRIVATE KEY-----\n" +
      "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDRBfh7ygAqkP3V\n" +
      "4oosv8R2sfTY39SWDflt0IlKjMe5uegMbtleIQtMW48MA02YbgebFVSke/W7GZWt\n" +
      "vMQKeoEETOMtbk1pbZP1TvgAKjbceYMVAmqJMX9pUVx8TMrAde1l5VUKtdTkwS+c\n" +
      "WMOsQ6uBkgV3joASVK38hTp3rMpGUXHqliAHriY9bcvnSw2uDo42QJ9e3sdPm7Z+\n" +
      "3Oj+I/mqLjUG3MlSTZ1L0OyRvB5Dya/gpGy2NrCKhB/ZCN7D+WBpVJ/lXlgQVae8\n" +
      "csKHXn8vBs3lnoQ3QqzuLSCR58p+D7vJ13t5TiMcqGYTXkpu7n25aBL1yzAniOZc\n" +
      "8+q6S6xlAgMBAAECggEAduQbg2XRlGSmTSsvBucI+66bI2SlSbinIIRWIxZSYFzT\n" +
      "FYdTkkvfXk5R3jZew44KO3b1jx2HFyYlUg4lwAQQMH7/VQ8Bby9J0mVZgNaCIAPp\n" +
      "wGCAcoq5+xCxN26CgNhS8Ptx1Ma6UmdkCl0e53QSMH/7Jhbi2ApccF7jc8DPyRBw\n" +
      "VGbsdAfgzpimhUH6BOPCPZuirFWOf8Nqvuk7STqAWgIy+SEboNiG7Ekx+WUEjNE/\n" +
      "n6Xt66eu/BTZXImB9ErdYrW7I4mNfzfwWfCiC4XZDb4J3O8pSkbEtmeKCUFpL+6l\n" +
      "TXExvJvM8bb9iGnHbNBEB6Y9lVAsnTYXSV8dlfa3oQKBgQD7i0riq++cRXUEk8rn\n" +
      "ASO8FUqIL1FCCb1rQ51XqkpHz2ktdQVlEHHcX17i03Gy+912FWDJ6Ct/mLbMs9Ue\n" +
      "UpZ7dNYXyEX4+ch2kLi94NO399TyxTGVUzNOCV57AJl8E0ryk1FHM6ouyNVASgI2\n" +
      "vcIJMAPqMu6+zdo2v5p+zE6kLQKBgQDUudqdE/Z9V8i500YjrN7noN6TBVRuoqtl\n" +
      "MfoymdMo5jbIdkEJP9hc1n8Aiy7KneYAMmrN5rwwnBG6nYkVf5Nom6mLPk7+zqcS\n" +
      "YLPitdR0qEK+8U6xqf6wiJMrzuI8eEyAATjcceJUAkRJvfbfIYj37SdVBnrwPRMJ\n" +
      "lSkU3qa0GQKBgD6FO4KlW3PK66/MkBTkep5H6HN610aDpzne31+nqri4e5rZyBJ7\n" +
      "iOFOLwZPqaXj5gJwg9MLSqx3J5AvblwQCOj8fC4DECk25DVb+R7wn47NIXeJva4w\n" +
      "tMLDn2ERIBTvsqQiK4R3+eeQ8Tf+bRhwB6dC8OYn7KEuBvuumdbELxOtAoGARw/z\n" +
      "FMgnboXVuyX151MHf69AyzJbmz3iLcL9RswWOzJ0mJDQdwuJ9rF86ayVLACFZglx\n" +
      "nmj28vIgBgw8UB83GhnuEGL3Nq3IKB5/2TtOxs2yxmCMHlOgjk6Bg3/wGa1COPyv\n" +
      "hwzQQ6oiL9Qy1SU5wUDLA99PUFPGuUvH1n3uiHkCgYEA8PmSWfXS7tnm6IrqnOWr\n" +
      "64DNWpka9gwgzz6NA7AeVlmduCUU/PMDdiywiPobGMCA15Ayp89L2jHlXIMb/R1O\n" +
      "45etmy7kF30PfHdGJureBFI6hr+DIIbSJETKvMU/Ipc/Zcv44IscWbGKVsvw/r0D\n" +
      "bjBqILerN9h2zFj3Fi+DdT0=\n" +
      "-----END PRIVATE KEY-----";

  String publicKey = "-----BEGIN PUBLIC KEY-----\n" +
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjfAMrROlWtTPi4P2Gd7X\n" +
      "OqEoq9L18ghnHSaOwkkQre1d3ZLEozf/v1WVsfmjpR4HJZEMRKCatOGcmW+gzjQ3\n" +
      "y6hXnDkQXmxjJJv6pTpxmFNKNIsRAfpP9YQwNglHTYdXJMIUSJ2M0bvj4Dm/WlAb\n" +
      "f71Z6mc/lZF6BdRc3+jPG2bVQ5QOaCt6Rkgqsd3ggVtDJZZl+qlWgwpZMZEBav+E\n" +
      "AcEups9SDnj+dgvL7ySqAH4RH+/sC6jc1swMb8EQpZggAVwQXKAbcT0XYo3i5wsS\n" +
      "qH+Iddw5PYiRoTrKwlQJKmlSNYl/fRzA84pxkC6r038zawpGSGRWqHpRw13bg8f/\n" +
      "xwIDAQAB\n" +
      "-----END PUBLIC KEY-----";

  String csr = "-----BEGIN CERTIFICATE REQUEST-----\n" +
      "MIICvzCCAacCAQAwejELMAkGA1UEBhMCREUxEjAQBgNVBAgMCUZha2VzdGF0ZTER\n" +
      "MA8GA1UEBwwIRmFrZXRvd24xEzARBgNVBAoMCkVwaGVub2Ryb20xFTATBgNVBAsM\n" +
      "DERldmVsb3BlbWVudDEYMBYGA1UEAwwPYmFzaWMtdXRpbHMuZGV2MIIBIjANBgkq\n" +
      "hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0QX4e8oAKpD91eKKLL/EdrH02N/Ulg35\n" +
      "bdCJSozHubnoDG7ZXiELTFuPDANNmG4HmxVUpHv1uxmVrbzECnqBBEzjLW5NaW2T\n" +
      "9U74ACo23HmDFQJqiTF/aVFcfEzKwHXtZeVVCrXU5MEvnFjDrEOrgZIFd46AElSt\n" +
      "/IU6d6zKRlFx6pYgB64mPW3L50sNrg6ONkCfXt7HT5u2ftzo/iP5qi41BtzJUk2d\n" +
      "S9DskbweQ8mv4KRstjawioQf2Qjew/lgaVSf5V5YEFWnvHLCh15/LwbN5Z6EN0Ks\n" +
      "7i0gkefKfg+7ydd7eU4jHKhmE15Kbu59uWgS9cswJ4jmXPPqukusZQIDAQABoAAw\n" +
      "DQYJKoZIhvcNAQELBQADggEBAMLfJml1DbYOnUA7Nwlutk6suMmS0FDkQLXFiJQk\n" +
      "Ks5Fy6rfNtV1Z8KL/xGqAzyAcuAXL+0cQMZRsNTd9sT5ZriSzoikwaeIKOoRqhFq\n" +
      "bKXqlhYSbgmVUiYKm9HI3w+rzyZ+JXhiRXZ1ZGZXwEjBSu+Ne+SPE12mYlK+4zBx\n" +
      "gPTDMrvb73QiqHqiGc/l5UjwFyrOUsq5GtiMc6QU+rAQjj6Ix6KqOzJIxyVdRzOC\n" +
      "c47tT30d2tJEJbDHGutbqLQFRr7xx7uHP/LGggTFN8Zs2u+cQxPRFsIhQdpDY1MF\n" +
      "tHAaI8r/tlZQWf3fu4FVZMbxrYTMA5cwz/TxweMKWTroN5c=\n" +
      "-----END CERTIFICATE REQUEST-----";

  String unformattedKey =
      "MIICvzCCAacCAQAwejELMAkGA1UEBhMCREUxEjAQBgNVBAgMCUZha2VzdGF0ZTERMA8GA1UEBwwIRmFrZXRvd24xEzARBgNVBAoMCkVwaGVub2Ryb20xFTATBgNVBAsMDERldmVsb3BlbWVudDEYMBYGA1UEAwwPYmFzaWMtdXRpbHMuZGV2MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0QX4e8oAKpD91eKKLL/EdrH02N/Ulg35bdCJSozHubnoDG7ZXiELTFuPDANNmG4HmxVUpHv1uxmVrbzECnqBBEzjLW5NaW2T9U74ACo23HmDFQJqiTF/aVFcfEzKwHXtZeVVCrXU5MEvnFjDrEOrgZIFd46AElSt/IU6d6zKRlFx6pYgB64mPW3L50sNrg6ONkCfXt7HT5u2ftzo/iP5qi41BtzJUk2dS9DskbweQ8mv4KRstjawioQf2Qjew/lgaVSf5V5YEFWnvHLCh15/LwbN5Z6EN0Ks7i0gkefKfg+7ydd7eU4jHKhmE15Kbu59uWgS9cswJ4jmXPPqukusZQIDAQABoAAwDQYJKoZIhvcNAQELBQADggEBAMLfJml1DbYOnUA7Nwlutk6suMmS0FDkQLXFiJQkKs5Fy6rfNtV1Z8KL/xGqAzyAcuAXL+0cQMZRsNTd9sT5ZriSzoikwaeIKOoRqhFqbKXqlhYSbgmVUiYKm9HI3w+rzyZ+JXhiRXZ1ZGZXwEjBSu+Ne+SPE12mYlK+4zBxgPTDMrvb73QiqHqiGc/l5UjwFyrOUsq5GtiMc6QU+rAQjj6Ix6KqOzJIxyVdRzOCc47tT30d2tJEJbDHGutbqLQFRr7xx7uHP/LGggTFN8Zs2u+cQxPRFsIhQdpDY1MFtHAaI8r/tlZQWf3fu4FVZMbxrYTMA5cwz/TxweMKWTroN5c=";

  String x509Pem = "-----BEGIN CERTIFICATE-----\n" +
      "MIIFhTCCBG2gAwIBAgIQCsPCl13VasnM97sWbV7o+TANBgkqhkiG9w0BAQsFADBu\n" +
      "MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3\n" +
      "d3cuZGlnaWNlcnQuY29tMS0wKwYDVQQDEyRFbmNyeXB0aW9uIEV2ZXJ5d2hlcmUg\n" +
      "RFYgVExTIENBIC0gRzEwHhcNMTkxMDE2MDAwMDAwWhcNMjAxMDE2MTIwMDAwWjAZ\n" +
      "MRcwFQYDVQQDEw5qdW5rZHJhZ29ucy5kZTCCASIwDQYJKoZIhvcNAQEBBQADggEP\n" +
      "ADCCAQoCggEBAKDSIKp1yUheQqq239dbS3gPxtYipab0GdC2V+MOLg6RNPtVsGU/\n" +
      "cIyYETt7H5fAP1gBye1gtMFmyYVJO9W25yBuAPK1vPTZjwpgIaFbkJuJl/7MmxKU\n" +
      "H9QDhgbU5t8Uh0xKp2MYDNqBoKVEim9yNE12cFUndSXo/1y775g97jqPTjPPhNZq\n" +
      "hmLrW0o8DMrD3iUeS+0N0/maRrPcxUWQgFFmA7v0CsZMPuhrmbVoBWo7FqbYGo1j\n" +
      "4NDn0F2Yp6z2s85uqJOnkNjbzLW4xBz/Sk3xDAgihVfyXOMsDtLPZK+TGEAXNjZ2\n" +
      "SFzj7VV9iQg7yN5XiO1VMPhmsmgQiTLrEYcCAwEAAaOCAnIwggJuMB8GA1UdIwQY\n" +
      "MBaAFFV0T7JyT/VgulDR1+ZRXJoBhxrXMB0GA1UdDgQWBBS5TXU4GGulj0oVxurj\n" +
      "4iMuqmPXwzAZBgNVHREEEjAQgg5qdW5rZHJhZ29ucy5kZTAOBgNVHQ8BAf8EBAMC\n" +
      "BaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMEwGA1UdIARFMEMwNwYJ\n" +
      "YIZIAYb9bAECMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNv\n" +
      "bS9DUFMwCAYGZ4EMAQIBMIGABggrBgEFBQcBAQR0MHIwJAYIKwYBBQUHMAGGGGh0\n" +
      "dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBKBggrBgEFBQcwAoY+aHR0cDovL2NhY2Vy\n" +
      "dHMuZGlnaWNlcnQuY29tL0VuY3J5cHRpb25FdmVyeXdoZXJlRFZUTFNDQS1HMS5j\n" +
      "cnQwCQYDVR0TBAIwADCCAQQGCisGAQQB1nkCBAIEgfUEgfIA8AB2ALvZ37wfinG1\n" +
      "k5Qjl6qSe0c4V5UKq1LoGpCWZDaOHtGFAAABbdPp/3kAAAQDAEcwRQIhALxeOuwu\n" +
      "avAowNhDJE4uRpk93ET0uLREKIcR69o1WurPAiBmv5ig+kag8mitfxM+G9PSAcOO\n" +
      "TS6qUBOkMunocrHnKwB2AF6nc/nfVsDntTZIfdBJ4DJ6kZoMhKESEoQYdZaBcUVY\n" +
      "AAABbdPp/yIAAAQDAEcwRQIgfaIVeRjb6CNBD2mUMgC2ZlibmxlRwWGrqBYDmbxo\n" +
      "FaMCIQDkIdSLaliDj8N10FGmikgtrKJ351oQs1sk/PqdwSGQsDANBgkqhkiG9w0B\n" +
      "AQsFAAOCAQEAbW+DFt7HvqFr8+kzoBfUQ7UW2SwXqH16UOfAK/GFFeu/0z19BtnF\n" +
      "ChOW7j3wlfzO9TpnmLr/7yw7lL5UXJwXhsnzqf+BYQ2ULE0gPFK9/624WX/fxYEe\n" +
      "SVBbEOpP6hsb1uNVrv6G8M98dXoUDP/zX+jCPXMQAmciH5T+LyTgrq/kw1E81HHh\n" +
      "GJNIB43b4FcyJGcbFA8P24HTpwWaZwg5WqqoNFwdSkeav51wd1INQHFc3H8ulEyD\n" +
      "2mrJ2GqJ8srncAMyV2GdIwxLoCkKS8NRA+EK2agm1iBT7J3wKjak1Rrp4gNlNbtq\n" +
      "zvE4WdYIQHPX0Y36+mjPnSMTXcrCPd+9yQ==\n" +
      "-----END CERTIFICATE-----";

  test('Test getBytesFromPEMString', () {
    Uint8List bytes = X509Utils.getBytesFromPEMString(csr);
    String formatted = X509Utils.formatKeyString(
        base64Encode(bytes), X509Utils.BEGIN_CSR, X509Utils.END_CSR);
    expect(formatted, csr);
  });

  test('Test formatKeyString', () {
    String formatted = X509Utils.formatKeyString(
        unformattedKey, X509Utils.BEGIN_CSR, X509Utils.END_CSR);
    expect(formatted, csr);
  });

  test('Test encodeDN', () {
    Map<String, String> dn = {
      "CN": "basic-utils.dev",
      "O": "Magic Company",
      "L": "Fakecity",
      "S": "FakeState",
      "C": "DE",
    };
    ASN1Sequence object = X509Utils.encodeDN(dn);
    expect(object.elements.length, 5);
  });

  test('Test privateKeyFromPem', () {
    RSAPrivateKey object = X509Utils.privateKeyFromPem(privateKey);
    expect(object.n.bitLength, 2048);
  });

  test('Test publicKeyFromPem', () {
    RSAPublicKey object = X509Utils.publicKeyFromPem(publicKey);
    expect(object.n.bitLength, 2048);
  });

  test('Test privateKeyFromDERBytes', () {
    Uint8List bytes = X509Utils.getBytesFromPEMString(privateKey);
    RSAPrivateKey object = X509Utils.privateKeyFromDERBytes(bytes);
    expect(object.n.bitLength, 2048);
  });

  test('Test privateKeyFromASN1Sequence', () {
    Uint8List bytes = X509Utils.getBytesFromPEMString(privateKey);
    ASN1Sequence asn = ASN1Parser(bytes).nextObject();
    List<ASN1Object> objects = asn.elements;
    ASN1OctetString string = objects[2];
    RSAPrivateKey object = X509Utils.privateKeyFromASN1Sequence(
        ASN1Parser(string.contentBytes()).nextObject());
    expect(object.n.bitLength, 2048);
  });

  test('Test encodeRSAPrivateKeyToPem', () {
    RSAPrivateKey object = X509Utils.privateKeyFromPem(privateKey);
    String pem = X509Utils.encodeRSAPrivateKeyToPem(object);
    expect(pem, privateKey);
  });

  test('Test encodeASN1ObjectToPem', () {
    ASN1Sequence topLevelSeq = new ASN1Sequence();
    topLevelSeq.add(ASN1Integer(BigInt.from(0)));
    String pem = X509Utils.encodeASN1ObjectToPem(
        topLevelSeq, "-----BEGIN PUBLIC KEY-----", "-----END PUBLIC KEY-----");
    expect(
        pem, "-----BEGIN PUBLIC KEY-----\nMAMCAQA=\n-----END PUBLIC KEY-----");
  });

  test('Test encodeRSAPublicKeyToPem', () {
    AsymmetricKeyPair pair = X509Utils.generateKeyPair();
    String pem = X509Utils.encodeRSAPublicKeyToPem(pair.publicKey);
    expect(pem.startsWith("-----BEGIN PUBLIC KEY-----"), true);
    expect(pem.endsWith("-----END PUBLIC KEY-----"), true);
  });

  test('Test generateRsaCsrPem', () {
    AsymmetricKeyPair pair = X509Utils.generateKeyPair();
    Map<String, String> dn = {
      "CN": "basic-utils.dev",
      "O": "Magic Company",
      "L": "Fakecity",
      "S": "FakeState",
      "C": "DE",
    };
    String csr =
        X509Utils.generateRsaCsrPem(dn, pair.privateKey, pair.publicKey);
    Uint8List bytes = X509Utils.getBytesFromPEMString(csr);
    ASN1Sequence sequence = ASN1Sequence.fromBytes(bytes);
    ASN1Sequence e1 = sequence.elements.elementAt(0);
    ASN1Sequence e2 = e1.elements.elementAt(1);
    ASN1Set e3 = e2.elements.elementAt(0);
    ASN1Sequence e4 = e3.elements.elementAt(0);
    ASN1UTF8String e5 = e4.elements.elementAt(1);
    String cn = e5.utf8StringValue;
    expect(cn, "basic-utils.dev");
  });

  test('Test generateKeyPair', () {
    AsymmetricKeyPair pair = X509Utils.generateKeyPair();
    RSAPrivateKey private = pair.privateKey;
    RSAPublicKey public = pair.publicKey;
    expect(private.n.bitLength, 2048);
    expect(public.n.bitLength, 2048);
  });

  test('Test rsaPublicKeyModulusToBytes', () {
    RSAPublicKey key = X509Utils.publicKeyFromPem(publicKey);
    Uint8List bytes = X509Utils.rsaPublicKeyModulusToBytes(key);
    String hexString = hex.encode(bytes);
    expect(hexString,
        "c7ffc783db5dc3517aa8566448460a6b337fd3ab2e90718af3c01c7d7f893552692a0954c2ca3aa191883d39dc75887fa8120be7e28d62173d711ba05c105c012098a510c16f0cccd6dca80becef1f117e00aa24efcb0b76fe780e52cfa62ec10184ff6a019131590a8356a9fa659625435b81e0ddb12a48467a2b680e9443d5661bcfe8df5cd4057a91953f67ea59bd7f1b505abf39e0e3bbd18c9d4814c22457874d4709363084f54ffa01118b344a5398713aa5fa9b24636c5e10399c57a8cb3734cea06f999ce1b49aa0440c9125071ea5a3f9b19555bfff37a3c492dd5dedad1049c28e261d6708f2f5d2ab28a13ad7de19f6838bcfd45aa513ad0cf08d");
  });

  test('Test rsaPublicKeyExponentToBytes', () {
    RSAPublicKey key = X509Utils.publicKeyFromPem(publicKey);
    Uint8List bytes = X509Utils.rsaPublicKeyExponentToBytes(key);
    String hexString = hex.encode(bytes);
    expect(hexString, "010001");
  });

  test('Test rsaPrivateKeyModulusToBytes', () {
    RSAPrivateKey key = X509Utils.privateKeyFromPem(privateKey);
    Uint8List bytes = X509Utils.rsaPrivateKeyModulusToBytes(key);
    String hexString = hex.encode(bytes);
    expect(hexString,
        "65ac4bbaeaf35ce6882730cbf51268b97dee6e4a5e1366a81c234e797bd7c9bb0f7ecae791202deeac4237849ee5cd062f7f5e87c272bca75510585ee59f546960f9c3de08d91f848ab036b66ca4e0afc9431ebc91ecd04b9d4d52c9dc06352eaaf923fee8dc7eb69b4fc7de5e9f40368e0eae0d4be7cb6d3d26ae072096ea715146caac773a85fcad5412808e77059281ab43acc3589c2fc1e4d4b50a55e565ed75c0ca4c7c5c51697f31896a02158379dc362a00f84ef5936d694d6e2de34c04817a0ac4bcad9519bbf57ba454159b076e984d030c8f5b4c0b215ed96e0ce8b9b9c78c4a89d06df90d96d4dfd8f4b176c4bf2c8ae2d5fd902a00ca7bf805d1");
  });

  test('Test x509CertificateFromPem', () {
    X509CertificateData data = X509Utils.x509CertificateFromPem(x509Pem);
    expect(data.version, 2);

    expect(
        data.serialNumber.toString(), "14308724625219209600953969390500374777");

    expect(data.signatureAlgorithm, "1.2.840.113549.1.1.11");

    expect(data.issuer.containsKey("2.5.4.6"), true);
    expect(data.issuer["2.5.4.6"], "US");
    expect(data.issuer.containsKey("2.5.4.10"), true);
    expect(data.issuer["2.5.4.10"], "DigiCert Inc");
    expect(data.issuer.containsKey("2.5.4.11"), true);
    expect(data.issuer["2.5.4.11"], "www.digicert.com");
    expect(data.issuer.containsKey("2.5.4.3"), true);
    expect(data.issuer["2.5.4.3"], "Encryption Everywhere DV TLS CA - G1");

    expect(
        data.validity.notBefore.toIso8601String(), "2019-10-16T00:00:00.000Z");
    expect(
        data.validity.notAfter.toIso8601String(), "2020-10-16T12:00:00.000Z");

    expect(data.subject.containsKey("2.5.4.3"), true);
    expect(data.subject["2.5.4.3"], "junkdragons.de");
  });

  ///
  /// This test may fail in the future!
  ///
  test('Test fetchCertificate', () async {
    X509CertificateData data =
        await X509Utils.fetchCertificate(Uri.parse("http://google.de"));

    expect(data, null);

    data = await X509Utils.fetchCertificate(Uri.parse("https://google.de"));

    expect(data.version, 2);

    expect(data.issuer.containsKey("2.5.4.6"), true);
    expect(data.issuer["2.5.4.6"], "US");
    expect(data.issuer.containsKey("2.5.4.10"), true);
    expect(data.issuer["2.5.4.10"], "Google Trust Services");
    expect(data.issuer.containsKey("2.5.4.3"), true);
    expect(data.issuer["2.5.4.3"], "GTS CA 1O1");

    expect(data.subject.containsKey("2.5.4.6"), true);
    expect(data.subject["2.5.4.6"], "US");
    expect(data.subject.containsKey("2.5.4.8"), true);
    expect(data.subject["2.5.4.8"], "California");
    expect(data.subject.containsKey("2.5.4.7"), true);
    expect(data.subject["2.5.4.7"], "Mountain View");
    expect(data.subject.containsKey("2.5.4.10"), true);
    expect(data.subject["2.5.4.10"], "Google LLC");
    expect(data.subject.containsKey("2.5.4.3"), true);
    expect(data.subject["2.5.4.3"], "www.google.de");
  });
}
