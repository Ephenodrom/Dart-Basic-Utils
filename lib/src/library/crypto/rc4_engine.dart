import 'dart:typed_data';

import 'package:pointycastle/api.dart';

class RC4Engine {
  static int STATE_LENGTH = 256;

  Uint8List? _engineState;
  int _x = 0;
  int _y = 0;
  late Uint8List _workingKey;
  //bool _forEncryption = false;

  String get algorithmName => 'RC4';

  void init(bool forEncryption, CipherParameters? params) {
    //this._forEncryption = forEncryption;

    if (params != null) {
      if (params is KeyParameter) {
        _workingKey = params.key;
        setKey(params.key);
      } else {
        throw ArgumentError("Parameters of invalid type");
      }
    } else {
      throw ArgumentError("Missing parameter");
    }
  }

  Uint8List process(Uint8List data) {
    var out = Uint8List(data.length);
    processBytes(data, 0, data.length, out, 0);
    return out;
  }

  void processBytes(
      Uint8List inp, int inpOff, int len, Uint8List out, int outOff) {
    if ((inpOff + len) > inp.length) {
      throw ArgumentError("input buffer too short");
    }

    if ((outOff + len) > out.length) {
      throw ArgumentError("output buffer too short");
    }

    for (int i = 0; i < len; i++) {
      _x = (_x + 1) & 0xff;
      _y = (_engineState![_x] + _y) & 0xff;

      // swap
      int tmp = _engineState![_x];
      _engineState![_x] = _engineState![_y];
      _engineState![_y] = tmp;

      // xor
      out[i + outOff] = (inp[i + inpOff] ^
          _engineState![(_engineState![_x] + _engineState![_y]) & 0xff]);
    }
  }

  void reset() {
    setKey(_workingKey);
  }

  int returnByte(int inp) {
    _x = (_x + 1) & 0xff;
    _y = (_engineState![_x] + _y) & 0xff;

    // swap
    int tmp = _engineState![_x];
    _engineState![_x] = _engineState![_y];
    _engineState![_y] = tmp;

    // xor
    return (inp ^
        _engineState![(_engineState![_x] + _engineState![_y]) & 0xff]);
  }

  void setKey(Uint8List keyBytes) {
    _workingKey = keyBytes;

    // System.out.println("the key length is ; "+ workingKey.length);

    _x = 0;
    _y = 0;

    if (_engineState == null) {
      _engineState = Uint8List(STATE_LENGTH);
    }

    // reset the state of the engine
    for (int i = 0; i < STATE_LENGTH; i++) {
      _engineState![i] = i;
    }

    int i1 = 0;
    int i2 = 0;

    for (int i = 0; i < STATE_LENGTH; i++) {
      i2 = ((keyBytes[i1] & 0xff) + _engineState![i] + i2) & 0xff;
      // do the byte-swap inline
      int tmp = _engineState![i];
      _engineState![i] = _engineState![i2];
      _engineState![i2] = tmp;
      i1 = (i1 + 1) % keyBytes.length;
    }
  }
}
