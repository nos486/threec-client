import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:threec/dialogs/encryption.dart';
import 'package:threec/dialogs/settings.dart';
import 'package:threec/screens/chat/chat.dart';
import 'package:threec/models/Chat.dart';
import 'package:threec/models/User.dart';
import 'package:threec/socket.dart';
import 'package:threec/store.dart';

class HomeLayout extends StatefulWidget {
  final bool isWide;
  final List<Chat> chats;
  final User user;
  final Chat selectedChat;
  final Function selectedChatUpdate;
  HomeLayout({Key key,@required this.chats, this.selectedChatUpdate, this.isWide= false,@required this.selectedChat,@required this.user}) : super(key: key) ;

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

enum MainMenu { encryption ,setting, logout }
enum ChatMenu { clear ,delete,backup }


class _HomeLayoutState extends State<HomeLayout> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
                    trailing: PopupMenuButton<ChatMenu>(
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
                    ),
                    onTap: (){
                      if (widget.isWide){
                        widget.selectedChatUpdate(chat);
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MessageLayout(chat: chat,user: widget.user,)));
                        widget.selectedChatUpdate(null);
                      }
                    },
                    selected: (widget.selectedChat!=null && widget.selectedChat.id == chat.id),
                    selectedTileColor: Colors.cyan.shade50,
                  ),
              ],
            ),flex: 4,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.message,color: Colors.white),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 0,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
      //   ],
      // ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.cyan.shade300,
      brightness: Brightness.light,
      elevation: 0,
      toolbarHeight: 120,
      title: Row(
        children: [
          CircleAvatar(
            child: Icon(Icons.accessibility_new_sharp,size: 50,color: Colors.cyan.shade900,),
            backgroundColor: Colors.cyan,
            minRadius: 40.0,
          ),
          SizedBox(width: 8,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.username,
                  style: TextStyle(color: Colors.white, fontSize: 30.0,fontWeight: FontWeight.bold),
                ),
                Text(widget.user.email,
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 12.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          buildPopupMenuButtonMain()
        ],
      ),
    );
  }

  PopupMenuButton<MainMenu> buildPopupMenuButtonMain() {
    return PopupMenuButton<MainMenu>(
          onSelected: (MainMenu result) async {
            switch(result){
              case MainMenu.encryption:
                showDialog(
                    context: context,
                    builder: (_) => EncryptionDialog()
                );
                break;
              case MainMenu.setting:
                showDialog(
                    context: context,
                    builder: (_) => SettingDialog()
                );
                break;
              case MainMenu.logout :
                await Store().userBox.clear();
                await Store().chatBox.clear();
                await Store().storeBox.clear();
                WS().socket.disconnect();
                Navigator.pushReplacementNamed(context, '/login');
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MainMenu>>[
            const PopupMenuItem<MainMenu>(
              value: MainMenu.encryption,
              child: ListTile(
                leading: Icon(Icons.enhanced_encryption),
                title: Text('Encryption'),
              ),
            ),
            const PopupMenuItem<MainMenu>(
              value: MainMenu.setting,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ),
            const PopupMenuItem<MainMenu>(
              value: MainMenu.logout,
              child: ListTile(
                leading: Icon(Icons.logout,color: Colors.red,),
                title: Text('Logout',style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        );
  }


}

