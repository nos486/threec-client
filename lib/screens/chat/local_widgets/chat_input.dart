
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:threec/models/chat.dart';
import 'package:threec/screens/chat/local_widgets/mic_input.dart';
import 'package:threec/socket.dart';
import 'package:threec/utils/encryption.dart';

class ChatInput extends StatefulWidget {
  final Chat chat;

  const ChatInput({
    Key key, this.chat,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {

  TextEditingController textEditMessage = TextEditingController();
  Encryption encryption = Encryption();
  Socket socket = WS().socket;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MicInput(),
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
                        controller: textEditMessage,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Type message',
                        ),
                        onSubmitted: (data)=> sendMessage(),
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
                      onPressed: sendMessage,
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

  sendMessage(){

    Map message = {
      'chat' : widget.chat.id,
      'text': encryption.encryptMessage(textEditMessage.text),
      'hash': encryption.toMd5(textEditMessage.text)
    };

    socket.emit("newMessage",message);

    textEditMessage.text = "" ;
  }
}
