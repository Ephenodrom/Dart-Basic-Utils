part of basic_utils;

///
/// Helper class for emails
///
class EmailUtils {
  static final emailRegex =
      "^([\\w\\d\\-\\+]+)(\\.+[\\w\\d\\-\\+%]+)*@([\\w\\-]+\\.){1,5}(([A-Za-z]){2,30}|xn--[A-Za-z0-9]{1,26})\$";

  ///
  /// Checks whether the given string [s] is a email address
  ///
  static bool isEmail(String s) {
    RegExp regExp = new RegExp(emailRegex);
    return regExp.hasMatch(s);
  }

  ///
  /// Parse the given email address string [s] to a [EmailAddress] object.
  /// Returns null if [s] is not parsable.
  ///
  static EmailAddress parseEmailAddress(String s) {
    if (isEmail(s)) {
      List<String> parts = s.split("@");
      Domain domain = DomainUtils.parseDomain(parts.elementAt(1));
      if (domain == null) {
        return null;
      }
      return EmailAddress(parts.elementAt(0), domain);
    } else {
      return null;
    }
  }
}
