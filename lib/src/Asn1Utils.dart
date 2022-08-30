import 'dart:typed_data';

import 'package:basic_utils/src/CryptoUtils.dart';
import 'package:basic_utils/src/model/asn1/ASN1DumpLine.dart';
import 'package:basic_utils/src/model/asn1/ASN1ObjectType.dart';
import 'package:basic_utils/src/model/asn1/ASN1DumpWrapper.dart';
import 'package:pointycastle/asn1.dart';

class Asn1Utils {
  ///
  /// Creates an ASN1 dump for the given [pem].
  ///
  /// To ignore the check for correct PEM headers, set the [checkHeader] parameter to false.
  ///
  static String dump(String pem, {bool checkHeader = true}) {
    var bytes =
        CryptoUtils.getBytesFromPEMString(pem, checkHeader: checkHeader);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject();
    var dump = topLevelSeq.dump();
    return dump;
  }

  ///
  /// Creates a more complex ASN1 dump for the given [pem].
  ///
  /// To ignore the check for correct PEM headers, set the [checkHeader] parameter to false.
  ///
  static ASN1DumpWrapper complexDump(String pem, {bool checkHeader = true}) {
    var bytes =
        CryptoUtils.getBytesFromPEMString(pem, checkHeader: checkHeader);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject();
    var wrapper = complexDumpFromASN1Object(topLevelSeq);
    return wrapper;
  }

  static ASN1DumpWrapper complexDumpFromASN1Object(ASN1Object object,
      {int intend = 0, int offset = 0}) {
    var dump = ASN1DumpWrapper();
    switch (object.runtimeType) {
      case ASN1OctetString:
        dump.addAll(_dumpASN1OctetString(object as ASN1OctetString,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1UTF8String:
        dump.addAll(_dumpASN1UTF8String(object as ASN1UTF8String,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1IA5String:
        dump.addAll(_dumpASN1IA5String(object as ASN1IA5String,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1BitString:
        dump.addAll(_dumpASN1BitString(object as ASN1BitString,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1PrintableString:
        dump.addAll(_dumpASN1PrintableString(object as ASN1PrintableString,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1TeletextString:
        dump.addAll(_dumpASN1TeletextString(object as ASN1TeletextString,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1BMPString:
        dump.addAll(_dumpASN1BMPString(object as ASN1BMPString,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1Integer:
      case ASN1Enumerated:
        dump.addAll(_dumpASN1Integer(object as ASN1Integer,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1Boolean:
        dump.addAll(_dumpASN1Boolean(object as ASN1Boolean,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1ObjectIdentifier:
        dump.addAll(_dumpASN1ObjectIdentifier(object as ASN1ObjectIdentifier,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1Null:
        dump.addAll(
            _dumpASN1Null(object as ASN1Null, intend: intend, offset: offset)
                .lines!);
        break;
      case ASN1UtcTime:
        dump.addAll(_dumpASN1UtcTime(object as ASN1UtcTime,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1GeneralizedTime:
        dump.addAll(_dumpASN1GeneralizedTime(object as ASN1GeneralizedTime,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1Sequence:
        dump.addAll(_dumpASN1Sequence(object as ASN1Sequence,
                intend: intend, offset: offset)
            .lines!);
        break;
      case ASN1Set:
        dump.addAll(
            _dumpASN1Set(object as ASN1Set, intend: intend, offset: offset)
                .lines!);
        break;
      default:
        dump.addAll(
            _dumpDefault(object, intend: intend, offset: offset).lines!);
        break;
    }

    return dump;
  }

  static ASN1DumpWrapper _dumpASN1OctetString(ASN1OctetString object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    if (object.isConstructed!) {
      sb.write('OCTET STRING (${object.elements!.length} elem)');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.CONST,
      ));
      for (var e in object.elements!) {
        var tmp = complexDumpFromASN1Object(e,
            intend: intend + 4, offset: offset + hl);
        dump.addAll(tmp.lines!);
        offset = offset + e.totalEncodedByteLength;
      }
    } else {
      sb.write('OCTET STRING (${object.octets!.length} byte) ');
      for (var o in object.octets!) {
        var s = o.toRadixString(16).toUpperCase();
        if (s.length == 1) {
          s = '0$s';
        }
        sb.write(s);
      }
      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.PRIM,
      ));
      if (ASN1Utils.isASN1Tag(object.octets!.elementAt(0))) {
        var parser = ASN1Parser(object.octets);
        var next = parser.nextObject();
        var tmp = complexDumpFromASN1Object(next,
            intend: intend + 4, offset: offset + hl);
        dump.addAll(tmp.lines!);
      }
    }
    return dump;
  }

  static ASN1DumpWrapper _dumpASN1UTF8String(ASN1UTF8String object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    if (object.isConstructed!) {
      sb.write('UTF8STRING (${object.elements!.length} elem)');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.CONST,
      ));
      for (var e in object.elements!) {
        var tmp = complexDumpFromASN1Object(e,
            intend: intend + 4, offset: offset + hl);
        dump.addAll(tmp.lines!);
        offset = offset + e.totalEncodedByteLength;
      }
    } else {
      sb.write('UTF8STRING ${object.utf8StringValue}');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.PRIM,
      ));
    }
    return dump;
  }

  static ASN1DumpWrapper _dumpASN1IA5String(ASN1IA5String object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    if (object.isConstructed!) {
      sb.write('UTF8STRING (${object.elements!.length} elem)');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.CONST,
      ));
      for (var e in object.elements!) {
        var tmp = complexDumpFromASN1Object(e,
            intend: intend + 4, offset: offset + hl);
        dump.addAll(tmp.lines!);
        offset = offset + e.totalEncodedByteLength;
      }
    } else {
      sb.write('UTF8STRING ${object.stringValue}');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.PRIM,
      ));
    }
    return dump;
  }

  static ASN1DumpWrapper _dumpASN1BitString(ASN1BitString object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    if (object.isConstructed!) {
      sb.write('BIT STRING (${object.elements!.length} elem)');
      offset = offset + hl;
      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.CONST,
      ));
      for (var e in object.elements!) {
        var tmp =
            complexDumpFromASN1Object(e, intend: intend + 4, offset: offset);
        dump.addAll(tmp.lines!);
        offset = offset + e.totalEncodedByteLength;
      }
    } else {
      if (ASN1Utils.isASN1Tag(object.stringValues!.elementAt(0))) {
        var sb2 = StringBuffer();
        for (var v in object.stringValues!) {
          var s = v.toRadixString(2);
          sb2.write(s);
        }
        var bits = sb2.toString();
        if (object.unusedbits != null) {
          bits = bits.substring(0, bits.length - object.unusedbits!);
        }
        sb.write('BIT STRING (${(bits.length)} bit) ');
        dump.add(ASN1DumpLine(
          offset: offset,
          depth: d,
          headerLength: hl,
          length: l!,
          line: sb.toString(),
          tag: object.tag!.toRadixString(16),
          type: ASN1ObjectType.PRIM,
        ));

        var unusedBits = object.valueBytes!.elementAt(0) == 0 ? 1 : 0;
        var parser = ASN1Parser(object.stringValues as Uint8List?);
        var next = parser.nextObject();
        var tmp = complexDumpFromASN1Object(next,
            intend: intend + 4, offset: offset + hl + unusedBits);
        dump.addAll(tmp.lines!);
      } else {
        var sb2 = StringBuffer();
        for (var v in object.stringValues!) {
          var s = v.toRadixString(2);
          sb2.write(s);
        }
        var bits = sb2.toString();
        if (object.unusedbits != null) {
          bits = bits.substring(0, bits.length - object.unusedbits!);
        }
        sb.write('BIT STRING (${(bits.length)} bit) ');
        sb.write(bits);
        dump.add(ASN1DumpLine(
          offset: offset,
          depth: d,
          headerLength: hl,
          length: l!,
          line: sb.toString(),
          tag: object.tag!.toRadixString(16),
          type: ASN1ObjectType.PRIM,
        ));
      }
    }
    return dump;
  }

  static ASN1DumpWrapper _dumpASN1Integer(ASN1Integer object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }

    sb.write('INTEGER ${object.integer.toString().toUpperCase()}');

    dump.add(ASN1DumpLine(
      offset: offset,
      depth: d,
      headerLength: hl,
      length: l!,
      line: sb.toString(),
      tag: object.tag!.toRadixString(16),
      type: ASN1ObjectType.PRIM,
    ));

    return dump;
  }

  static ASN1DumpWrapper _dumpASN1Boolean(ASN1Boolean object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }

    sb.write('BOOLEAN ${object.boolValue}');

    dump.add(ASN1DumpLine(
      offset: offset,
      depth: d,
      headerLength: hl,
      length: l!,
      line: sb.toString(),
      tag: object.tag!.toRadixString(16),
      type: ASN1ObjectType.PRIM,
    ));

    return dump;
  }

  static ASN1DumpWrapper _dumpASN1ObjectIdentifier(ASN1ObjectIdentifier object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }

    sb.write(
        'OBJECT IDENTIFIER ${object.objectIdentifierAsString} ${object.readableName}');

    dump.add(ASN1DumpLine(
      offset: offset,
      depth: d,
      headerLength: hl,
      length: l!,
      line: sb.toString(),
      tag: object.tag!.toRadixString(16),
      type: ASN1ObjectType.PRIM,
    ));

    return dump;
  }

  static ASN1DumpWrapper _dumpASN1Null(ASN1Null object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }

    sb.write('NULL');
    dump.add(ASN1DumpLine(
      offset: offset,
      depth: d,
      headerLength: hl,
      length: l!,
      line: sb.toString(),
      tag: object.tag!.toRadixString(16),
      type: ASN1ObjectType.PRIM,
    ));

    return dump;
  }

  static ASN1DumpWrapper _dumpASN1PrintableString(ASN1PrintableString object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    if (object.isConstructed!) {
      sb.write('PRINTABLE STRING (${object.elements!.length} elem)');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.CONST,
      ));
      for (var e in object.elements!) {
        var tmp = complexDumpFromASN1Object(e,
            intend: intend + 4, offset: offset + hl);
        dump.addAll(tmp.lines!);
        offset = offset + e.totalEncodedByteLength;
      }
    } else {
      sb.write('PRINTABLE STRING ${object.stringValue}');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.PRIM,
      ));
    }
    return dump;
  }

  static ASN1DumpWrapper _dumpASN1TeletextString(ASN1TeletextString object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    if (object.isConstructed!) {
      sb.write('T61STRING (${object.elements!.length} elem)');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.CONST,
      ));
      for (var e in object.elements!) {
        var tmp = complexDumpFromASN1Object(e,
            intend: intend + 4, offset: offset + hl);
        dump.addAll(tmp.lines!);
        offset = offset + e.totalEncodedByteLength;
      }
    } else {
      sb.write('T61STRING ${object.stringValue}');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.PRIM,
      ));
    }
    return dump;
  }

  static ASN1DumpWrapper _dumpASN1UtcTime(ASN1UtcTime object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }

    sb.write('UTCTIME ${object.time!.toIso8601String()}');
    dump.add(ASN1DumpLine(
      offset: offset,
      depth: d,
      headerLength: hl,
      length: l!,
      line: sb.toString(),
      tag: object.tag!.toRadixString(16),
      type: ASN1ObjectType.PRIM,
    ));

    return dump;
  }

  static ASN1DumpWrapper _dumpASN1GeneralizedTime(ASN1GeneralizedTime object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }

    sb.write('GENERALIZEDTIME ${object.dateTimeValue!.toIso8601String()}');
    dump.add(ASN1DumpLine(
      offset: offset,
      depth: d,
      headerLength: hl,
      length: l!,
      line: sb.toString(),
      tag: object.tag!.toRadixString(16),
      type: ASN1ObjectType.PRIM,
    ));

    return dump;
  }

  static ASN1DumpWrapper _dumpASN1BMPString(ASN1BMPString object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    if (object.isConstructed!) {
      sb.write('BMPString (${object.elements!.length} elem)');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.CONST,
      ));
      for (var e in object.elements!) {
        var tmp = complexDumpFromASN1Object(e,
            intend: intend + 4, offset: offset + hl);
        dump.addAll(tmp.lines!);
      }
    } else {
      sb.write('BMPString ${object.stringValue}');

      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.PRIM,
      ));
    }
    return dump;
  }

  static ASN1DumpWrapper _dumpASN1Sequence(ASN1Sequence object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    sb.write('SEQUENCE (${object.elements!.length} elem)');

    dump.add(ASN1DumpLine(
      offset: offset,
      depth: d,
      headerLength: hl,
      length: l!,
      line: sb.toString(),
      tag: object.tag!.toRadixString(16),
      type: ASN1ObjectType.CONST,
    ));
    offset = offset + hl;
    for (var e in object.elements!) {
      var tmp =
          complexDumpFromASN1Object(e, intend: intend + 4, offset: offset);
      dump.addAll(tmp.lines!);

      offset = offset + e.totalEncodedByteLength;
    }
    return dump;
  }

  static ASN1DumpWrapper _dumpASN1Set(ASN1Set object,
      {int intend = 0, int offset = 0}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }
    sb.write('SET (${object.elements!.length} elem)');

    dump.add(ASN1DumpLine(
      offset: offset,
      depth: d,
      headerLength: hl,
      length: l!,
      line: sb.toString(),
      tag: object.tag!.toRadixString(16),
      type: ASN1ObjectType.CONST,
    ));
    offset = offset + hl;
    for (var e in object.elements!) {
      var tmp =
          complexDumpFromASN1Object(e, intend: intend + 4, offset: offset);
      dump.addAll(tmp.lines!);
      offset = offset + e.totalEncodedByteLength;
    }
    return dump;
  }

  static String _prepend(int intend) {
    var sb = StringBuffer();
    sb.write('|');
    for (var i = 0; i < intend; i++) {
      if (i > 0 && i % 4 == 0) {
        sb.write('|');
      } else {
        sb.write('-');
      }
    }
    sb.write('> ');
    return sb.toString();
  }

  static ASN1DumpWrapper _dumpDefault(ASN1Object object,
      {required int intend, required int offset}) {
    var d = intend % 4;
    var hl = object.totalEncodedByteLength - object.valueByteLength!;
    var l = object.valueByteLength;
    var dump = ASN1DumpWrapper();
    var sb = StringBuffer();
    if (intend != 0) {
      sb.write(_prepend(intend));
      d = (intend / 4).round();
    }

    if (object.tag == 0xA0 || object.tag == 0xA3) {
      sb.write('[${object.tag!.toRadixString(16).toUpperCase()}]');

      var parser = ASN1Parser(object.valueBytes);
      if (parser.hasNext()) {
        sb.write(' (1 elem)');
        dump.add(ASN1DumpLine(
          offset: offset,
          depth: d,
          headerLength: hl,
          length: l!,
          line: sb.toString(),
          tag: object.tag!.toRadixString(16),
          type: ASN1ObjectType.CONST,
        ));
        offset = offset + hl;

        var tmp = complexDumpFromASN1Object(parser.nextObject(),
            intend: intend + 4, offset: offset);
        dump.addAll(tmp.lines!);
      } else {
        sb.write(' (0 elem)');
        dump.add(ASN1DumpLine(
          offset: offset,
          depth: d,
          headerLength: hl,
          length: l!,
          line: sb.toString(),
          tag: object.tag!.toRadixString(16),
          type: ASN1ObjectType.CONST,
        ));
      }
    } else if (object.tag == 0x86 || object.tag == 0x82) {
      sb.write(
          '[${object.tag!.toRadixString(16).toUpperCase()}] (${object.valueBytes!.length} byte) ');
      var content = String.fromCharCodes(object.valueBytes!.toList());
      sb.write(content);
      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.PRIM,
      ));
    } else if (object.tag == 0x80) {
      sb.write(
          '[${object.tag!.toRadixString(16).toUpperCase()}] (${object.valueBytes!.length} byte) ');
      for (var o in object.valueBytes!) {
        var s = o.toRadixString(16).toUpperCase();
        if (s.length == 1) {
          s = '0$s';
        }
        sb.write(s);
      }
      dump.add(ASN1DumpLine(
        offset: offset,
        depth: d,
        headerLength: hl,
        length: l!,
        line: sb.toString(),
        tag: object.tag!.toRadixString(16),
        type: ASN1ObjectType.PRIM,
      ));
    }
    return dump;
  }
}
