import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/DnsApiProvider.dart';

///
/// Helper class for dns record lookups
///
class DnsUtils {
  ///
  /// Base url of the google dns resolver
  ///
  static final String _baseUrlGoogle = 'https://dns.google.com/resolve';

  static final String _baseUrlCloudflare =
      'https://cloudflare-dns.com/dns-query';

  ///
  /// Lookup for records of the given [type] and [name]. It also supports [dnssec]
  ///
  static Future<List<RRecord>> lookupRecord(String name, RRecordType type,
      {bool dnssec = false,
      DnsApiProvider provider = DnsApiProvider.GOOGLE}) async {
    var queryParameters = <String, dynamic>{};
    queryParameters.putIfAbsent('name', () => name);
    queryParameters.putIfAbsent('type', () => _getTypeFromType(type));
    queryParameters.putIfAbsent('dnssec', () => dnssec.toString());

    var _baseUrl = '';
    switch (provider) {
      case DnsApiProvider.GOOGLE:
        _baseUrl = _baseUrlGoogle;
        break;
      case DnsApiProvider.CLOUDFLARE:
        _baseUrl = _baseUrlCloudflare;
        break;
    }

    var headers = {'Accept': 'application/dns-json'};

    var body = await HttpUtils.getForJson(_baseUrl,
        queryParameters: queryParameters, headers: headers);
    var response = ResolveResponse.fromJson(body);
    return response.answer;
  }

  static String _getTypeFromType(RRecordType type) {
    return rRecordTypeToInt(type).toString();
  }

  ///
  /// Converts the given number [type] to a [RRecordType] enum.
  ///
  static RRecordType intToRRecordType(int type) {
    switch (type) {
      case 1:
        return RRecordType.A;
      case 28:
        return RRecordType.AAAA;
      case 255:
        return RRecordType.ANY;
      case 257:
        return RRecordType.CAA;
      case 59:
        return RRecordType.CDS;
      case 37:
        return RRecordType.CERT;
      case 5:
        return RRecordType.CNAME;
      case 39:
        return RRecordType.DNAME;
      case 48:
        return RRecordType.DNSKEY;
      case 43:
        return RRecordType.DS;
      case 13:
        return RRecordType.HINFO;
      case 45:
        return RRecordType.IPSECKEY;
      case 15:
        return RRecordType.MX;
      case 35:
        return RRecordType.NAPTR;
      case 2:
        return RRecordType.NS;
      case 47:
        return RRecordType.NSEC;
      case 51:
        return RRecordType.NSEC3PARAM;
      case 12:
        return RRecordType.PTR;
      case 17:
        return RRecordType.RP;
      case 46:
        return RRecordType.RRSIG;
      case 6:
        return RRecordType.SOA;
      case 99:
        return RRecordType.SPF;
      case 33:
        return RRecordType.SRV;
      case 44:
        return RRecordType.SSHFP;
      case 52:
        return RRecordType.TLSA;
      case 16:
        return RRecordType.TXT;
      case 11:
        return RRecordType.WKS;
      default:
        return RRecordType.A;
    }
  }

  ///
  /// Converts the given type to a decimal number
  ///
  static int rRecordTypeToInt(RRecordType type) {
    switch (type) {
      case RRecordType.A:
        return 1;
      case RRecordType.AAAA:
        return 28;
      case RRecordType.ANY:
        return 255;
      case RRecordType.CAA:
        return 257;
      case RRecordType.CDS:
        return 59;
      case RRecordType.CERT:
        return 37;
      case RRecordType.CNAME:
        return 5;
      case RRecordType.DNAME:
        return 39;
      case RRecordType.DNSKEY:
        return 48;
      case RRecordType.DS:
        return 43;
      case RRecordType.HINFO:
        return 13;
      case RRecordType.IPSECKEY:
        return 45;
      case RRecordType.MX:
        return 15;
      case RRecordType.NAPTR:
        return 35;
      case RRecordType.NS:
        return 2;
      case RRecordType.NSEC:
        return 47;
      case RRecordType.NSEC3PARAM:
        return 51;
      case RRecordType.PTR:
        return 12;
      case RRecordType.RP:
        return 17;
      case RRecordType.RRSIG:
        return 46;
      case RRecordType.SOA:
        return 6;
      case RRecordType.SPF:
        return 99;
      case RRecordType.SRV:
        return 33;
      case RRecordType.SSHFP:
        return 44;
      case RRecordType.TLSA:
        return 52;
      case RRecordType.TXT:
        return 16;
      case RRecordType.WKS:
        return 11;
      default:
        return 1;
    }
  }
}
