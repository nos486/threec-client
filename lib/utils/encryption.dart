import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:threec/models/Message.dart';
import 'package:threec/store.dart';
import 'package:crypto/crypto.dart';


class Encryption {
  Key cKey;
  IV cIv;
  String keyMd5;

  String encryptMessage(String message, {String key}) {
    if (key != null) {
      keyMd5 = md5.convert(utf8.encode(key)).toString();
    } else {
      String encryptionKey = Store().storeBox.get("encryptionKey", defaultValue: "1234");
      keyMd5 = md5.convert(utf8.encode(encryptionKey)).toString();
    }

    cKey = Key.fromUtf8(keyMd5);
    cIv = IV.fromUtf8(keyMd5);

    Encrypter encrypter = Encrypter(AES(cKey, cIv, mode: AESMode.ecb));
    Encrypted encryptedMessage = encrypter.encrypt(message);
    return encryptedMessage.base64;

  }

  bool decryptMessage(Message message, {String key}) {
    if (key != null) {
      keyMd5 = md5.convert(utf8.encode(key)).toString();
    } else {
      String encryptionKey = Store().storeBox.get("encryptionKey", defaultValue: "1234");
      keyMd5 = md5.convert(utf8.encode(encryptionKey)).toString();
    }

    cKey = Key.fromUtf8(keyMd5);
    cIv = IV.fromUtf8(keyMd5);

    Encrypter encrypter = Encrypter(AES(cKey, cIv, mode: AESMode.ecb));

    try {
      String decryptedMessage = encrypter.decrypt64(message.text);
      if (toMd5(decryptedMessage) == message.hash){
        message.decrypted = true;
        message.decryptedText = decryptedMessage;
        return true;
      }else{
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }


  String toMd5(String data){
    return md5.convert(utf8.encode(data)).toString();
  }
}
