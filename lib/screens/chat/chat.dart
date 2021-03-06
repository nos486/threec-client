import 'package:flutter/material.dart';
import 'package:threec/models/chat.dart';
import 'package:threec/models/message.dart';
import 'package:threec/models/user.dart';
import 'package:threec/screens/chat/local_widgets/chat_input.dart';
import 'package:threec/screens/chat/local_widgets/message.dart';
import 'package:threec/screens/chat/local_widgets/message_list.dart';
import 'package:threec/socket.dart';

class MessageLayout extends StatefulWidget {

  final Chat chat;
  final User user;
  const MessageLayout({Key key,@required this.chat,@required this.user}) : super(key: key);

  @override
  _MessageLayoutState createState() => _MessageLayoutState();
}

class _MessageLayoutState extends State<MessageLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WS().messageRefresh = (){
    //   print(widget.chat.id);
    //   setState(() {});
    // };
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/chat_back.png"),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
            fit: BoxFit.scaleDown,
            repeat: ImageRepeat.repeat
          )
        ),
        child: Column(
          children: [
            Expanded(
              child: MessageList(
                user: widget.user,
                chat: widget.chat,
              )
            ),
            ChatInput(
              chat: widget.chat,
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      // automaticallyImplyLeading: false,
      title: Row(
        children: [
          CircleAvatar(
            child: Text(widget.chat.name[0].toUpperCase(),style: TextStyle(color: Colors.cyan.shade900),),
            backgroundColor: Colors.cyan.shade100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(widget.chat.name),
          ),
        ],
      ),
      // backgroundColor: Colors.cyan,
      actions: [
        // ElevatedButton(onPressed: (){
        // }, child: Icon(Icons.close),style: ButtonStyle(
        //   shadowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states)=> Colors.transparent),
        //   backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states)=> Colors.transparent)
        // ),)
      ],
    );
  }
}



