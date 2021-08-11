///
///```
///CertStatus ::= CHOICE {
///       good        [0]     IMPLICIT NULL,
///       revoked     [1]     IMPLICIT RevokedInfo,
///       unknown     [2]     IMPLICIT UnknownInfo }
///```
///
enum OCSPCertStatusValues { GOOD, REVOKED, UNKNOWN }
