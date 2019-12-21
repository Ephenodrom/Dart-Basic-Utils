import 'package:basic_utils/src/model/Domain.dart';

///
/// Model that represents a email address
///
class EmailAddress {
  /// The local part of the email address
  String local;

  /// The domain of the email address
  Domain domain;

  EmailAddress(this.local, this.domain);

  @override
  String toString() {
    return local + '@' + domain.toString();
  }
}
