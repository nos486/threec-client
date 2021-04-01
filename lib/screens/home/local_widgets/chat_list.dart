
import 'package:flutter/material.dart';
import 'package:threec/models/chat.dart';
import 'package:threec/models/user.dart';

enum ChatMenu { clear ,delete,backup }

class ChatList extends StatefulWidget {
  final List<Chat> chats;
  final Chat selectedChat;
  final Function chatClicked ;

  const ChatList({Key key,@required this.chats,@required this.selectedChat,@required this.chatClicked}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for(Chat chat in widget.chats)
          ListTile(
            title: Text(chat.name.toUpperCase(),),
            // subtitle: Text((chat.lastMessage != null) ? chat.lastMessage.text: "no messages"),
            leading: Stack(
              children: [
                CircleAvatar(
                  child: Text(chat.name[0].toUpperCase(),style: TextStyle(color: Colors.white),),
                  backgroundColor: Colors.cyan,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                        color: Colors.cyan.shade800,
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 2,
                            color: Colors.white
                        )
                    ),
                  ),
                )
              ],
            ),
            trailing: buildPopupMenuButtonChat(),
            onTap: () => widget.chatClicked(chat),

            // if (widget.isWide){
            //   widget.selectedChatUpdate(chat);
            // }else{
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => MessageLayout(chat: chat,user: widget.user,)));
            //   widget.selectedChatUpdate(null);
            // }

            selected: (widget.selectedChat!=null && widget.selectedChat.id == chat.id),
            selectedTileColor: Colors.cyan.shade50,
          ),
      ],
    );
  }

  PopupMenuButton<ChatMenu> buildPopupMenuButtonChat() {
    return PopupMenuButton<ChatMenu>(
      onSelected: (ChatMenu result) { setState(() { print(result);}); },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ChatMenu>>[
        const PopupMenuItem<ChatMenu>(
          value: ChatMenu.backup,
          child: ListTile(
            leading: Icon(Icons.backup),
            title: Text('Backup'),
          ),
        ),
        const PopupMenuItem<ChatMenu>(
          value: ChatMenu.clear,
          child: ListTile(
            leading: Icon(Icons.cleaning_services_rounded),
            title: Text('Clear Chats'),
          ),
        ),
        const PopupMenuItem<ChatMenu>(
          value: ChatMenu.delete,
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Chat'),
          ),
        ),
      ],
    );
  }
}
