class CertificateChainCheckError {
  bool dnDataMatch = true;
  bool signatureMatch = true;

  CertificateChainCheckError();

  bool isValid() {
    return dnDataMatch && signatureMatch;
  }
}
