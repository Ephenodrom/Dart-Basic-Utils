import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';

class DESParameters extends KeyParameter {
  final int DES_KEY_LENGTH = 8;

  DESParameters(Uint8List key) : super(key);
}
