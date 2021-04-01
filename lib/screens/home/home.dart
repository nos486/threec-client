import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:threec/screens/chat/chat.dart';
import 'package:threec/screens/home/HomeLayout.dart';
import 'package:threec/models/chat.dart';
import 'package:threec/models/user.dart';

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
  WS ws = WS() ;

  @override
  initState() {
    super.initState();

    //run after build
    WidgetsBinding.instance.addPostFrameCallback((_){
      // selectedChat = Store().chatBox.get(Store().storeBox.get("selectedChatId"));
      ws.socket.connect();
      // ws.chatRefresh = (){
      //   print("ee");
      //   setState(() {
      //   });
      // };
      ws.chatCallbacks.add((){
        setState(() {});
      });
    });

    chats = Store().chatBox.values.toList();
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

  Widget homeLayout({bool isWide = false}) {
    return HomeLayout(
      chats: chats,
      chatClicked: (Chat chat) {
        if (isWide){
          chatChange(chat);
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => MessageLayout(chat: chat,user: user,)));
          chatChange(null);
        }
      },isWide: isWide,selectedChat: selectedChat,user: user,);
  }

  chatChange(Chat chat){
      Store().storeBox.put("selectedChatId", chat.id);
      setState(() {
        selectedChat = Store().chatBox.get(chat.id);
        print(selectedChat.messages.length);
      });

      if(chat != null ){
        if(ws.socket.connected){
          ws.socket.emit("getMessages",{"chat":chat.id});
          ws.chatRefresh = (){
            print("ee");
            setState(() {
              selectedChat = Store().chatBox.get(chat.id);
            });
          };
        }
      }

  }
}



