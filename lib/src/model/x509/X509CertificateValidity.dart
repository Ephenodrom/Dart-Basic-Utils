///
/// Model that represents the validity data of a x509Certificate
///
class X509CertificateValidity {
  /// The start date
  DateTime notBefore;

  /// The end date
  DateTime notAfter;

  X509CertificateValidity({this.notBefore, this.notAfter});
}
