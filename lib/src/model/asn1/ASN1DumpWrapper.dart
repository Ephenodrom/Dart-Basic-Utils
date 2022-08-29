import 'package:basic_utils/src/model/asn1/ASN1DumpLine.dart';

class ASN1DumpWrapper {
  List<ASN1DumpLine>? lines;

  ASN1DumpWrapper({this.lines});

  void addAll(List<ASN1DumpLine> l) {
    lines ??= [];
    lines!.addAll(l);
  }

  void add(ASN1DumpLine l) {
    lines ??= [];
    lines!.add(l);
  }
}
