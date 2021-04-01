
import 'package:hive/hive.dart';
import 'package:threec/models/message.dart';
import 'package:threec/store.dart';
import 'user.dart';
part "chat.g.dart";

enum ChatType { public, private }


@HiveType(typeId: 2)
class Chat extends HiveObject{
  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String name;
  @HiveField(3)
  String type;
  @HiveField(4)
  User admin;
  @HiveField(5)
  HiveList<User> users ;
  @HiveField(6)
  DateTime createdAt;
  @HiveField(7)
  int newMessages = 0;
  @HiveField(8)
  HiveList<Message> messages ;

  Chat(this.id);

}
//
// class ChatAdapter extends TypeAdapter<Chat> {
//   @override
//   final typeId = 2;
//
//   @override
//   Chat read(BinaryReader reader) {
//     Chat chat = new Chat();
//     chat.id = reader.read();
//     chat.username = reader.read();
//     chat.name = reader.read();
//     chat.type = reader.read();
//     chat.admin = reader.read();
//     chat.users = reader.read();
//     chat.createdAt = reader.read();
//     chat.newMessages = reader.read();
//     chat.messages = reader.read();
//
//     return chat;
//   }
//
//   @override
//   void write(BinaryWriter writer, Chat obj) {
//     writer.write(obj.id);
//     writer.write(obj.username);
//     writer.write(obj.name);
//     writer.write(obj.type);
//     writer.write(obj.admin);
//     writer.write(obj.users);
//     writer.write(obj.createdAt);
//     writer.write(obj.newMessages);
//     writer.write(obj.messages);
//   }
//
//
// }