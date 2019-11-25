import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/CountryCodeList.dart';
import 'package:basic_utils/src/model/Domain.dart';
import 'package:basic_utils/src/model/GtldList.dart';
import 'package:basic_utils/src/model/IdnCountryCodeList.dart';
import 'package:basic_utils/src/model/PublicSuffix.dart';

///
/// Helper class for domain names
///
class DomainUtils {
  ///
  /// Checks if the given string [s] is a domain name.
  ///
  /// Will return false if the given string [s] starts with www. or *.
  ///
  static bool isDomainName(String s) {
    if (s.startsWith("*.") || isSubDomain(s)) {
      return false;
    }
    return parseDomain(s) != null;
  }

  ///
  /// Checks if the given string [subTld] is a subTld
  ///
  static bool isSubTld(String tld, String subTld) {
    List<String> subTLDs = suffixList[tld];
    if (subTLDs == null) {
      return false;
    }
    if (subTLDs.contains(subTld)) {
      return true;
    }
    return false;
  }

  ///
  /// Check if the given string [s] is a subdomain
  /// Example: api.domain.com => true
  /// domain.de.com => false
  ///
  static bool isSubDomain(String s) {
    if (StringUtils.isNotNullOrEmpty(s)) {
      List<String> labels = splitDomainName(s);
      if (labels.length == 2) {
        // Only 2 labels, so it has to be a normal domain name
        return false;
      }
      if (labels.length == 3) {
        // 3 labels, check for www and if the second label is a subtld
        if (labels.elementAt(0) == "www") {
          // Found www at the first label, it is a subdomain
          return true;
        }
        // If the domain name has a subtld, return false otherwise return true
        return !isSubTld(labels.elementAt(2), labels.elementAt(1));
      }
      if (labels.length > 3) {
        // More than 3 labels, so it is a sub domain name
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  ///
  /// Checks if the given [sub] is a subdomain of the given [domain].
  /// Example :
  /// sub1.domain.com & domain.com => true
  /// sub1.domain2.com & domain.com => false
  ///
  static bool isSubDomainOf(String sub, String domain) {
    String rightPart = sub.substring(sub.indexOf(".") + 1);
    return rightPart == domain;
  }

  ///
  /// Checks if the given string [s] is a cctld.
  /// Example :
  /// de => true
  /// com => false
  ///
  static bool isCCTLD(String s) {
    return idnCountryCodeList.containsKey(s) ||
        countryCodeList.contains(s.toUpperCase());
  }

  ///
  /// Checks if the given string [s] is a ngtld.
  /// Example :
  /// car => true
  /// com => false
  /// de => false
  ///
  static bool isNGTLD(String s) {
    return (!isCCTLD(s) && !isGTLD(s) && isTld(s));
  }

  ///
  /// Checks if the given string [s] is a tld.
  /// Example :
  /// car => true
  /// com => true
  /// de => true
  /// qwertzu => false
  ///
  static bool isTld(String s) {
    return suffixList.containsKey(s);
  }

  ///
  /// Checks if the given string [s] is a gtld.
  /// Example :
  /// de => false
  /// com => true
  ///
  static bool isGTLD(String s) {
    return gtldList.contains(s);
  }

  ///
  /// Splits the given [domainName].
  /// Examples :
  /// example.com => ["example","com"]
  /// subdomain.example.com => ["subdomain","example","com"]
  ///
  static List<String> splitDomainName(String domainName) {
    return domainName.split(".");
  }

  ///
  /// Fetches the domain from the given [url]
  /// Returns null if the given [url] is not parsable.
  ///
  static Domain getDomainFromUrl(String url) {
    url = url.replaceFirst("https://", "");
    url = url.replaceFirst("http://", "");
    if (url.contains("/")) {
      url = url.substring(0, url.indexOf("/"));
    }
    return parseDomain(url);
  }

  ///
  /// Parse the given [domainName] to a [Domain] object.
  /// Returns null if the given [domainName] is not parsable.
  ///
  static Domain parseDomain(String domainName) {
    domainName = domainName.trim();
    if (domainName.endsWith(".")) {
      domainName = domainName.substring(0, domainName.length - 1);
    }
    if (domainName.startsWith(".")) {
      domainName = domainName.substring(1, domainName.length);
    }
    if (!domainName.contains(".")) {
      return null;
    }
    String tld = domainName.substring(
        domainName.lastIndexOf(".") + 1, domainName.length);
    String leftPart = _getLeftPart(domainName, tld);
    // Check if we have a left part
    if (StringUtils.isNullOrEmpty(leftPart)) {
      return null;
    }

    // Check if suffix list contains tld
    if (!suffixList.containsKey(tld)) {
      return null;
    }

    // Fetch subTLDs from the suffix list
    List<String> subTLDs = suffixList[tld];
    if (subTLDs == null || subTLDs.isEmpty) {
      // No subTLDs for the given tld, build the domain
      return Domain(sld: _trimToLastLabel(leftPart), tld: tld);
    } else {
      // Iterate over each subTLD
      for (String subTldEntry in subTLDs) {
        // Remove uncommon chars
        subTldEntry = _removeUncommonChars(subTldEntry);
        if (domainName.endsWith(subTldEntry + "." + tld)) {
          int labelCount = 0;
          // Calculate the allowedLabels
          if (subTldEntry == "*") {
            // *.de means that label1.label2.de is allowed
            labelCount = 3;
          } else {
            labelCount = subTldEntry.split(".").length + 2;
          }
          String leftPt = "";
          if (domainName.length > (subTldEntry + "." + tld).length) {
            leftPt = _getLeftPart(domainName, subTldEntry + "." + tld);
            // Calculate the amount of labels in the right part: 1 (tld) + subTld length
            int rightPartLabels = 1 + subTldEntry.split(".").length;
            // Calculate the allowed amount of labels in the left part
            int leftPartLabelsAllowed = labelCount - rightPartLabels;
            int cuttingIndex = leftPt.indexOf(".", leftPartLabelsAllowed - 1);
            String sld;
            if (cuttingIndex >= 0) {
              sld = leftPt.substring(cuttingIndex + 1);
            } else {
              sld = leftPt;
            }
            return Domain(sld: sld, subTld: subTldEntry, tld: tld);
          }
          return Domain(sld: subTldEntry, tld: tld);
        } else if (subTldEntry.contains("*")) {
          String left = _getLeftPart(domainName, tld);
          int count = left.split(".").length;
          if (count > 2) {
            left = left.substring(left.indexOf(".", (count - 2) - 1) + 1);
            if (left.split(".").length > 1) {
              String sld = left.split(".")[0];
              String subTld = left.substring(sld.length + 1);
              return Domain(sld: sld, subTld: subTld, tld: tld);
            } else {
              return Domain(sld: left, tld: tld);
            }
          } else {
            return Domain(sld: left, tld: tld);
          }
        }
      }
      // No subTld from the suffix list matches
      return Domain(sld: _trimToLastLabel(leftPart), tld: tld);
    }
  }

  static String _removeUncommonChars(String subTldEntry) {
    if (subTldEntry.startsWith("!")) {
      return subTldEntry.substring(1);
    }
    if (subTldEntry.startsWith("*.")) {
      return subTldEntry.substring(2);
    }
    return subTldEntry;
  }

  static String _getLeftPart(String domainName, String rightPart) {
    return domainName.substring(0, domainName.lastIndexOf("." + rightPart));
  }

  static String _trimToLastLabel(String value) {
    if (!value.contains(".")) return value;
    return value.substring(value.lastIndexOf(".") + 1);
  }

  ///
  /// Splits the given [domain] in seperate domain names for each subdomain.
  ///
  /// Example:
  /// sub2.sub1.domain.com => ["sub2.sub1.domain.com", "sub1.domain.com", "domain.com"]
  ///
  static List<String> splitSubdomainInDomains(String name) {
    List<String> domains = [];
    List<String> ar = name.split("\.");

    for (int i = 0; i < ar.length; i++) {
      StringBuffer sb = StringBuffer();
      for (int j = i; j < ar.length; j++) {
        sb.write(ar[j]);
        sb.write(".");
      }
      String domain = sb.toString();
      domain = domain.substring(0, domain.length - 1);
      if (ar.length - i == 3) {
        List<String> splitted = splitDomainName(domain);
        if (isSubTld(splitted.elementAt(2), splitted.elementAt(1))) {
          domains.add(domain);
          break;
        }
      }
      if (ar.length - i == 2) {
        domains.add(domain);
        break;
      }
      domains.add(domain);
    }
    return domains;
  }
}
