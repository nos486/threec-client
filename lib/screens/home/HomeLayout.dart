import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:threec/dialogs/encryption.dart';
import 'package:threec/dialogs/settings.dart';
import 'package:threec/models/chat.dart';
import 'package:threec/models/user.dart';
import 'package:threec/screens/home/local_widgets/chat_list.dart';
import 'package:threec/screens/home/local_widgets/socket_status.dart';
import 'package:threec/services/urls.dart';
import 'package:threec/socket.dart';
import 'package:threec/store.dart';

class HomeLayout extends StatefulWidget {
  final bool isWide;
  final List<Chat> chats;
  final User user;
  final Chat selectedChat;
  final Function chatClicked;
  HomeLayout({Key key,@required this.chats, this.chatClicked, this.isWide= false,@required this.selectedChat,@required this.user}) : super(key: key) ;

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

enum MainMenu { encryption ,setting, logout }

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
          SocketStatus(),
          Expanded(
            child: ChatList(
              chats: widget.chats,
              selectedChat: widget.selectedChat,
              chatClicked: (chat) => widget.chatClicked(chat),
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.message,color: Colors.white),
      )
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
            // backgroundImage : (widget.user.avatarUint8List != null) ? Image.memory(widget.user.avatarUint8List).image : null,
            backgroundImage : Image.network(avatarPath(widget.user.id),headers: {"Authorization":"Bearer " + Store().storeBox.get("jwtToken")}).image ,
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
                await Store().messageBox.clear();
                await Hive.deleteFromDisk();
                await Store().closeBoxes();

                print(2);
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

