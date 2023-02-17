enum KeyUsage {
  /// 0
  DIGITAL_SIGNATURE,
  /// 1 (Also called contentCommitment now)
  NON_REPUDIATION,
  /// 2
  KEY_ENCIPHERMENT,
  /// 3
  DATA_ENCIPHERMENT,
  /// 4
  KEY_AGREEMENT,
  /// 5
  KEY_CERT_SIGN,
  /// 6
  CRL_SIGN,
  /// 7
  ENCIPHER_ONLY,
  /// 8
  DECIPHER_ONLY
}
