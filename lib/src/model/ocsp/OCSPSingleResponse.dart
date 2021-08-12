import 'package:basic_utils/src/model/ocsp/OCSPCertStatus.dart';

///
///```
///SingleResponse ::= SEQUENCE {
///      certID                       CertID,
///      certStatus                   CertStatus,
///      thisUpdate                   GeneralizedTime,
///      nextUpdate         [0]       EXPLICIT GeneralizedTime OPTIONAL,
///      singleExtensions   [1]       EXPLICIT Extensions OPTIONAL }
///```
///
class OCSPSingleResponse {
  OCSPCertStatus certStatus;
  DateTime thisUpdate;

  OCSPSingleResponse(this.certStatus, this.thisUpdate);
}
