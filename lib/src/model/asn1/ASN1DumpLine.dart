class ASN1DumpLine {
  int offset;

  int depth;

  int headerLength;

  int length;

  String line;

  ASN1DumpLine({
    required this.offset,
    required this.depth,
    required this.headerLength,
    required this.length,
    required this.line,
  });

  String lineInfoToOpenSslString() {
    return '$offset:d=$depth hl=$headerLength l=$length';
  }

  String toOpenSslString({int spacing = 0}) {
    var sb = StringBuffer();
    sb.write(lineInfoToOpenSslString());
    for (var i = 0; i < spacing; i++) {
      sb.write(' ');
    }
    sb.write(line);
    return sb.toString();
  }
}
