import 'dart:typed_data';

import 'package:pointycastle/export.dart';

class DESedeEngine {
  @override
  // TODO: implement algorithmName
  String get algorithmName => throw UnimplementedError();

  @override
  // TODO: implement blockSize
  int get blockSize => throw UnimplementedError();

  @override
  void init(bool forEncryption, CipherParameters? params) {
    // TODO: implement init
  }

  @override
  Uint8List process(Uint8List data) {
    // TODO: implement process
    throw UnimplementedError();
  }

  @override
  int processBlock(Uint8List inp, int inpOff, Uint8List out, int outOff) {
    // TODO: implement processBlock
    throw UnimplementedError();
  }

  @override
  void reset() {
    // TODO: implement reset
  }
}
