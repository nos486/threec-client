import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:threec/screens/chat/chat.dart';
import 'package:threec/screens/home/HomeLayout.dart';
import 'package:threec/models/Chat.dart';
import 'package:threec/models/User.dart';

import 'package:threec/socket.dart';
import 'package:threec/store.dart';
import '../../store.dart' as store;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Chat> chats = [];
  User user = Store().userBox.get("_self");
  Chat selectedChat ;
  // Chat selectedChat = Store().chatBox.get(Store().storeBox.get("selectedChatId"));

  @override
  initState() {
    super.initState();
    //run after build
    WidgetsBinding.instance.addPostFrameCallback((_){
      WS().socket.connect();
      WS().chatCallbacks.add((){
        setState(() {
          chats = Store().chatBox.values.toList();
          selectedChat = Store().chatBox.get(Store().storeBox.get("selectedChatId").toString());
        });
      });
    });

    // User mina = new User(id: "2321",name:"Mina",email:"");
    // store.chats[0].newMessages = 33;
    // store.chats[0].messages = [
    //   new Message(id: 213,text: "Hi :)",author: store.user,type: MessageType.text,createdAt: new DateTime.now()),
    //   new Message(id: 2132,text: "Whats up?",author: store.user,type: MessageType.text,createdAt: new DateTime.now()),
    //   new Message(id: 2113,text: "How are you?",author:mina ,type: MessageType.text,createdAt: new DateTime.now()),
    //   new Message(id: 21322,text: "Thanks,\nWhat about you ? is anything ok ? :)))",author: store.user,type: MessageType.text,createdAt: new DateTime.now()),
    // ];


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return homeLayout();
          } else {
            return Row(
              children: [
                Expanded(child: homeLayout(isWide: true) ,flex: 4,),
                Expanded(child: selectedChat != null ? MessageLayout(chat: selectedChat ,user: user,): Placeholder(),flex: 7),

                // Expanded(child: Placeholder(),flex: 7)
              ],
            );
          }

        }),
      ),
    );
  }

  Widget homeLayout({bool isWide=false}){
    return HomeLayout(chats: chats, selectedChatUpdate: (Chat chat){
      Store().storeBox.put("selectedChatId", chat.id) ;
      setState(() {
        selectedChat = chat;
      });
    },isWide: isWide,selectedChat: selectedChat,user: user,);
  }
}
