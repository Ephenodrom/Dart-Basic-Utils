import 'package:basic_utils/src/model/ocsp/BasicOCSPResponse.dart';
import 'package:basic_utils/src/model/ocsp/OCSPResponseStatus.dart';

class OCSPResponse {
  OCSPResponseStatus responseStatus;

  BasicOCSPResponse? basicOCSPResponse;

  OCSPResponse(this.responseStatus, {this.basicOCSPResponse});
}
