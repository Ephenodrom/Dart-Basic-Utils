import 'package:basic_utils/basic_utils.dart';

///
/// Helper class for dns record lookups
///
class DnsUtils {
  ///
  /// Base url of the google dns resolver
  ///
  static String _baseUrl = "https://dns.google.com/resolve";

  ///
  /// Lookup for records of the given [type] and [name]. It also supports [dnssec]
  ///
  static Future<List<RRecord>> lookupRecord(String name, RRecordType type,
      {bool dnssec = false}) async {
    Map<String, String> queryParameters = Map();
    queryParameters.putIfAbsent("name", () => name);
    queryParameters.putIfAbsent("type", () => _getTypeFromType(type));
    queryParameters.putIfAbsent("dnssec", () => dnssec.toString());
    Map<String, dynamic> body =
        await HttpUtils.getForJson(_baseUrl, queryParameters: queryParameters);
    ResolveResponse response = ResolveResponse.fromJson(body);
    return response.answer;
  }

  ///
  /// Converts the given type to a number for the google resolver
  ///
  static String _getTypeFromType(RRecordType type) {
    switch (type) {
      case RRecordType.A:
        return "1";
      case RRecordType.AAAA:
        return "28";
      case RRecordType.ANY:
        return "255";
      case RRecordType.CAA:
        return "257";
      case RRecordType.CDS:
        return "59";
      case RRecordType.CERT:
        return "37";
      case RRecordType.CNAME:
        return "5";
      case RRecordType.DNAME:
        return "39";
      case RRecordType.DNSKEY:
        return "48";
      case RRecordType.DS:
        return "43";
      case RRecordType.HINFO:
        return "13";
      case RRecordType.IPSECKEY:
        return "45";
      case RRecordType.MX:
        return "15";
      case RRecordType.NAPTR:
        return "35";
      case RRecordType.NS:
        return "2";
      case RRecordType.NSEC:
        return "47";
      case RRecordType.NSEC3PARAM:
        return "51";
      case RRecordType.PTR:
        return "12";
      case RRecordType.RP:
        return "17";
      case RRecordType.RRSIG:
        return "46";
      case RRecordType.SOA:
        return "6";
      case RRecordType.SPF:
        return "99";
      case RRecordType.SRV:
        return "33";
      case RRecordType.SSHFP:
        return "44";
      case RRecordType.TLSA:
        return "52";
      case RRecordType.TXT:
        return "16";
      case RRecordType.WKS:
        return "11";
      default:
        return "1";
    }
  }
}
