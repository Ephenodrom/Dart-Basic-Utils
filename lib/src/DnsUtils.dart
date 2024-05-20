import 'dart:async';

import 'package:basic_utils/basic_utils.dart';

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
  static Future<List<RRecord>?> lookupRecord(String name, RRecordType type,
      {bool dnssec = false,
      DnsApiProvider provider = DnsApiProvider.GOOGLE,
      String? dnsApiUrl}) async {
    var queryParameters = <String, dynamic>{};
    queryParameters.putIfAbsent('name', () => name);
    queryParameters.putIfAbsent('type', () => _getTypeFromType(type));
    queryParameters.putIfAbsent('dnssec', () => dnssec.toString());

    var _baseUrl = dnsApiUrl;
    if (_baseUrl == null) {
      assert(_dnsApiProviderUrl.length == DnsApiProvider.values.length);
      _baseUrl = _dnsApiProviderUrl[provider];
    }

    var headers = {'Accept': 'application/dns-json'};

    var body = await HttpUtils.getForJson(_baseUrl!,
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

  ///
  /// Reverse lookup for the given [ip] to determine a hostname.
  ///
  /// Thise reserses the given [ip], adds ".in-addr.arpa" / ".ip6.arpa" and
  /// tries to fetch a PTR record for the generated name.
  ///
  /// Will return null, if no IP address is given or no PTR is found.
  ///
  static Future<List<RRecord>?> reverseDns(String ip,
      {DnsApiProvider provider = DnsApiProvider.GOOGLE}) async {
    var queryParameters = <String, dynamic>{};

    var reverse = getReverseAddr(ip);
    if (reverse == null) {
      return null;
    }
    queryParameters.putIfAbsent('name', () => reverse);
    queryParameters.putIfAbsent(
        'type', () => _getTypeFromType(RRecordType.PTR));
    //queryParameters.putIfAbsent('dnssec', () => dnssec.toString());

    assert(_dnsApiProviderUrl.length == DnsApiProvider.values.length);
    var _baseUrl = _dnsApiProviderUrl[provider];

    var headers = {'Accept': 'application/dns-json'};

    var body = await HttpUtils.getForJson(_baseUrl!,
        queryParameters: queryParameters, headers: headers);
    var response = ResolveResponse.fromJson(body);
    return response.answer;
  }

  ///
  /// Reverses the given [ip] address. Will return null if the given [ip] is not
  /// an IP address.
  ///
  /// Example :
  /// 172.217.22.14 => 14.22.217.172.in-addr.arpa
  /// 2a00:1450:4001:81a::200e => e.0.0.2.a.1.8.1.0.0.4.0.5.4.1.0.0.a.2.ip6.arpa
  ///
  static String? getReverseAddr(String ip) {
    if (ip.contains('.')) {
      return ip.split('.').reversed.join('.') + '.in-addr.arpa';
    } else if (ip.contains(':')) {
      return ip.split(':').join().split('').reversed.join('.') + '.ip6.arpa';
    } else {
      return null;
    }
  }

  ///
  /// Converts the record to the BIND representation.
  ///
  static String toBind(RRecord record) {
    var sb = StringBuffer();
    sb.write(record.name);
    if (sb.length < 8) {
      sb.write('\t');
    }
    if (sb.length < 16) {
      sb.write('\t');
    }
    sb.write('\t');
    sb.write(record.ttl);
    sb.write('\tIN\t');
    sb.write(intToRRecordType(record.rType)
        .toString()
        .substring('RRecordType.'.length));

    sb.write('\t');
    sb.write('\"');
    sb.write(record.data);
    sb.write('\"');

    return sb.toString();
  }
}
