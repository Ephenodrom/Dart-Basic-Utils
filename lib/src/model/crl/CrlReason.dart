///
/// The CRL reason enum.
/// ```
/// CRLReason ::= ENUMERATED {
///        unspecified             (0),
///        keyCompromise           (1),
///        cACompromise            (2),
///        affiliationChanged      (3),
///        superseded              (4),
///        cessationOfOperation    (5),
///        certificateHold         (6),
///             -- value 7 is not used
///        removeFromCRL           (8),
///        privilegeWithdrawn      (9),
///        aACompromise           (10) }
///```
///
enum CrlReason {
  unspecified, //0
  keyCompromise, //1
  cACompromise, //2
  affiliationChanged, //3
  superseded, //4
  cessationOfOperation, //5
  certificateHold, //6
  removeFromCRL, //8
  privilegeWithdrawn, //9
  aACompromise //10
}
