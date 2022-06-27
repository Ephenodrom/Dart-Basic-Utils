import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/src/CryptoUtils.dart';
import 'package:pointycastle/ecc/api.dart';

void main() {
  // generate key pairs
  var ec = CryptoUtils.generateEcKeyPair(curve: "secp256k1");
  var privKey = ec.privateKey as ECPrivateKey;
  var pubKey = ec.publicKey as ECPublicKey;

  // convert to pem
  var privKeyPem = CryptoUtils.encodeEcPrivateKeyToPem(privKey);
  var pubKeyPem = CryptoUtils.encodeEcPublicKeyToPem(pubKey);

  print('PrivKey PEM:\n$privKeyPem');
  print('PubKey PEM:\n$pubKeyPem');

  // convert pem to base64
  var pubKeyBase64 = base64Encode(pubKeyPem.codeUnits);
  print('PubKey base64: $pubKeyBase64');

  // decode keys from pem
  var decodedPrivKey = CryptoUtils.ecPrivateKeyFromPem(privKeyPem);
  var decodedPubKey = CryptoUtils.ecPublicKeyFromPem(pubKeyPem);

  // sign message
  var message = Uint8List.fromList("Hello world!".codeUnits);
  var signature = CryptoUtils.ecSign(decodedPrivKey, message,
      algorithmName: 'SHA-256/ECDSA'); // can be SHA-256/ECDSA or other
  var encodedSignature = CryptoUtils.ecSignatureToBase64(signature);
  print('Signature in base64: $encodedSignature');

  // verify message using ECSignature
  var isVerifiedByECSignature = CryptoUtils.ecVerify(
      decodedPubKey, message, signature,
      algorithm: 'SHA-256/ECDSA');
  print('ECSignature verification result: $isVerifiedByECSignature');

  // verify message using signature in base64
  var isVerifiedByBase64Signature = CryptoUtils.ecVerifyBase64(
      decodedPubKey, message, encodedSignature,
      algorithm: 'SHA-256/ECDSA');
  print('Base64Signature verification result: $isVerifiedByBase64Signature');
}
