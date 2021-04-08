import 'package:flutter/material.dart';
import 'package:threec/models/message.dart';
import 'package:threec/screens/chat/local_widgets/message.dart';


class MessageList extends StatefulWidget {
  final chat;
  final user;

  const MessageList({Key key, this.chat, this.user}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {

  ScrollController scrollController = new ScrollController();
  int len = 0;


  @override
  void initState() {
    super.initState();
    len = widget.chat.messages.length;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.chat.messages.length > len){
      len = widget.chat.messages.length-1;
      scrollToEnd();
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        addAutomaticKeepAlives: true,
        scrollDirection: Axis.vertical,
        controller: scrollController,
        // reverse: true,
        children: [
          for(Message message in widget.chat.messages)
          // Text(message.author.username)
            MessageWidget(message: message, user: widget.user,refresh: (){setState(() {});},)
        ],
      ),
    );
  }

  Future scrollToEnd() async {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
