///
///```
///OCSPResponseStatus ::= ENUMERATED {
///       successful            (0),  -- Response has valid confirmations
///       malformedRequest      (1),  -- Illegal confirmation request
///       internalError         (2),  -- Internal error in issuer
///       tryLater              (3),  -- Try again later
///                                   -- (4) is not used
///       sigRequired           (5),  -- Must sign the request
///       unauthorized          (6)   -- Request unauthorized
///   }
///```
///
enum OCSPResponseStatus {
  SUCCESSFUL,
  MALFORMED_REQUEST,
  INTERNAL_ERROR,
  TRY_LATER,
  SIG_REQUIRED,
  UNAUTHORIZED
}
