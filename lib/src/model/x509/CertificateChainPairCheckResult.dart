///
/// Model for representing the pair check
///
class CertificateChainPairCheckResult {
  /// Defines if the issuer of a certificate matches it's parent subject data.
  bool dnDataMatch = true;

  /// Defines if the signature of a certificate matches it's parents public key
  bool signatureMatch = true;

  CertificateChainPairCheckResult();

  ///
  /// Returns true if all checks where passed successfuly by the pair
  ///
  bool isValid() {
    return dnDataMatch && signatureMatch;
  }
}
