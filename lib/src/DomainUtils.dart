part of basic_utils;

///
/// Helper class for domain names
///
class DomainUtils {
  ///
  /// Checks if the given string is a domain name
  ///
  static bool isDomainName(String s) {
    return false;
  }

  static bool isSubTld(String s) {
    return false;
  }

  static bool isCCTLD(String s) {
    return false;
  }

  static bool isNGTLD(String s) {
    return false;
  }

  static bool isGTLD(String s) {
    return false;
  }

  ///
  /// Splits the given domain name.
  /// Examples :
  /// example.com => ["example","com"]
  /// subdomain.example.com => ["subdomain","example","com"]
  ///
  static List<String> splitDomainName(String s) {
    return s.split(".");
  }

  ///
  /// Fetches the domain name from the given url
  ///
  static String getDomainFromUrl(String s) {
    String name = "";

    return name;
  }

  ///
  /// Converts the given domain string to the utf8 representation.
  /// If the given string is not ascii it returns null.
  ///
  static String toAscii(String domain) {
    if (domain.endsWith("de")) {
    } else {}
    return domain;
  }

  ///
  /// Parse the given domain string to a domain object
  ///
  static Domain parseDomain(String domainName) {
    if (!domainName.contains(".")) {
      return null;
    }
    domainName = domainName.trim();
    if (domainName.endsWith(".")) {
      domainName = domainName.substring(0, domainName.length - 1);
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
          return new Domain(sld: subTldEntry, tld: tld);
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
}
