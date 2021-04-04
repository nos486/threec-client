
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:threec/models/message.dart';
import 'package:threec/models/user.dart';
import 'package:intl/intl.dart' as intl;
import 'package:threec/screens/chat/local_widgets/message_content.dart';
import 'package:threec/screens/chat/local_widgets/message_decryptor.dart';
import 'package:threec/socket.dart';

enum MessageMenu { reply,remove, copy}

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    Key key,
    @required this.message,
    @required this.user,
    @required this.refresh,
  }) : super(key: key);

  final Function refresh;
  final Message message;
  final User user;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  Socket socket = WS().socket ;

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
              PopupMenuButton<MessageMenu>(
                child: CircleAvatar(
                  child: Text(widget.message.author.username[0].toUpperCase(),style: TextStyle(color: Colors.cyan.shade900),),
                  radius: 16,
                  backgroundColor: Colors.cyan.shade100,
                ),
                onSelected: (MessageMenu result) {
                  switch (result){
                    case MessageMenu.reply:
                      // TODO: Handle this case.
                      break;
                    case MessageMenu.remove:
                      socket.emit("deleteMessage",widget.message.id);
                      // widget.message.delete();
                      // widget.refresh();
                      break;
                    case MessageMenu.copy:
                      // TODO: Handle this case.
                      break;
                  }
                },
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
                  if (widget.user.role == Role.admin || widget.message.author.id == widget.user.id) const PopupMenuItem<MessageMenu>(
                    value: MessageMenu.remove,
                    child: ListTile(
                      leading: Icon(Icons.delete_forever),
                      title: Text('Delete'),
                    ),
                  ),
                ],
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
          Flexible(child: Container(
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
                  if (widget.message.decrypted) MessageContent(
                    message: widget.message,
                    user: widget.user,
                  ) else MessageDecryptor(
                    message: widget.message,
                    refresh: (){
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          )),

        ],
      ),
    );
  }
}
