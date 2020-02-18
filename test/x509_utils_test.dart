import 'dart:convert';

import 'package:asn1lib/asn1lib.dart';
import 'package:basic_utils/src/X509Utils.dart';
import 'package:pointycastle/impl.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';
import 'package:convert/convert.dart';

void main() {
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

  var csr = '''-----BEGIN CERTIFICATE REQUEST-----
MIICvzCCAacCAQAwejELMAkGA1UEBhMCREUxEjAQBgNVBAgMCUZha2VzdGF0ZTER
MA8GA1UEBwwIRmFrZXRvd24xEzARBgNVBAoMCkVwaGVub2Ryb20xFTATBgNVBAsM
DERldmVsb3BlbWVudDEYMBYGA1UEAwwPYmFzaWMtdXRpbHMuZGV2MIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0QX4e8oAKpD91eKKLL/EdrH02N/Ulg35
bdCJSozHubnoDG7ZXiELTFuPDANNmG4HmxVUpHv1uxmVrbzECnqBBEzjLW5NaW2T
9U74ACo23HmDFQJqiTF/aVFcfEzKwHXtZeVVCrXU5MEvnFjDrEOrgZIFd46AElSt
/IU6d6zKRlFx6pYgB64mPW3L50sNrg6ONkCfXt7HT5u2ftzo/iP5qi41BtzJUk2d
S9DskbweQ8mv4KRstjawioQf2Qjew/lgaVSf5V5YEFWnvHLCh15/LwbN5Z6EN0Ks
7i0gkefKfg+7ydd7eU4jHKhmE15Kbu59uWgS9cswJ4jmXPPqukusZQIDAQABoAAw
DQYJKoZIhvcNAQELBQADggEBAMLfJml1DbYOnUA7Nwlutk6suMmS0FDkQLXFiJQk
Ks5Fy6rfNtV1Z8KL/xGqAzyAcuAXL+0cQMZRsNTd9sT5ZriSzoikwaeIKOoRqhFq
bKXqlhYSbgmVUiYKm9HI3w+rzyZ+JXhiRXZ1ZGZXwEjBSu+Ne+SPE12mYlK+4zBx
gPTDMrvb73QiqHqiGc/l5UjwFyrOUsq5GtiMc6QU+rAQjj6Ix6KqOzJIxyVdRzOC
c47tT30d2tJEJbDHGutbqLQFRr7xx7uHP/LGggTFN8Zs2u+cQxPRFsIhQdpDY1MF
tHAaI8r/tlZQWf3fu4FVZMbxrYTMA5cwz/TxweMKWTroN5c=
-----END CERTIFICATE REQUEST-----''';

  var unformattedKey =
      'MIICvzCCAacCAQAwejELMAkGA1UEBhMCREUxEjAQBgNVBAgMCUZha2VzdGF0ZTERMA8GA1UEBwwIRmFrZXRvd24xEzARBgNVBAoMCkVwaGVub2Ryb20xFTATBgNVBAsMDERldmVsb3BlbWVudDEYMBYGA1UEAwwPYmFzaWMtdXRpbHMuZGV2MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0QX4e8oAKpD91eKKLL/EdrH02N/Ulg35bdCJSozHubnoDG7ZXiELTFuPDANNmG4HmxVUpHv1uxmVrbzECnqBBEzjLW5NaW2T9U74ACo23HmDFQJqiTF/aVFcfEzKwHXtZeVVCrXU5MEvnFjDrEOrgZIFd46AElSt/IU6d6zKRlFx6pYgB64mPW3L50sNrg6ONkCfXt7HT5u2ftzo/iP5qi41BtzJUk2dS9DskbweQ8mv4KRstjawioQf2Qjew/lgaVSf5V5YEFWnvHLCh15/LwbN5Z6EN0Ks7i0gkefKfg+7ydd7eU4jHKhmE15Kbu59uWgS9cswJ4jmXPPqukusZQIDAQABoAAwDQYJKoZIhvcNAQELBQADggEBAMLfJml1DbYOnUA7Nwlutk6suMmS0FDkQLXFiJQkKs5Fy6rfNtV1Z8KL/xGqAzyAcuAXL+0cQMZRsNTd9sT5ZriSzoikwaeIKOoRqhFqbKXqlhYSbgmVUiYKm9HI3w+rzyZ+JXhiRXZ1ZGZXwEjBSu+Ne+SPE12mYlK+4zBxgPTDMrvb73QiqHqiGc/l5UjwFyrOUsq5GtiMc6QU+rAQjj6Ix6KqOzJIxyVdRzOCc47tT30d2tJEJbDHGutbqLQFRr7xx7uHP/LGggTFN8Zs2u+cQxPRFsIhQdpDY1MFtHAaI8r/tlZQWf3fu4FVZMbxrYTMA5cwz/TxweMKWTroN5c=';

  var x509Pem = '''-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----''';

  var x509PemV1 = '''-----BEGIN CERTIFICATE-----
MIIEGjCCAwICEQCbfgZJoz5iudXukEhxKe9XMA0GCSqGSIb3DQEBBQUAMIHKMQsw
CQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZl
cmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAxOTk5IFZlcmlTaWdu
LCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBDBgNVBAMTPFZlcmlT
aWduIENsYXNzIDMgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3Jp
dHkgLSBHMzAeFw05OTEwMDEwMDAwMDBaFw0zNjA3MTYyMzU5NTlaMIHKMQswCQYD
VQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlT
aWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAxOTk5IFZlcmlTaWduLCBJ
bmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBDBgNVBAMTPFZlcmlTaWdu
IENsYXNzIDMgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkg
LSBHMzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMu6nFL8eB8aHm8b
N3O9+MlrlBIwT/A2R/XQkQr1F8ilYcEWQE37imGQ5XYgwREGfassbqb1EUGO+i2t
KmFZpGcmTNDovFJbcCAEWNF6yaRpvIMXZK0Fi7zQWM6NjPXr8EJJC52XJ2cybuGu
kxUccLwgTS8Y3pKI6GyFVxEa6X7jJhFUokWWVYPKMIno3Nij7SqAP395ZVc+FSBm
CC+Vk7+qRy+oRpfwEuL+wgorUeZ25rdGt+INpsyow0xZVYnm6FNcHOqd8GIWC6fJ
Xwzw3sJ2zq/3avL6QaaiMxTJ5Xpj055iN9WFZZ4O5lMkdBteHRJTW8cs54NJOxWu
imi5V5cCAwEAATANBgkqhkiG9w0BAQUFAAOCAQEAERSWwauSCPc/L8my/uRan2Te
2yFPhpk0djZX3dAVL8WtfxUfN2JzPtTnX84XA9s1+ivbrmAJXx5fj267Cz3qWhMe
DGBvtcC1IyIuBwvLqXTLR7sdwdela8wv0kL9Sd2nic9TutoAWii/gt/4uhMdUIaC
/Y4wjylGsB49Ndo4YhYYSq3mtlFs3q9i6wHQHiT+eo8SGhJouPtmmRQURVyu565p
F4ErWjfJXir0xuKhXFSbplQAz/DxwceYMBo7Nhbbo27q/a2ywtrvAkcTisDxszGt
TxzhT5yvDwyd93gN2PQ1VoDat20Xj50egWTh/sVFuq1ruQp6Tk9LhO5L8X3dEQ==
-----END CERTIFICATE-----''';

  var x509PemWithGeneralizedTime = '''-----BEGIN CERTIFICATE-----
MIIEAzCCAuugAwIBAgIQVID5oHPtPwBMyonY43HmSjANBgkqhkiG9w0BAQUFADB1
MQswCQYDVQQGEwJFRTEiMCAGA1UECgwZQVMgU2VydGlmaXRzZWVyaW1pc2tlc2t1
czEoMCYGA1UEAwwfRUUgQ2VydGlmaWNhdGlvbiBDZW50cmUgUm9vdCBDQTEYMBYG
CSqGSIb3DQEJARYJcGtpQHNrLmVlMCIYDzIwMTAxMDMwMTAxMDMwWhgPMjAzMDEy
MTcyMzU5NTlaMHUxCzAJBgNVBAYTAkVFMSIwIAYDVQQKDBlBUyBTZXJ0aWZpdHNl
ZXJpbWlza2Vza3VzMSgwJgYDVQQDDB9FRSBDZXJ0aWZpY2F0aW9uIENlbnRyZSBS
b290IENBMRgwFgYJKoZIhvcNAQkBFglwa2lAc2suZWUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDIIMDs4MVLqwd4lfNE7vsLDP90jmG7sWLqI9iroWUy
euuOF0+W2Ap7kaJjbMeMTC55v6kF/GlclY1i+blw7cNRfdCT5mzrMEvhvH2/UpvO
bntl8jixwKIy72KyaOBhU8E2lf/slLo2rpwcpzIP5Xy0xm90/XsY6KxX7QYgSzIw
WFv9zajmofxwvI6Sc9uXp3whrj3B9UiHbCe9nyV0gVWw93X2PaRka9ZP585ArQ/d
MtO8ihJTmMmJ+xAdTX7Nfh9WDSFwhfYggx/2uh8Ej+p3iDXE/+pOoYtNP2MbRMNE
1CV2yreN1x5KZmTNXMWcg+HCCIia7E6j8T4cLNlsHaFLAgMBAAGjgYowgYcwDwYD
VR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFBLyWj7qVhy/
zQas8fElyalL1BSZMEUGA1UdJQQ+MDwGCCsGAQUFBwMCBggrBgEFBQcDAQYIKwYB
BQUHAwMGCCsGAQUFBwMEBggrBgEFBQcDCAYIKwYBBQUHAwkwDQYJKoZIhvcNAQEF
BQADggEBAHv25MANqhlHt01Xo/6tu7Fq1Q+e2+RjxY6hUFaTlrg4wCQiZrxTFGGV
v9DHKpY5P30osxBAIWrEr7BSdxjhlthWXePdNl4dp1BUoMUq5KqMlIpPnTX/dqQG
E5Gion0ARD9V04I8GtVbvFZMIi5GQ4okQC3zErg7cBqklrkar4dBGmoYDQZPxz5u
uSlNDUmJEYcyW+ZLBMjkXOZ0c5RdFpgTlf7727FE5TpwrDdr5rMzcijJs1eg9gIW
iAYLtqZLICjU3j2LrTcFU3T+bsy8QxdxXvnFzBqpYe73dgzzcvRyrc9yAjYHR8/v
GVCJYMzpJJUPwssd8m92kMfMdcGWxZ0=
-----END CERTIFICATE-----''';

  var X509WithSans = '''-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----''';

  var X509WithIpSans = '''-----BEGIN CERTIFICATE-----
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
h9vE3e4Cq0OS3DA=
-----END CERTIFICATE-----''';

  test('Test getBytesFromPEMString', () {
    var bytes = X509Utils.getBytesFromPEMString(csr);
    var formatted = X509Utils.formatKeyString(
        base64Encode(bytes), X509Utils.BEGIN_CSR, X509Utils.END_CSR);
    expect(formatted, csr);
  });

  test('Test formatKeyString', () {
    var formatted = X509Utils.formatKeyString(
        unformattedKey, X509Utils.BEGIN_CSR, X509Utils.END_CSR);
    expect(formatted, csr);
  });

  test('Test encodeDN', () {
    var dn = {
      'CN': 'basic-utils.dev',
      'O': 'Magic Company',
      'L': 'Fakecity',
      'S': 'FakeState',
      'C': 'DE',
    };
    ASN1Sequence object = X509Utils.encodeDN(dn);
    expect(object.elements.length, 5);
  });

  test('Test privateKeyFromPem', () {
    var object = X509Utils.privateKeyFromPem(privateKey);
    expect(object.n.bitLength, 2048);
  });

  test('Test publicKeyFromPem', () {
    var object = X509Utils.publicKeyFromPem(publicKey);
    expect(object.n.bitLength, 2048);
  });

  test('Test privateKeyFromDERBytes', () {
    var bytes = X509Utils.getBytesFromPEMString(privateKey);
    var object = X509Utils.privateKeyFromDERBytes(bytes);
    expect(object.n.bitLength, 2048);
  });

  test('Test privateKeyFromASN1Sequence', () {
    var bytes = X509Utils.getBytesFromPEMString(privateKey);
    ASN1Sequence asn = ASN1Parser(bytes).nextObject();
    var objects = asn.elements;
    ASN1OctetString string = objects[2];
    var object = X509Utils.privateKeyFromASN1Sequence(
        ASN1Parser(string.contentBytes()).nextObject());
    expect(object.n.bitLength, 2048);
  });

  test('Test encodeRSAPrivateKeyToPem', () {
    var object = X509Utils.privateKeyFromPem(privateKey);
    var pem = X509Utils.encodeRSAPrivateKeyToPem(object);
    expect(pem, privateKey);
  });

  test('Test encodeASN1ObjectToPem', () {
    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(ASN1Integer(BigInt.from(0)));
    var pem = X509Utils.encodeASN1ObjectToPem(
        topLevelSeq, '-----BEGIN PUBLIC KEY-----', '-----END PUBLIC KEY-----');
    expect(
        pem, '-----BEGIN PUBLIC KEY-----\nMAMCAQA=\n-----END PUBLIC KEY-----');
  });

  test('Test encodeRSAPublicKeyToPem', () {
    var pair = X509Utils.generateKeyPair();
    var pem = X509Utils.encodeRSAPublicKeyToPem(pair.publicKey);
    expect(pem.startsWith('-----BEGIN PUBLIC KEY-----'), true);
    expect(pem.endsWith('-----END PUBLIC KEY-----'), true);
  });

  test('Test generateRsaCsrPem', () {
    var pair = X509Utils.generateKeyPair();
    var dn = {
      'CN': 'basic-utils.dev',
      'O': 'Magic Company',
      'L': 'Fakecity',
      'S': 'FakeState',
      'C': 'DE',
    };
    var csr = X509Utils.generateRsaCsrPem(dn, pair.privateKey, pair.publicKey);
    var bytes = X509Utils.getBytesFromPEMString(csr);
    var sequence = ASN1Sequence.fromBytes(bytes);
    ASN1Sequence e1 = sequence.elements.elementAt(0);
    ASN1Sequence e2 = e1.elements.elementAt(1);
    ASN1Set e3 = e2.elements.elementAt(0);
    ASN1Sequence e4 = e3.elements.elementAt(0);
    ASN1UTF8String e5 = e4.elements.elementAt(1);
    var cn = e5.utf8StringValue;
    expect(cn, 'basic-utils.dev');
  });

  test('Test generateKeyPair', () {
    var pair = X509Utils.generateKeyPair();
    RSAPrivateKey private = pair.privateKey;
    RSAPublicKey public = pair.publicKey;
    expect(private.n.bitLength, 2048);
    expect(public.n.bitLength, 2048);
  });

  test('Test rsaPublicKeyModulusToBytes', () {
    var key = X509Utils.publicKeyFromPem(publicKey);
    var bytes = X509Utils.rsaPublicKeyModulusToBytes(key);
    var hexString = hex.encode(bytes);
    expect(hexString,
        'c7ffc783db5dc3517aa8566448460a6b337fd3ab2e90718af3c01c7d7f893552692a0954c2ca3aa191883d39dc75887fa8120be7e28d62173d711ba05c105c012098a510c16f0cccd6dca80becef1f117e00aa24efcb0b76fe780e52cfa62ec10184ff6a019131590a8356a9fa659625435b81e0ddb12a48467a2b680e9443d5661bcfe8df5cd4057a91953f67ea59bd7f1b505abf39e0e3bbd18c9d4814c22457874d4709363084f54ffa01118b344a5398713aa5fa9b24636c5e10399c57a8cb3734cea06f999ce1b49aa0440c9125071ea5a3f9b19555bfff37a3c492dd5dedad1049c28e261d6708f2f5d2ab28a13ad7de19f6838bcfd45aa513ad0cf08d');
  });

  test('Test rsaPublicKeyExponentToBytes', () {
    var key = X509Utils.publicKeyFromPem(publicKey);
    var bytes = X509Utils.rsaPublicKeyExponentToBytes(key);
    var hexString = hex.encode(bytes);
    expect(hexString, '010001');
  });

  test('Test rsaPrivateKeyModulusToBytes', () {
    var key = X509Utils.privateKeyFromPem(privateKey);
    var bytes = X509Utils.rsaPrivateKeyModulusToBytes(key);
    var hexString = hex.encode(bytes);
    expect(hexString,
        '65ac4bbaeaf35ce6882730cbf51268b97dee6e4a5e1366a81c234e797bd7c9bb0f7ecae791202deeac4237849ee5cd062f7f5e87c272bca75510585ee59f546960f9c3de08d91f848ab036b66ca4e0afc9431ebc91ecd04b9d4d52c9dc06352eaaf923fee8dc7eb69b4fc7de5e9f40368e0eae0d4be7cb6d3d26ae072096ea715146caac773a85fcad5412808e77059281ab43acc3589c2fc1e4d4b50a55e565ed75c0ca4c7c5c51697f31896a02158379dc362a00f84ef5936d694d6e2de34c04817a0ac4bcad9519bbf57ba454159b076e984d030c8f5b4c0b215ed96e0ce8b9b9c78c4a89d06df90d96d4dfd8f4b176c4bf2c8ae2d5fd902a00ca7bf805d1');
  });

  test('Test x509CertificateFromPem', () {
    var data = X509Utils.x509CertificateFromPem(x509Pem);
    expect(data.version, 2);

    expect(
        data.serialNumber.toString(), '9419718410412351084484106081643920776');

    expect(data.signatureAlgorithm, '1.2.840.113549.1.1.11');

    expect(data.issuer.containsKey('2.5.4.6'), true);
    expect(data.issuer['2.5.4.6'], 'US');
    expect(data.issuer.containsKey('2.5.4.10'), true);
    expect(data.issuer['2.5.4.10'], 'OEM Test');
    expect(data.issuer.containsKey('2.5.4.3'), true);
    expect(data.issuer['2.5.4.3'], 'Full OEM Test RSA Sub');

    expect(
        data.validity.notBefore.toIso8601String(), '2019-03-11T00:00:00.000Z');
    expect(
        data.validity.notAfter.toIso8601String(), '2020-03-10T12:00:00.000Z');

    expect(data.subject.containsKey('2.5.4.3'), true);
    expect(data.subject['2.5.4.3'], 'junkdragons.de');

    expect(data.sha1Thumbprint, '1F6254CEDA7E9E9AEBF8B687BDFB5CC03AD1B3E7');
    expect(data.md5Thumbprint, '4CBED02D6CF2F161540A3177A55F94F6');

    var publicKeyData = data.publicKeyData;

    expect(publicKeyData.length, 2048);
    expect(publicKeyData.sha1Thumbprint,
        'EEBEB3DA65F238F829F0977BBF409395099704CB');
    expect(publicKeyData.algorithm, '1.2.840.113549.1.1.1');
    expect(publicKeyData.bytes,
        '3082010A0282010100C31AFEFEDA8432456BC502DED4C6D010241EB36A37A0CEB96F2CB678F8F86126DEB06920D6E883D5EC7E2E22F80BDDC1CFEBC02401397ED9F5B40843F2DA2DEF3B6ED50EDC4CA76A1393F21D3ED55B36D641B2378588D573AFB65A0FACF4BB8D562C441B477E029A559B820CDADD24B4B6F3D70F4D982690F3FD09B8DE1CF49BE489D0869EB0033B6F5B536E6942C60DEB9BE095894F704EC23D794BCE099223292DC4DCC55C449653082699329F0930A72D01EE01F7446E9C66E9BEC62F5A8E16E1440C142558719A78EC515E59C527AB1D379EB49D3F72C410F71E3D5B11C4F781A6DB19CDBCBD59FED273650DCD36521A3CF196922D81776C8CBE07891FD50203010001');

    var sans = data.subjectAlternativNames;
    expect(sans.length, 3);
    expect(sans.elementAt(0), 'junkdragons.de');
    expect(sans.elementAt(1), 'www.junkdragons.de');
    expect(sans.elementAt(2), 'api.junkdragons.de');
  });

  test('Test x509CertificateFromPem with IP Sans', () {
    var data = X509Utils.x509CertificateFromPem(X509WithSans);
    var sans = data.subjectAlternativNames;
    expect(sans.length, 2);
    expect(sans.elementAt(0), 'api.ephenodrom.de');
    expect(sans.elementAt(1), '192.168.0.1');

    data = X509Utils.x509CertificateFromPem(X509WithIpSans);
    sans = data.subjectAlternativNames;
    expect(sans.length, 2);
    expect(sans.elementAt(0), '127.0.0.1');
    expect(sans.elementAt(1), '0.0.0.0');
  });

  test('Test x509CertificateFromPem with V1 X509', () {
    var data = X509Utils.x509CertificateFromPem(x509PemV1);
    expect(data.version, 1);

    expect(data.serialNumber.toString(),
        '206684696279472310254277870180966723415');

    expect(data.signatureAlgorithm, '1.2.840.113549.1.1.5');

    expect(data.issuer.containsKey('2.5.4.6'), true);
    expect(data.issuer['2.5.4.6'], 'US');
    expect(data.issuer.containsKey('2.5.4.10'), true);
    expect(data.issuer['2.5.4.10'], 'VeriSign, Inc.');
    expect(data.issuer.containsKey('2.5.4.3'), true);
    expect(data.issuer['2.5.4.3'],
        'VeriSign Class 3 Public Primary Certification Authority - G3');

    expect(
        data.validity.notBefore.toIso8601String(), '1999-10-01T00:00:00.000Z');
    expect(
        data.validity.notAfter.toIso8601String(), '2036-07-16T23:59:59.000Z');

    expect(data.subject.containsKey('2.5.4.3'), true);
    expect(data.subject['2.5.4.3'],
        'VeriSign Class 3 Public Primary Certification Authority - G3');

    expect(data.sha1Thumbprint, '132D0D45534B6997CDB2D5C339E25576609B5CC6');
    expect(data.md5Thumbprint, 'CD68B6A7C7C4CE75E01D4F5744619209');

    var publicKeyData = data.publicKeyData;

    expect(publicKeyData.length, 2048);
    expect(publicKeyData.sha1Thumbprint,
        '22F19E2EC6EACCFC5D2346F4C2E8F6C554DD5E07');
    expect(publicKeyData.algorithm, '1.2.840.113549.1.1.1');
    expect(publicKeyData.bytes,
        '3082010A0282010100CBBA9C52FC781F1A1E6F1B3773BDF8C96B9412304FF03647F5D0910AF517C8A561C116404DFB8A6190E57620C111067DAB2C6EA6F511418EFA2DAD2A6159A467264CD0E8BC525B70200458D17AC9A469BC831764AD058BBCD058CE8D8CF5EBF042490B9D972767326EE1AE93151C70BC204D2F18DE9288E86C8557111AE97EE3261154A245965583CA3089E8DCD8A3ED2A803F7F7965573E152066082F9593BFAA472FA84697F012E2FEC20A2B51E676E6B746B7E20DA6CCA8C34C595589E6E8535C1CEA9DF062160BA7C95F0CF0DEC276CEAFF76AF2FA41A6A23314C9E57A63D39E6237D585659E0EE65324741B5E1D12535BC72CE783493B15AE8A68B957970203010001');
  });

  test('Test x509CertificateFromPem with GeneralizedTime', () {
    var data = X509Utils.x509CertificateFromPem(x509PemWithGeneralizedTime);
    expect(data.version, 2);

    expect(data.serialNumber.toString(),
        '112324828676200291871926431888494945866');

    expect(data.signatureAlgorithm, '1.2.840.113549.1.1.5');

    expect(data.issuer.containsKey('2.5.4.6'), true);
    expect(data.issuer['2.5.4.6'], 'EE');
    expect(data.issuer.containsKey('2.5.4.10'), true);
    expect(data.issuer['2.5.4.10'], 'AS Sertifitseerimiskeskus');
    expect(data.issuer.containsKey('2.5.4.3'), true);
    expect(data.issuer['2.5.4.3'], 'EE Certification Centre Root CA');

    expect(
        data.validity.notBefore.toIso8601String(), '2010-10-30T10:10:30.000Z');
    expect(
        data.validity.notAfter.toIso8601String(), '2030-12-17T23:59:59.000Z');

    expect(data.subject.containsKey('2.5.4.3'), true);
    expect(data.subject['2.5.4.3'], 'EE Certification Centre Root CA');

    expect(data.sha1Thumbprint, 'C9A8B9E755805E58E35377A725EBAFC37B27CCD7');
    expect(data.md5Thumbprint, '435E88D47D1A4A7EFD842E52EB01D46F');

    var publicKeyData = data.publicKeyData;

    expect(publicKeyData.length, 2048);
    expect(publicKeyData.sha1Thumbprint,
        '30B8B08C3E820AD83B4F1F891EAB29C29C49E937');
    expect(publicKeyData.algorithm, '1.2.840.113549.1.1.1');
    expect(publicKeyData.bytes,
        '3082010A0282010100C820C0ECE0C54BAB077895F344EEFB0B0CFF748E61BBB162EA23D8ABA165327AEB8E174F96D80A7B91A2636CC78C4C2E79BFA905FC695C958D62F9B970EDC3517DD093E66CEB304BE1BC7DBF529BCE6E7B65F238B1C0A232EF62B268E06153C13695FFEC94BA36AE9C1CA7320FE57CB4C66F74FD7B18E8AC57ED06204B3230585BFDCDA8E6A1FC70BC8E9273DB97A77C21AE3DC1F548876C27BD9F25748155B0F775F63DA4646BD64FE7CE40AD0FDD32D3BC8A125398C989FB101D4D7ECD7E1F560D217085F620831FF6BA1F048FEA778835C4FFEA4EA18B4D3F631B44C344D42576CAB78DD71E4A6664CD5CC59C83E1C208889AEC4EA3F13E1C2CD96C1DA14B0203010001');
  });
}
