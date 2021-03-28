import 'package:flutter/material.dart';
import 'package:threec/models/Message.dart';
import 'package:threec/models/User.dart';

class MessageContent extends StatelessWidget {
  final Message message;
  final User user;

  const MessageContent({
    Key key,
    @required this.message, @required this.user,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      message.decryptedText,
      style: TextStyle(
        color: message.author == user ? Colors.white : Colors.cyan.shade900,
      ),
    );
  }
}
