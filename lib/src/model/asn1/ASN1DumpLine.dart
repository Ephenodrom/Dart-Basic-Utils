import 'package:basic_utils/src/model/asn1/ASN1ObjectType.dart';

///
/// A line from an ASN1 dump
///
class ASN1DumpLine {
  /// The offset
  int offset;

  /// The current depth
  int depth;

  /// The header length of the object
  int headerLength;

  /// The length of the object
  int length;

  /// The readable line representing the object
  String line;

  /// The tag of the object as HEX
  String tag;

  /// The object type
  ASN1ObjectType type;

  ASN1DumpLine({
    required this.offset,
    required this.depth,
    required this.headerLength,
    required this.length,
    required this.line,
    required this.tag,
    required this.type,
  });

  ///
  /// Prints out the line information
  ///
  String lineInfoToString() {
    return 'o=$offset d=$depth hl=$headerLength l=$length t=${tag.toUpperCase()}';
  }

  ///
  /// Prints out the full line in an OpenSSL style.
  ///
  /// [spacing] defines the amount of white spaces between the line info and the readable line string
  ///
  /// ```
  /// 13:d=2 hl=2 l=16 t=2       |----|---> INTEGER 9419718410412351084484106081643920776
  /// ```
  ///
  @override
  String toString({int spacing = 0}) {
    var sb = StringBuffer();
    sb.write(lineInfoToString());
    for (var i = 0; i < spacing; i++) {
      sb.write(' ');
    }
    sb.write(line);
    return sb.toString();
  }
}
