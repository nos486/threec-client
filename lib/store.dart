library threex.store;

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:threec/models/app.dart';
import 'package:threec/models/message.dart';
import 'models/chat.dart';
import 'models/user.dart';

// String appName = "app name" ;
// User user = new User(id: "54354353",name: "Sina",email: "nos486@gmail.com");
//  List<Chat> chats = [
//   new Chat(id: 1,name: "global chat",type: ChatType.public,users: [],admin: user,createdAt: new DateTime.now()),
//   new Chat(id: 2,name: "Mina",type: ChatType.public ,users: [],admin: user,createdAt: new DateTime.now()),
// ];

class Store {

  Box storeBox;
  Box userBox;
  Box chatBox;
  Box messageBox;

  static final Store _store = Store._internal();

  factory Store() {
   return _store;
  }

  Store._internal();

  initHive() async {
   await Hive.initFlutter();

   Hive.registerAdapter(MessageAdapter());
   Hive.registerAdapter(AppAdapter());
   Hive.registerAdapter(RoleAdapter());
   Hive.registerAdapter(UserAdapter());
   Hive.registerAdapter(ChatAdapter());

   await openBoxes();
  }

  openBoxes() async {
    storeBox = await Hive.openBox('store');
    userBox = await Hive.openBox<User>('users');
    chatBox = await Hive.openBox<Chat>('chats');
    messageBox = await Hive.openBox<Message>('messages');
  }

  closeBoxes() async {
    await storeBox.close();
    await userBox.close();
    await chatBox.close();
    await messageBox.close();
  }

}