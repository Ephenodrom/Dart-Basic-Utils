import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/X509Utils.dart';
import 'package:test/test.dart';

void main() {
  var x509Pem = '''-----BEGIN CERTIFICATE-----
      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
      zvE4WdYIQHPX0Y36+mjPnSMTXcrCPd+9yQ==
      -----END CERTIFICATE-----''';

  test('Test getThumbprintFromCertBytes', () {
    var bytes = X509Utils.getBytesFromPEMString(x509Pem);
    var thumbprint = CryptoUtils.getSha1ThumbprintFromBytes(bytes);
    expect(thumbprint, '65AA0349076EC56BA663F128074F426705B41FB1');
  });

  test('Test getMd5ThumbprintFromCertBytes', () {
    var bytes = X509Utils.getBytesFromPEMString(x509Pem);
    var thumbprint = CryptoUtils.getMd5ThumbprintFromBytes(bytes);
    expect(thumbprint, 'EA0A4E97FB79AC590C4DE08DD4F5E331');
  });
}
