import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

const encryptKey = "MJCODERS@@TAYYABIRFANCOMPANY{@2}";
const ivTxt = "TAYYAB<><>()&*^%";

Future<String> encryptString(str) async {
  final plainText = str;
  var key = encrypt.Key.fromUtf8(encryptKey);
  final iv = encrypt.IV.fromUtf8(ivTxt);
  final encrypter =
  encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = await encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

Future<String> decryptString(enData) async {
  var key = encrypt.Key.fromUtf8(encryptKey);
  final encrypter =
  encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final iv = encrypt.IV.fromUtf8(ivTxt);
  String data = await encrypter.decrypt64(enData, iv: iv).toString();
  return data;
}
