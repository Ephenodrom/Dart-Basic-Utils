import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/RRecord.dart';
import 'package:basic_utils/src/model/RRecordType.dart';
import "package:test/test.dart";

void main() {
  test('Test lookupRecord', () async {
    List<RRecord> records =
        await DnsUtils.lookupRecord("google.de", RRecordType.A);
    expect(records.elementAt(0).data.isEmpty, false);
  });
}
