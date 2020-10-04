import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/DnsApiProvider.dart';

///
/// Helper class for dns record lookups
///
class DnsUtils {
  ///
  /// Base url for each dns resolver
  ///
  static const _dnsApiProviderUrl = {
    DnsApiProvider.GOOGLE: 'https://dns.google.com/resolve',
    DnsApiProvider.CLOUDFLARE: 'https://cloudflare-dns.com/dns-query',
  };

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

    assert(_dnsApiProviderUrl.length == DnsApiProvider.values.length);
    var _baseUrl = _dnsApiProviderUrl[provider];

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
    return _intToRRecordType[type] ?? RRecordType.A;
  }

  ///
  /// Converts the given type to a decimal number
  ///
  static int rRecordTypeToInt(RRecordType type) {
    return _rRecordTypeToInt[type] ?? 1;
  }

  ///
  /// Map from [RRecordType] enum to number
  ///
  static const _rRecordTypeToInt = {
    RRecordType.A: 1,
    RRecordType.AAAA: 28,
    RRecordType.ANY: 255,
    RRecordType.CAA: 257,
    RRecordType.CDS: 59,
    RRecordType.CERT: 37,
    RRecordType.CNAME: 5,
    RRecordType.DNAME: 39,
    RRecordType.DNSKEY: 48,
    RRecordType.DS: 43,
    RRecordType.HINFO: 13,
    RRecordType.IPSECKEY: 45,
    RRecordType.MX: 15,
    RRecordType.NAPTR: 35,
    RRecordType.NS: 2,
    RRecordType.NSEC: 47,
    RRecordType.NSEC3PARAM: 51,
    RRecordType.PTR: 12,
    RRecordType.RP: 17,
    RRecordType.RRSIG: 46,
    RRecordType.SOA: 6,
    RRecordType.SPF: 99,
    RRecordType.SRV: 33,
    RRecordType.SSHFP: 44,
    RRecordType.TLSA: 52,
    RRecordType.TXT: 16,
    RRecordType.WKS: 11,
  };

  ///
  /// Map from number to [RRecordType] enum
  ///
  static final _intToRRecordType =
      _rRecordTypeToInt.map((k, v) => MapEntry(v, k));
}
