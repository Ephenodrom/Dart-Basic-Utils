import 'package:basic_utils/src/model/ocsp/OCSPSingleResponse.dart';

///
///```
///ResponseData ::= SEQUENCE {
///      version              [0] EXPLICIT Version DEFAULT v1,
///      responderID              ResponderID,
///      producedAt               GeneralizedTime,
///      responses                SEQUENCE OF SingleResponse,
///      responseExtensions   [1] EXPLICIT Extensions OPTIONAL }
///```
///
class OCSPResponseData {
  List<OCSPSingleResponse> singleResponse;

  OCSPResponseData(this.singleResponse);
}
