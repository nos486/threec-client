
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:threec/models/Chat.dart';
import 'package:threec/models/Message.dart';
import 'package:threec/models/User.dart';
import 'package:threec/services/urls.dart';
import 'package:threec/store.dart';

class WS {

  static final WS _socket = WS._internal();
  Socket socket;
  bool firstConnect = true;
  List<Function> chatCallbacks =[];
  Function chatRefresh = (){};

  factory WS() {
    return _socket;
  }

  WS._internal(){
    initSocket();
  }


  initSocket(){

    socket = io(baseUrl, OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setQuery({'token': Store().storeBox.get("jwtToken")})
        .build()
    );

    socket.onError((data) {
      print(data);
    });

    socket.onConnectError((data) {
      print(data);
    });

    socket.onConnect((_) {
      print('connect');
      if(firstConnect){
        socket.emit("getChats");
        firstConnect = false ;
      }

      socket.emit('msg', 'test');
    });

    socket.on('chats', (chatsData) {

      List<User> users = [];
      for(var chatData in chatsData){
        print(chatData);
        for(var userId in chatData["users"]){

          if (Store().userBox.keys.contains(userId)){
            users.add(Store().userBox.get(userId));
          }else{
            socket.emit("getUser",userId);
            User user = new User(id: userId);
            Store().userBox.put(userId, user);
            users.add(user);
          }

        }

        Chat chat = new Chat(
          id: chatData["id"],
          name: chatData["name"],
            username: chatData["username"],
          type: chatData["type"],
          admin: Store().userBox.get(chatData["admin"]),
          users: HiveList(Store().userBox)
        );

        chat.messages = HiveList(Store().messageBox);
        chat.users.addAll(users);
        Store().chatBox.put(chat.id, chat);

        socket.emit("getMessages",{"chat":chat.id});
      }

      //chat callback
      for(Function callback in chatCallbacks){
        callback();
      }
    });

    socket.on('newUser', (userData) {
      print(userData);
      User user ;
      if (Store().userBox.keys.contains(userData["id"])){
        user = Store().userBox.get(userData["id"]);
      }else{
        user = new User(id: userData["id"]);
      }
      user.username = userData["username"];
      user.email = userData["email"];
      user.role = userData["role"];

      Store().userBox.put(userData["id"], user);
    });


    socket.on('newMessages', (messagesData) {

      for(var messageData in messagesData){
        print(messageData);
        Message message = new Message();
        message.id = messageData["id"];
        message.author =  Store().userBox.get(messageData["author"]);
        message.chat =  Store().chatBox.get(messageData["chat"]);
        message.reply = messageData["reply"];
        message.text =  messageData["text"];
        message.hash =  messageData["hash"];
        message.createdAt = DateTime.parse(messageData["createdAt"]);

        message.decrypt();

        Chat chat = Store().chatBox.get(messageData["chat"]);
        Store().messageBox.put(message.id, message);
        chat.messages.add(message);

      }

      chatRefresh();

    });

    socket.on('deleteMessage', (messageData) {
      Chat chat =  Store().chatBox.get(messageData["chat"]);
      chat.messages.cast<Message>().removeWhere((message){
        return message.id == messageData["id"]  ;
      });

      chatRefresh();
    });

    socket.onDisconnect((_) {
      firstConnect = true;
      print('disconnect');
    });
    socket.on('fromServer', (_) => print(_));
  }
}

