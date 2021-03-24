library threex.store;

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:threec/models/App.dart';
import 'package:threec/models/Message.dart';
import 'package:threec/models/server.dart';
import 'models/Chat.dart';
import 'models/User.dart';

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

   Hive.registerAdapter(AppAdapter());
   Hive.registerAdapter(UserAdapter());
   Hive.registerAdapter(ChatAdapter());
   Hive.registerAdapter(MessageAdapter());

   storeBox = await Hive.openBox('store');
   userBox = await Hive.openBox<User>('users');
   chatBox = await Hive.openBox<Chat>('chats');
   messageBox = await Hive.openBox<Message>('messages');

   print("init down");
  }


  // Chat get selectedChat => _selectedChat;
  //
  // set selectedChat(Chat value) {
  //   _selectedChat = value;
  // }

// String _appName = "ThreeC" ;
  //
  // String get appName => _appName;
  //
  // set appName(String value) {
  //   _appName = value;
  // }
}