import 'package:hive/hive.dart';
import 'package:threec/models/chat.dart';
import 'package:threec/models/user.dart';
import 'package:threec/store.dart';
import 'package:threec/utils/encryption.dart';
part "message.g.dart";

enum MessageType {
  text,
  file
}

@HiveType(typeId: 3)
class Message extends HiveObject{

  @HiveField(0)
  String id;
  @HiveField(1)
  User author;
  @HiveField(2)
  Chat chat;
  @HiveField(3)
  Message reply;
  @HiveField(4)
  MessageType type;
  @HiveField(5)
  String text;
  @HiveField(6)
  String hash;
  // String content = null;
  // file = null;
  @HiveField(7)
  DateTime createdAt;
  @HiveField(8)
  bool decrypted = false;
  @HiveField(9)
  String decryptedText ;

  Message();

  decrypt(){
    if(!decrypted){
      print("decrypted");
      Encryption().decryptMessage(this);
    }
  }
}

//
// class MessageAdapter extends TypeAdapter<Message> {
//   @override
//   final typeId = 3;
//
//   @override
//   Message read(BinaryReader reader) {
//     Message message = new Message();
//     message.id = reader.read();
//     message.author = reader.read();
//     message.chat = reader.read();
//     message.reply = reader.read();
//     message.type = reader.read();
//     message.text = reader.read();
//     message.hash = reader.read();
//     message.createdAt = reader.read();
//
//     return message;
//   }
//
//   @override
//   void write(BinaryWriter writer, Message obj) {
//     writer.write(obj.id);
//     writer.write(obj.author);
//     writer.write(obj.chat);
//     writer.write(obj.reply);
//     writer.write(obj.type);
//     writer.write(obj.text);
//     writer.write(obj.hash);
//     writer.write(obj.createdAt);
//   }
//
//
// }