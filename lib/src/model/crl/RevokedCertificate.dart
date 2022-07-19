import 'package:basic_utils/src/model/crl/CrlEntryExtensionsData.dart';

class RevokedCertificate {
  /// The serialNumber of the certificate
  BigInt? serialNumber;

  /// The revocation time
  DateTime? revocationDate;

  /// The extensions
  CrlEntryExtensionsData? extensions;
}
