import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:threec/models/Chat.dart';
import 'package:threec/models/Message.dart';
import 'package:threec/models/User.dart';

enum MessageMenu { reply,remove, copy}


class MessageLayout extends StatefulWidget {

  final Chat chat;
  final User user;
  const MessageLayout({Key key,@required this.chat,@required this.user}) : super(key: key);

  @override
  _MessageLayoutState createState() => _MessageLayoutState();
}

class _MessageLayoutState extends State<MessageLayout> {

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
              child: ListView(
                reverse: true,
                children: [
                  for(Message message in widget.chat.messages.reversed)
                    // Text(message.author.username)
                    MessageWidget(message: message, user: widget.user)
                ],
              ),
            ),
            ChatInputWidget()
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

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    Key key,
    @required this.message,
    @required this.user,
  }) : super(key: key);

  final Message message;
  final User user;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        // mainAxisAlignment: message.author == user ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: widget.message.author.id == widget.user.id ? TextDirection.rtl : TextDirection.ltr ,
        children: [
          Column(
            children: [
              CircleAvatar(
                child: Text(widget.message.author.username[0].toUpperCase(),style: TextStyle(color: Colors.cyan.shade900),),
                radius: 16,
                backgroundColor: Colors.cyan.shade100,
              ),
              SizedBox(height: 2,),
              Text(
                intl.DateFormat('kk:mm').format(widget.message.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.cyan.shade900
                ),
              ),
            ],
          ),
          SizedBox(width: 4,),

          Flexible(
            child: PopupMenuButton<MessageMenu>(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.message.author == widget.user ? Colors.cyan.withOpacity(0.8) : Colors.cyan.shade50.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.message.author.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          fontSize: 15,
                          color: widget.message.author == widget.user ? Colors.white: Colors.cyan.shade900,
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        widget.message.text,
                        style: TextStyle(
                          color: widget.message.author == widget.user ? Colors.white : Colors.cyan.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onSelected: (MessageMenu result) { setState(() { print(result);}); },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MessageMenu>>[
                const PopupMenuItem<MessageMenu>(
                  value: MessageMenu.reply,
                  child: ListTile(
                    leading: Icon(Icons.reply),
                    title: Text('Reply'),
                  ),
                ),
                const PopupMenuItem<MessageMenu>(
                  value: MessageMenu.copy,
                  child: ListTile(
                    leading: Icon(Icons.copy),
                    title: Text('Copy'),
                  ),
                ),
                const PopupMenuItem<MessageMenu>(
                  value: MessageMenu.remove,
                  child: ListTile(
                    leading: Icon(Icons.delete_forever),
                    title: Text('Delete'),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class ChatInputWidget extends StatefulWidget {
  const ChatInputWidget({
    Key key,
  }) : super(key: key);

  @override
  _ChatInputWidgetState createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MicInputWidget(),
          SizedBox(width: 4,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.cyan.withOpacity(0.8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 20,),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: TextField(
                        // style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Type message',
                        ),
                        minLines: 1,
                        maxLines: 10,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,4,8,4),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: (){},
                      splashRadius: 24,
                      padding: EdgeInsets.only(left: 3.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MicInputWidget extends StatelessWidget {
  const MicInputWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.red.shade100.withOpacity(0.8),
      ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          icon: Icon(
            Icons.mic_rounded,
            color: Colors.red,
          ),
          onPressed: (){},
          splashRadius: 25,
          // padding: EdgeInsets.only(left: 3.0),
        ),
      ),
    );
  }
}




