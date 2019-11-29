import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:basic_utils/src/X509Utils.dart';
import 'package:basic_utils/src/model/x509/X509CertificateData.dart';
import 'package:basic_utils/src/model/x509/X509CertificatePublicKeyData.dart';
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

  String x509Pem = """-----BEGIN CERTIFICATE-----
MIIFDTCCA/WgAwIBAgIQBxYr+XmB67PWzCkR7C39iDANBgkqhkiG9w0BAQsFADBA
MQswCQYDVQQGEwJVUzERMA8GA1UEChMIT0VNIFRlc3QxHjAcBgNVBAMTFUZ1bGwg
T0VNIFRlc3QgUlNBIFN1YjAeFw0xOTAzMTEwMDAwMDBaFw0yMDAzMTAxMjAwMDBa
MHsxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIEwZCYXllcm4xEzARBgNVBAcTClJlZ2Vu
c2J1cmcxFzAVBgNVBAoTDkludGVyTmV0WCBHbWJIMRQwEgYDVQQLEwtFbnR3aWNr
bHVuZzEXMBUGA1UEAxMOanVua2RyYWdvbnMuZGUwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDDGv7+2oQyRWvFAt7UxtAQJB6zajegzrlvLLZ4+PhhJt6w
aSDW6IPV7H4uIvgL3cHP68AkATl+2fW0CEPy2i3vO27VDtxMp2oTk/IdPtVbNtZB
sjeFiNVzr7ZaD6z0u41WLEQbR34CmlWbggza3SS0tvPXD02YJpDz/Qm43hz0m+SJ
0IaesAM7b1tTbmlCxg3rm+CViU9wTsI9eUvOCZIjKS3E3MVcRJZTCCaZMp8JMKct
Ae4B90RunGbpvsYvWo4W4UQMFCVYcZp47FFeWcUnqx03nrSdP3LEEPcePVsRxPeB
ptsZzby9Wf7Sc2UNzTZSGjzxlpItgXdsjL4HiR/VAgMBAAGjggHGMIIBwjAfBgNV
HSMEGDAWgBS8odGV3/ZO7g4f11MzIg9X66vlUjAdBgNVHQ4EFgQUTriCU/8x5yQN
BoQPPYQcUVL7FUIwQQYDVR0RBDowOIIOanVua2RyYWdvbnMuZGWCEnd3dy5qdW5r
ZHJhZ29ucy5kZYISYXBpLmp1bmtkcmFnb25zLmRlMA4GA1UdDwEB/wQEAwIFoDAd
BgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwPgYDVR0fBDcwNTAzoDGgL4Yt
aHR0cDovL2NkcC5yYXBpZHNzbC5jb20vRnVsbE9FTVRlc3RSU0FTdWIuY3JsMEwG
A1UdIARFMEMwNwYJYIZIAYb9bAEBMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3
LmRpZ2ljZXJ0LmNvbS9DUFMwCAYGZ4EMAQICMHUGCCsGAQUFBwEBBGkwZzAmBggr
BgEFBQcwAYYaaHR0cDovL3N0YXR1cy5yYXBpZHNzbC5jb20wPQYIKwYBBQUHMAKG
MWh0dHA6Ly9jYWNlcnRzLnJhcGlkc3NsLmNvbS9GdWxsT0VNVGVzdFJTQVN1Yi5j
cnQwCQYDVR0TBAIwADANBgkqhkiG9w0BAQsFAAOCAQEAwCJAiSMJSYCIrJZdcLmY
zgH/Hd6VUDQzuo/s8Q+UoqpwyPwGnmNpovvzfjtz2+bF0dCQwUWerm61kYF/3IU6
ucrdTW4uS+T11tipJgDUBU8jEHvASe+QNIP7BiNoXCs10SfI8FQajL0HxnHY0vKC
AAQiFStLngxNYduyz4C3ZUjeNjt/8NhCUhd2GZGA6gveHKvck47ZWFbblecH8Odw
nhzR+ztf+lSGoyQW+egNlPog/OLjr//kKx7kjuuvXa5Os8oPLENu6LAjTZJqGvJP
ga7IcCj2gCeuTdS4Ibhx3hiew7cfuGa9XbVd5JJmV8kIoFlzLrZpKB4eVDKqaNWg
/g==
-----END CERTIFICATE-----""";

  String X509WithSans = """-----BEGIN CERTIFICATE-----
MIIDsTCCApmgAwIBAgIUDmyV5Jod3FGoVStvzghkIs1xZTcwDQYJKoZIhvcNAQEL
BQAwajELMAkGA1UEBhMCREUxCzAJBgNVBAgMAkJZMQ0wCwYDVQQHDARDaXR5MRAw
DgYDVQQKDAdDb21wYW55MRUwEwYDVQQLDAxEZXZlbG9wZW1lbnQxFjAUBgNVBAMM
DWVwaGVub2Ryb20uZGUwHhcNMTkxMTI2MTA1MjMzWhcNMjExMTI1MTA1MjMzWjBq
MQswCQYDVQQGEwJERTELMAkGA1UECAwCQlkxDTALBgNVBAcMBENpdHkxEDAOBgNV
BAoMB0NvbXBhbnkxFTATBgNVBAsMDERldmVsb3BlbWVudDEWMBQGA1UEAwwNZXBo
ZW5vZHJvbS5kZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALkzNq/p
4YblpAyXOCZAsTgZau2NvmyJ/B4H4SgGC+A4sJCBRuhsiZTSxUHiF4Y1WkXPNIRJ
wxMU0BLCbpLP3QYJpXwQhRtVJB2I4BWybAS2zzV1s6x6XLJsuJUQxZXN4rBdSocN
+D9v4qsfaIIkN7CXnEmTFlzUh33YqL/lmCDZcIQe4HIGa7ElfgzMLEcDh60AsUrr
JSgIDGuAKfxRaZLYY1wpRm3sxkwSSGKYFZK/H34GDC3/PGqyLPxFHIeLRFwIlJH+
r/puvcKlot8dh3SCDgNGuzszbfN351Kdp01ZHVzoMLVMsC93hux/kfsBFPR7NSO2
tG9ClLZ23CdqcIcCAwEAAaNPME0wCwYDVR0PBAQDAgQwMBMGA1UdJQQMMAoGCCsG
AQUFBwMBMCkGA1UdEQQiMCCCEWFwaS5lcGhlbm9kcm9tLmRlggsxOTIuMTY4LjAu
MTANBgkqhkiG9w0BAQsFAAOCAQEALAS85yXzCcdpN2uPQIx9edN4/0sglP+hVEXA
XtWgjq8uYpPmSUdjPYMDQzg+A+zgLQc8FB2YK8bk/yuaDRZaRt8xhjaXQsRhrKf8
pAvj+Cwzy5Sn+L21a1xd+IJHVSh+B0xF8H7D9G2+KwG4GbEkwprDdCh/Ci39/5qg
eRnR3fZYB8vnirc4pJr8tOoZ3aKsdyFyBhozZNQETihW1vrzegs5/rQlLmSUwb3C
TQiUAMlBpzuKM6oCy833Ed+uCtCwGAj0unysv9o7pYv4dKW4REyBGQ0lJltpN3Cg
MrWLubLgMfDzQmOC3oOeNVBDUsQBdFwJwqEEO658U+/OsQYVlw==
-----END CERTIFICATE-----""";

  String X509WithIpSans = """-----BEGIN CERTIFICATE-----
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
h9vE3e4Cq0OS3DA=
-----END CERTIFICATE-----""";

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
    ASN1Sequence topLevelSeq = ASN1Sequence();
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
        data.serialNumber.toString(), "9419718410412351084484106081643920776");

    expect(data.signatureAlgorithm, "1.2.840.113549.1.1.11");

    expect(data.issuer.containsKey("2.5.4.6"), true);
    expect(data.issuer["2.5.4.6"], "US");
    expect(data.issuer.containsKey("2.5.4.10"), true);
    expect(data.issuer["2.5.4.10"], "OEM Test");
    expect(data.issuer.containsKey("2.5.4.3"), true);
    expect(data.issuer["2.5.4.3"], "Full OEM Test RSA Sub");

    expect(
        data.validity.notBefore.toIso8601String(), "2019-03-11T00:00:00.000Z");
    expect(
        data.validity.notAfter.toIso8601String(), "2020-03-10T12:00:00.000Z");

    expect(data.subject.containsKey("2.5.4.3"), true);
    expect(data.subject["2.5.4.3"], "junkdragons.de");

    expect(data.sha1Thumbprint, "1F6254CEDA7E9E9AEBF8B687BDFB5CC03AD1B3E7");
    expect(data.md5Thumbprint, "4CBED02D6CF2F161540A3177A55F94F6");

    X509CertificatePublicKeyData publicKeyData = data.publicKeyData;

    expect(publicKeyData.length, 2048);
    expect(publicKeyData.sha1Thumbprint,
        "EEBEB3DA65F238F829F0977BBF409395099704CB");
    expect(publicKeyData.algorithm, "1.2.840.113549.1.1.1");
    expect(publicKeyData.bytes,
        "3082010A0282010100C31AFEFEDA8432456BC502DED4C6D010241EB36A37A0CEB96F2CB678F8F86126DEB06920D6E883D5EC7E2E22F80BDDC1CFEBC02401397ED9F5B40843F2DA2DEF3B6ED50EDC4CA76A1393F21D3ED55B36D641B2378588D573AFB65A0FACF4BB8D562C441B477E029A559B820CDADD24B4B6F3D70F4D982690F3FD09B8DE1CF49BE489D0869EB0033B6F5B536E6942C60DEB9BE095894F704EC23D794BCE099223292DC4DCC55C449653082699329F0930A72D01EE01F7446E9C66E9BEC62F5A8E16E1440C142558719A78EC515E59C527AB1D379EB49D3F72C410F71E3D5B11C4F781A6DB19CDBCBD59FED273650DCD36521A3CF196922D81776C8CBE07891FD50203010001");

    List<String> sans = data.subjectAlternativNames;
    expect(sans.length, 3);
    expect(sans.elementAt(0), "junkdragons.de");
    expect(sans.elementAt(1), "www.junkdragons.de");
    expect(sans.elementAt(2), "api.junkdragons.de");
  });

  test('Test x509CertificateFromPem with IP Sans', () {
    X509CertificateData data = X509Utils.x509CertificateFromPem(X509WithSans);
    List<String> sans = data.subjectAlternativNames;
    expect(sans.length, 2);
    expect(sans.elementAt(0), "api.ephenodrom.de");
    expect(sans.elementAt(1), "192.168.0.1");

    data = X509Utils.x509CertificateFromPem(X509WithIpSans);
    sans = data.subjectAlternativNames;
    expect(sans.length, 2);
    expect(sans.elementAt(0), "127.0.0.1");
    expect(sans.elementAt(1), "0.0.0.0");
  });
}
