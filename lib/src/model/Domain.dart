import 'package:basic_utils/basic_utils.dart';

///
/// Model that represents a domain name
///
class Domain {
  /// The second level domain name
  String sld;

  /// The sub top level domain name
  String subTld;

  /// The top level domain name
  String tld;

  /// The ascii encoded top level domain. NOT YET IMPLEMENTED
  String asciiTld;

  /// The ascii encoded sub top level domain. NOT YET IMPLEMENTED
  String asciiSubTld;

  /// The ascii encoded second level domain. NOT YET IMPLEMENTED
  String asciiSld;

  /// The ascii version of the domain. NOT YET IMPLEMENTED
  String asciiName;

  Domain({this.sld, this.tld, this.subTld}) {
    _setTld(tld);
    _setSld(sld);
    _setSubTld(subTld);
  }

  void _setTld(String tld) {
    if (tld != null) {
      tld = tld;
      //asciiTld = DomainUtils.toASCII(tld, isNamePrep2008());
    }
  }

  void _setSubTld(String subTld) {
    if (subTld != null) {
      subTld = subTld;
      // asciiSubTld = DomainUtils.toASCII(subTld, isNamePrep2008());
    }
  }

  void _setSld(String sld) {
    if (sld != null) {
      sld = sld;
      //asciiSld = DomainUtils.toASCII(sld, isNamePrep2008());
    }
  }

  @override
  String toString() {
    List<String> parts = [];
    parts.add(sld);
    if (StringUtils.isNotNullOrEmpty(subTld)) {
      parts.add(subTld);
    }
    parts.add(tld);
    return parts.join(".");
  }

  String toAsciiString() {
    List<String> parts = [];
    parts.add(asciiSld);
    if (StringUtils.isNotNullOrEmpty(asciiSubTld)) {
      parts.add(asciiSubTld);
    }
    parts.add(asciiTld);
    return parts.join(".");
  }
}
