import 'dart:typed_data';

import 'package:basic_utils/src/library/crypto/des_parameters.dart';

class DESedeParameters extends DESParameters {
  final int DES_EDE_KEY_LENGTH = 24;

  DESedeParameters(Uint8List key) : super(key);
}
