import 'dart:typed_data';

import 'package:pointycastle/api.dart';

class Pkcs12HelperUtils {
  static Uint8List generateDerivedKey(int idByte, int n, Uint8List salt,
      Uint8List password, Digest digest, int iterationCount) {
    var u = digest.digestSize;
    var v = digest.byteLength;

    var D = Uint8List(v);
    var dKey = Uint8List(n);
    for (var i = 0; i != D.length; i++) {
      D[i] = idByte;
    }
    Uint8List S;
    if (salt.isNotEmpty) {
      S = Uint8List((v * (((salt.length + v) - 1) ~/ v)));
      for (var i = 0; i != S.length; i++) {
        S[i] = salt[i % salt.length];
      }
    } else {
      S = Uint8List(0);
    }
    Uint8List P;
    if (password.isNotEmpty) {
      P = Uint8List((v * (((password.length + v) - 1) ~/ v)));
      for (var i = 0; i != P.length; i++) {
        P[i] = password[i % password.length];
      }
    } else {
      P = Uint8List(0);
    }
    var I = Uint8List((S.length + P.length));
    arrayCopy(S, 0, I, 0, S.length);
    arrayCopy(P, 0, I, S.length, P.length);
    var B = Uint8List(v);
    var c = (((n + u) - 1) ~/ u);
    var A = Uint8List(u);
    for (var i = 1; i <= c; i++) {
      digest.update(D, 0, D.length);
      digest.update(I, 0, I.length);
      digest.doFinal(A, 0);
      for (var j = 1; j < iterationCount; j++) {
        digest.update(A, 0, A.length);
        digest.doFinal(A, 0);
      }
      for (var j = 0; j != B.length; j++) {
        B[j] = A[j % A.length];
      }
      for (var j = 0; j != (I.length ~/ v); j++) {
        adjust(I, j * v, B);
      }
      if (i == c) {
        arrayCopy(A, 0, dKey, (i - 1) * u, dKey.length - ((i - 1) * u));
      } else {
        arrayCopy(A, 0, dKey, (i - 1) * u, A.length);
      }
    }
    return dKey;
  }

  static void arrayCopy(Uint8List? sourceArr, int sourcePos, Uint8List? outArr,
      int outPos, int len) {
    for (var i = 0; i < len; i++) {
      outArr![outPos + i] = sourceArr![sourcePos + i];
    }
  }

  static void adjust(Uint8List a, int aOff, Uint8List b) {
    var x = (b[b.length - 1] & 0xff) + (a[aOff + b.length - 1] & 0xff) + 1;

    a[aOff + b.length - 1] = x;
    x >>>= 8;

    for (var i = b.length - 2; i >= 0; i--) {
      x += (b[i] & 0xff) + (a[aOff + i] & 0xff);
      a[aOff + i] = x;
      x >>>= 8;
    }
  }

  static Uint8List formatPkcs12Password(String key) {
    var password = key.codeUnits;
    if (password.isNotEmpty) {
      // +1 for extra 2 pad bytes.
      var bytes = Uint8List((password.length + 1) * 2);

      for (var i = 0; i != password.length; i++) {
        bytes[i * 2] = (password[i] >>> 8);
        bytes[i * 2 + 1] = password[i];
      }

      return bytes;
    } else {
      return Uint8List(0);
    }
  }
}
