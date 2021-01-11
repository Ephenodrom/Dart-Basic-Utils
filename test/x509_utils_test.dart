import 'dart:convert';

import 'package:basic_utils/src/X509Utils.dart';
import 'package:pointycastle/impl.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/src/CryptoUtils.dart';

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

  var x509PemWithTeletextString = '''-----BEGIN CERTIFICATE-----
MIIEKjCCAxKgAwIBAgIEOGPe+DANBgkqhkiG9w0BAQUFADCBtDEUMBIGA1UEChML
RW50cnVzdC5uZXQxQDA+BgNVBAsUN3d3dy5lbnRydXN0Lm5ldC9DUFNfMjA0OCBp
bmNvcnAuIGJ5IHJlZi4gKGxpbWl0cyBsaWFiLikxJTAjBgNVBAsTHChjKSAxOTk5
IEVudHJ1c3QubmV0IExpbWl0ZWQxMzAxBgNVBAMTKkVudHJ1c3QubmV0IENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5ICgyMDQ4KTAeFw05OTEyMjQxNzUwNTFaFw0yOTA3
MjQxNDE1MTJaMIG0MRQwEgYDVQQKEwtFbnRydXN0Lm5ldDFAMD4GA1UECxQ3d3d3
LmVudHJ1c3QubmV0L0NQU18yMDQ4IGluY29ycC4gYnkgcmVmLiAobGltaXRzIGxp
YWIuKTElMCMGA1UECxMcKGMpIDE5OTkgRW50cnVzdC5uZXQgTGltaXRlZDEzMDEG
A1UEAxMqRW50cnVzdC5uZXQgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgKDIwNDgp
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArU1LqRKGsuqjIAcVFmQq
K0vRvwtKTY7tgHalZ7d4QMBzQshowNtTK91euHaYNZOLGp18EzoOH1u3Hs/lJBQe
sYGpjX24zGtLA/ECDNyrpUAkAH90lKGdCCmziAv1h3edVc3kw37XamSrhRSGlVuX
MlBvPci6Zgzj/L24ScF2iUkZ/cCovYmjZy/Gn7xxGWC4LeksyZB2ZnuU4q941mVT
XTzWnLLPKQP5L6RQstRIzgUyVYr9smRMDuSYB3Xbf9+5CFVghTAp+XtIpGmG4zU/
HoZdenoVve8AjhUiVBcAkCaTvA5JaJG/+EfTnZVCwQ5N328mz8MYIWJmQ3DW1cAH
4QIDAQABo0IwQDAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNV
HQ4EFgQUVeSB0RGAvtiJuQijMfmhJAkWuXAwDQYJKoZIhvcNAQEFBQADggEBADub
j1abMOdTmXx6eadNl9cZlZD7Bh/KM3xGY4+WZiT6QBshJ8rmcnPyT/4xmf3IDExo
U8aAghOY+rat2l098c5u9hURlIIM7j+VrxGrD9cv3h8Dj1csHsm7mhpElesYT6Yf
zX1XEC+bBAlahLVu2B064dae0Wx5XnkcFMXj0EyTO2U87d89vqbllRrDtRnDvV5b
u/8j72gZyxKTJ1wDLW8w0B62GqzeWvfRqqgnpv55gcR5mTNXuhKwqeBCbJPKVt7+
bYQLCIt+jerXmCHG8+c8eS9enNFMFY3h7CI3zJpDC5fcgJCNs2ebb0gIFVbPv/Er
fF6adulZkMV8gzURZVE=
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

  var certWithoutCN = '''-----BEGIN CERTIFICATE-----
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
8UhhGUUcPT6NuTN1LY7k+wvsdcRayEU=
-----END CERTIFICATE-----''';

  var selfSigned = '''-----BEGIN CERTIFICATE-----
MIID7TCCAtWgAwIBAgIBCjANBgkqhkiG9w0BAQsFADCBujELMAkGA1UEBhMCUlUx
FjAUBgNVBAgMDU1vc2NvdyBPYmxhc3QxEDAOBgNVBAcMB0tvcm9sZXYxJTAjBgNV
BAoMHEhpa3Zpc2lvbiBEaWdpdGFsIFRlY2hub2xvZ3kxFjAUBgNVBAMMDTk0LjE5
OC4xMzEuNTUxGTAXBgNVBAsMEEhpa3Zpc2lvbiBSdXNzaWExJzAlBgkqhkiG9w0B
CQEWGHN1cHBvcnQucnVAaGlrdmlzaW9uLmNvbTAeFw0yMDExMTUwOTAwMThaFw0z
MDExMTUwOTAwMThaMIG6MQswCQYDVQQGEwJSVTEWMBQGA1UECAwNTW9zY293IE9i
bGFzdDEQMA4GA1UEBwwHS29yb2xldjElMCMGA1UECgwcSGlrdmlzaW9uIERpZ2l0
YWwgVGVjaG5vbG9neTEWMBQGA1UEAwwNOTQuMTk4LjEzMS41NTEZMBcGA1UECwwQ
SGlrdmlzaW9uIFJ1c3NpYTEnMCUGCSqGSIb3DQEJARYYc3VwcG9ydC5ydUBoaWt2
aXNpb24uY29tMIIBIDANBgkqhkiG9w0BAQEFAAOCAQ0AMIIBCAKCAQEA2OHq1U7I
UvX+DQloekW1f+moc9BX6ogOG6lS1EfZ4jBQCZ5zDhLxhCAcaICa30jHlHtcWNMw
9AkFQi19CmngxU+c4nw8elLn8QMA4gHBDOdPlLMH5jx7r0L9qZLxZ5zN/U2QpJbz
8tFRBI4U/L8Kiypy1VHg36MSOGhrPtjMu4s2Cl9Pmz+HG/9Gun4nyH6rLsh9YnMk
gkMYNNDsoXAQ2XlM6D8Obw0GWibYOl4aNU4Z5DAPeyokPR1D1RaoH9lu3nH2JaoZ
5dOfJwrUchSUEwD/a0VGVMbVnK1HN99ZEfQVhzFvhyserYXxryhvk8xhVGs1BLZF
gulrh83aWFTltQIBAzANBgkqhkiG9w0BAQsFAAOCAQEADE9QYRIrqDZzqZwElDiI
yQdqGtouhz3Hxp/2oR5e0S/Zv+SyJCN5TWaFrnSKeYUNgoWpd4HwYaZ91+OKr4pg
pC3GyaocUthbg8Z1CSjJvLlBg4yyJ3ydANmx7Wf5luokItsTHdLX3j4JLlV97I4u
ue9WtHfK9LZqplDg2foDreC2ZXLXi7CaPCaxMyizIXxqekkPmyXK1AJDXxLXs/Eq
dj4aM+vWzHutpNb6bhzzgQALeAYOpI7akiJhjh7oHrhqiP7f1o+MVtJHNiRFy8em
HqE2zJz1wkcCwanxmQ4Sc+BQxIUXwsbq2tuknKfvOfaTSD226yn65C73cLKv97tr
yA==
-----END CERTIFICATE-----''';

  var bigCert = '''-----BEGIN CERTIFICATE-----
MIIG/jCCBeagAwIBAgIRAOwUGsZYjUIAP+uYrlVr+vUwDQYJKoZIhvcNAQELBQAw
gZYxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTwwOgYD
VQQDEzNDT01PRE8gUlNBIE9yZ2FuaXphdGlvbiBWYWxpZGF0aW9uIFNlY3VyZSBT
ZXJ2ZXIgQ0EwHhcNMTgwMjA2MDAwMDAwWhcNMjEwMjA1MjM1OTU5WjCB/jELMAkG
A1UEBhMCVVMxDjAMBgNVBBETBTgwMjAzMQswCQYDVQQIEwJDTzEPMA0GA1UEBxMG
RGVudmVyMRYwFAYDVQQJEw0xODAwIEdyYW50IFN0MR8wHQYDVQQKExZVbml2ZXJz
aXR5IG9mIENvbG9yYWRvMScwJQYDVQQLEx5Vbml2ZXJzaXR5IEluZm9ybWF0aW9u
IFN5c3RlbXMxKTAnBgNVBAsTIEhvc3RlZCBieSBVbml2ZXJzaXR5IG9mIENvbG9y
YWRvMR8wHQYDVQQLExZVbmlmaWVkIENvbW11bmljYXRpb25zMRMwEQYDVQQDEwp2
cG4uY3UuZWR1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxaJb/tXs
RwDzj9ZszdymD+2LokVGNDkhN0LZZ23qGd+1UgJCnmd+ix4DgzPKv78snT1yb7yR
W21R7BqqphEOB01ZNxsX22DB7Zr73W+U7auCCqt1naNmHYdJCx88z/EckCM8cJNq
OGKrf7kjkFAMUlezZczB6+aDNY8oVsFRM8ZEkSQgGDPGvrQh7qX3r8/6//IukE9T
UNMAyiWu0ZysjtKattgN0DK+9UC+CEhFvWyh+52WxRzbQ0z9HHAhKL9l51/0WXIo
3Q9Osxy70Qz7vS7QW2NCCH8/Ibqq5Sq/VzyZsWpzwI8TDzuAsJI/J2qmLNJIidNC
Dkhe7XZvKmNhpQIDAQABo4IC2zCCAtcwHwYDVR0jBBgwFoAUmvMr2s+tT7YvuypI
SCoStxtCwSQwHQYDVR0OBBYEFLeG9vInkf5jYD+G4wz6Nr/kqeRnMA4GA1UdDwEB
/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEF
BQcDAjBQBgNVHSAESTBHMDsGDCsGAQQBsjEBAgEDBDArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8uY29tL0NQUzAIBgZngQwBAgIwWgYDVR0fBFMw
UTBPoE2gS4ZJaHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPUlNBT3JnYW5p
emF0aW9uVmFsaWRhdGlvblNlY3VyZVNlcnZlckNBLmNybDCBiwYIKwYBBQUHAQEE
fzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9S
U0FPcmdhbml6YXRpb25WYWxpZGF0aW9uU2VjdXJlU2VydmVyQ0EuY3J0MCQGCCsG
AQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wggEaBgNVHREEggERMIIB
DYIKdnBuLmN1LmVkdYIScDAxdnBuLnByb2QuY3UuZWR1ghRwMDF2cG4wMS5wcm9k
LmN1LmVkdYIUcDAxdnBuMDIucHJvZC5jdS5lZHWCEHAwM3Zwbi5hZC5jdS5lZHWC
EnAwM3ZwbjAxLmFkLmN1LmVkdYIScDAzdnBuMDIuYWQuY3UuZWR1gg12cG4uY3Vz
eXMuZWR1ggx2cG4wMS5jdS5lZHWCD3ZwbjAxLmN1c3lzLmVkdYIMdnBuMDIuY3Uu
ZWR1gg92cG4wMi5jdXN5cy5lZHWCC3ZwbjEuY3UuZWR1gg52cG4xLmN1c3lzLmVk
dYILdnBuMi5jdS5lZHWCDnZwbjIuY3VzeXMuZWR1MA0GCSqGSIb3DQEBCwUAA4IB
AQBJk1HJbRghqLnn97LOfeuam6p/5D9Kt5WWFHZI7PWotXGsFC9pXjPX2rEjkqLY
8fxJ3qHAqkWMoZ6TKwABJGp+Jl5fS75kjxhd5nv7QG9onVJKNWABFkBeUZULmRN2
yWl3bxUOmti6t0VOSJp3sioMnynB+4bGMBQbyXIR85DdBboYkL7bka/QkkWIy52/
1oL2g3lGCPrYZfs7UZxiKmuGwX31dHKo2nbbS2jJdAvPK/HcMR+M60wwlIbbzT7V
FcpEAZ/1tcQxzk7b4aDCqxSyQwTh6SupRDXECUcZbgogXYKLoO0wuy9jWYEBcswC
Q7FVCLc4EFPwz9tkdLE2N13o
-----END CERTIFICATE-----''';

  test('Test getBytesFromPEMString', () {
    var bytes = CryptoUtils.getBytesFromPEMString(csr);
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

  test('Test privateKeyFromASN1Sequence', () {
    var bytes = CryptoUtils.getBytesFromPEMString(privateKey);
    ASN1Sequence asn = ASN1Parser(bytes).nextObject();
    var objects = asn.elements;
    ASN1OctetString string = objects[2];
    var object = X509Utils.privateKeyFromASN1Sequence(
        ASN1Parser(string.valueBytes).nextObject());
    expect(object.n.bitLength, 2048);
  });

  test('Test encodeASN1ObjectToPem', () {
    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(ASN1Integer(BigInt.from(0)));
    var pem = X509Utils.encodeASN1ObjectToPem(
        topLevelSeq, '-----BEGIN PUBLIC KEY-----', '-----END PUBLIC KEY-----');
    expect(
        pem, '-----BEGIN PUBLIC KEY-----\nMAMCAQA=\n-----END PUBLIC KEY-----');
  });

  test('Test generateRsaCsrPem', () {
    var pair = CryptoUtils.generateRSAKeyPair();
    var dn = {
      'CN': 'basic-utils.dev',
      'O': 'Magic Company',
      'L': 'Fakecity',
      'S': 'FakeState',
      'C': 'DE',
    };
    var csr = X509Utils.generateRsaCsrPem(dn, pair.privateKey, pair.publicKey);
    var bytes = CryptoUtils.getBytesFromPEMString(csr);
    var sequence = ASN1Sequence.fromBytes(bytes);
    ASN1Sequence e1 = sequence.elements.elementAt(0);
    ASN1Sequence e2 = e1.elements.elementAt(1);
    ASN1Set e3 = e2.elements.elementAt(0);
    ASN1Sequence e4 = e3.elements.elementAt(0);
    ASN1UTF8String e5 = e4.elements.elementAt(1);
    var cn = e5.utf8StringValue;
    expect(cn, 'basic-utils.dev');
  });

  test('Test generateEccCsrPem', () {
    var pair = CryptoUtils.generateEcKeyPair();
    var dn = {
      'CN': 'basic-utils.dev',
      'O': 'Magic Company',
      'L': 'Fakecity',
      'S': 'FakeState',
      'C': 'DE',
    };
    var csr = X509Utils.generateEccCsrPem(dn, pair.privateKey, pair.publicKey);
    var bytes = CryptoUtils.getBytesFromPEMString(csr);
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
    var pair = CryptoUtils.generateRSAKeyPair();
    RSAPrivateKey private = pair.privateKey;
    RSAPublicKey public = pair.publicKey;
    expect(private.n.bitLength, 2048);
    expect(public.n.bitLength, 2048);
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

  test('Test x509CertificateFromPem with TeletextString', () {
    var data = X509Utils.x509CertificateFromPem(x509PemWithTeletextString);
    expect(data.version, 2);

    expect(data.serialNumber.toString(), '946069240');

    expect(data.signatureAlgorithm, '1.2.840.113549.1.1.5');

    expect(data.issuer.containsKey('2.5.4.11'), true);
    expect(data.issuer['2.5.4.11'],
        'www.entrust.net/CPS_2048 incorp. by ref. (limits liab.)');
    expect(data.issuer.containsKey('2.5.4.10'), true);
    expect(data.issuer['2.5.4.10'], 'Entrust.net');
    expect(data.issuer.containsKey('2.5.4.3'), true);
    expect(
        data.issuer['2.5.4.3'], 'Entrust.net Certification Authority (2048)');

    expect(
        data.validity.notBefore.toIso8601String(), '1999-12-24T17:50:51.000Z');
    expect(
        data.validity.notAfter.toIso8601String(), '2029-07-24T14:15:12.000Z');

    expect(data.subject.containsKey('2.5.4.3'), true);
    expect(
        data.subject['2.5.4.3'], 'Entrust.net Certification Authority (2048)');

    expect(data.sha1Thumbprint, '503006091D97D4F5AE39F7CBE7927D7D652D3431');
    expect(data.md5Thumbprint, 'EE2931BC327E9AE6E8B5F751B4347190');

    var publicKeyData = data.publicKeyData;

    expect(publicKeyData.length, 2048);
    expect(publicKeyData.sha1Thumbprint,
        'BED60C6DD525D609CA1E3EE48C5D911EF0B95E0D');
    expect(publicKeyData.algorithm, '1.2.840.113549.1.1.1');
    expect(publicKeyData.bytes,
        '3082010A0282010100AD4D4BA91286B2EAA320071516642A2B4BD1BF0B4A4D8EED8076A567B77840C07342C868C0DB532BDD5EB8769835938B1A9D7C133A0E1F5BB71ECFE524141EB181A98D7DB8CC6B4B03F1020CDCABA54024007F7494A19D0829B3880BF587779D55CDE4C37ED76A64AB851486955B9732506F3DC8BA660CE3FCBDB849C176894919FDC0A8BD89A3672FC69FBC711960B82DE92CC99076667B94E2AF78D665535D3CD69CB2CF2903F92FA450B2D448CE0532558AFDB2644C0EE4980775DB7FDFB9085560853029F97B48A46986E3353F1E865D7A7A15BDEF008E1522541700902693BC0E496891BFF847D39D9542C10E4DDF6F26CFC3182162664370D6D5C007E10203010001');
  });

  test('Test x509CertificateFromPem without CN', () {
    var data = X509Utils.x509CertificateFromPem(certWithoutCN);
    expect(data.version, 2);

    expect(data.serialNumber.toString(), '419432078408221804846119');

    expect(data.signatureAlgorithm, '1.2.840.113549.1.1.11');

    expect(data.issuer['2.5.4.6'], 'NO');
    expect(data.issuer['2.5.4.10'], 'Buypass AS-983163327');
    expect(data.issuer['2.5.4.3'], 'Buypass Class 2 CA 5');

    expect(
        data.validity.notBefore.toIso8601String(), '2020-09-30T03:18:57.000Z');
    expect(
        data.validity.notAfter.toIso8601String(), '2021-03-29T21:59:00.000Z');

    expect(data.subject.isEmpty, true);

    expect(data.sha1Thumbprint, '60A66A69269C74F1DDD33EF3CD60E844716974A0');
    expect(data.md5Thumbprint, '29B4F34A5CA1B38A8329A20BFD714CEA');

    var publicKeyData = data.publicKeyData;

    expect(publicKeyData.length, 2048);
    expect(publicKeyData.sha1Thumbprint,
        'C836ECF35C878C7B51327ECE402641C7A06DF4DE');
    expect(publicKeyData.algorithm, '1.2.840.113549.1.1.1');
    expect(publicKeyData.bytes,
        '3082010A0282010100C762F36197CAB201EACC8495866301C0ECA2F8158BBE476BE05011F14D64493B831F612898CAAAD4B89A5F88FE379892405924A91167F401903C4FF82DE46AD337421675468FEE24387B971EB4F92D96DC1CBEAD525D47424AB359316A5ABF7E40BFACC4823D14AB49BEC36A4B90343CADA8CBF023705EEB42F9508B7EBF3213292FB35EBBBF0EC2BBE48D0398E6CACEF595C8F748DCA45736925F1D8A8074DDC040895FB6AAF0B8EC233C255F49F9A943F9164813E72CC5F82498CD4EBA51F9B3BC65E87A01C9D566B985F677E5602E0B13C3FF58F63897AFB731786664B23A70544A8C7ADBF93B2A26A53A45467B29D732D3085FF4F96A9567613F705A01F70203010001');
  });

  test('Test x509CertificateFromPem with selfsigned', () {
    var data = X509Utils.x509CertificateFromPem(selfSigned);
    expect(data.version, 2);

    expect(data.serialNumber.toString(), '10');

    expect(data.signatureAlgorithm, '1.2.840.113549.1.1.11');

    expect(data.issuer.containsKey('2.5.4.6'), true);
    expect(data.issuer['2.5.4.6'], 'RU');
    expect(data.issuer.containsKey('2.5.4.10'), true);
    expect(data.issuer['2.5.4.10'], 'Hikvision Digital Technology');
    expect(data.issuer.containsKey('2.5.4.3'), true);
    expect(data.issuer['2.5.4.3'], '94.198.131.55');

    expect(
        data.validity.notBefore.toIso8601String(), '2020-11-15T09:00:18.000Z');
    expect(
        data.validity.notAfter.toIso8601String(), '2030-11-15T09:00:18.000Z');

    expect(data.subject.containsKey('2.5.4.3'), true);
    expect(data.subject['2.5.4.3'], '94.198.131.55');

    expect(data.sha1Thumbprint, 'DD7B2CE1C8DA3568E2396EA86DCC6A2B4FB9B45B');
    expect(data.md5Thumbprint, 'C588B049D87D433BE5FC6E98481A88D2');

    var publicKeyData = data.publicKeyData;

    expect(publicKeyData.length, 2048);
    expect(publicKeyData.sha1Thumbprint,
        '7884BDE6157EF1F32E2CD346A39C696F3055C10E');
    expect(publicKeyData.algorithm, '1.2.840.113549.1.1.1');
    expect(publicKeyData.bytes,
        '308201080282010100D8E1EAD54EC852F5FE0D09687A45B57FE9A873D057EA880E1BA952D447D9E23050099E730E12F184201C68809ADF48C7947B5C58D330F40905422D7D0A69E0C54F9CE27C3C7A52E7F10300E201C10CE74F94B307E63C7BAF42FDA992F1679CCDFD4D90A496F3F2D151048E14FCBF0A8B2A72D551E0DFA31238686B3ED8CCBB8B360A5F4F9B3F871BFF46BA7E27C87EAB2EC87D62732482431834D0ECA17010D9794CE83F0E6F0D065A26D83A5E1A354E19E4300F7B2A243D1D43D516A81FD96EDE71F625AA19E5D39F270AD47214941300FF6B454654C6D59CAD4737DF5911F41587316F872B1EAD85F1AF286F93CC61546B3504B64582E96B87CDDA5854E5B5020103');
  });

  test('Test x509CertificateFromPem with bigCert', () {
    var data = X509Utils.x509CertificateFromPem(bigCert);
    expect(data.version, 2);

    expect(data.serialNumber.toString(), '10');

    expect(data.signatureAlgorithm, '1.2.840.113549.1.1.11');

    expect(data.issuer.containsKey('2.5.4.6'), true);
    expect(data.issuer['2.5.4.6'], 'RU');
    expect(data.issuer.containsKey('2.5.4.10'), true);
    expect(data.issuer['2.5.4.10'], 'Hikvision Digital Technology');
    expect(data.issuer.containsKey('2.5.4.3'), true);
    expect(data.issuer['2.5.4.3'], '94.198.131.55');

    expect(
        data.validity.notBefore.toIso8601String(), '2020-11-15T09:00:18.000Z');
    expect(
        data.validity.notAfter.toIso8601String(), '2030-11-15T09:00:18.000Z');

    expect(data.subject.containsKey('2.5.4.3'), true);
    expect(data.subject['2.5.4.3'], '94.198.131.55');

    expect(data.sha1Thumbprint, 'DD7B2CE1C8DA3568E2396EA86DCC6A2B4FB9B45B');
    expect(data.md5Thumbprint, 'C588B049D87D433BE5FC6E98481A88D2');

    var publicKeyData = data.publicKeyData;

    expect(publicKeyData.length, 2048);
    expect(publicKeyData.sha1Thumbprint,
        '7884BDE6157EF1F32E2CD346A39C696F3055C10E');
    expect(publicKeyData.algorithm, '1.2.840.113549.1.1.1');
    expect(publicKeyData.bytes,
        '308201080282010100D8E1EAD54EC852F5FE0D09687A45B57FE9A873D057EA880E1BA952D447D9E23050099E730E12F184201C68809ADF48C7947B5C58D330F40905422D7D0A69E0C54F9CE27C3C7A52E7F10300E201C10CE74F94B307E63C7BAF42FDA992F1679CCDFD4D90A496F3F2D151048E14FCBF0A8B2A72D551E0DFA31238686B3ED8CCBB8B360A5F4F9B3F871BFF46BA7E27C87EAB2EC87D62732482431834D0ECA17010D9794CE83F0E6F0D065A26D83A5E1A354E19E4300F7B2A243D1D43D516A81FD96EDE71F625AA19E5D39F270AD47214941300FF6B454654C6D59CAD4737DF5911F41587316F872B1EAD85F1AF286F93CC61546B3504B64582E96B87CDDA5854E5B5020103');
  });
}
