import 'package:basic_utils/src/model/asn1/ASN1DumpLine.dart';

///
/// Wrapper object for ASN1DumpLine
///
class ASN1DumpWrapper {
  /// List of single lines of the dump
  List<ASN1DumpLine>? lines;

  ASN1DumpWrapper({this.lines});

  ///
  /// Adding multiple ASN1DumpLine at once
  ///
  void addAll(List<ASN1DumpLine> l) {
    lines ??= [];
    lines!.addAll(l);
  }

  ///
  /// Adding a ASN1DumpLine
  ///
  void add(ASN1DumpLine l) {
    lines ??= [];
    lines!.add(l);
  }
}
