
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:threec/models/chat.dart';
import 'package:threec/models/message.dart';
import 'package:threec/models/user.dart';
import 'package:threec/services/urls.dart';
import 'package:threec/store.dart';



class WS {

  static final WS _socket = WS._internal();
  Socket socket;
  bool firstConnect = true;
  List<Function> chatCallbacks =[];
  Function chatRefresh = (){};
  Function socketIsConnectCallback = (){};

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

    socket.on("reconnecting",(_){
      socketIsConnectCallback(false);
    });

    socket.onConnect((_) {
      socketIsConnectCallback(true);

      if(firstConnect){
        socket.emit("getChats");
        firstConnect = false ;
      }

      socket.emit('msg', 'test');
    });

    socket.onDisconnect((_) {
      firstConnect = true;
      // socketStatusChange("Disconnect");
      print('disconnect');
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

        Chat chat;
        if(Store().chatBox.containsKey(chatData["id"])){
          //get old chat
          chat = Store().chatBox.get(chatData["id"]);
        }else{
          //create new chat
          chat = new Chat(chatData["id"]);
          chat.messages =HiveList(Store().messageBox);
          chat.users = HiveList(Store().userBox);
        }

        //new or update chat
        chat.name = chatData["name"];
        chat.username= chatData["username"];
        chat.type= chatData["type"];
        chat.admin = Store().userBox.get(chatData["admin"]);

        chat.users.addAll(users);
        Store().chatBox.put(chat.id, chat);

        // socket.emit("getMessages",{"chat":chat.id});
      }

      //chat callback
      for(Function callback in chatCallbacks){
        callback();
      }

      chatRefresh();
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
        Message message ;

        if(Store().messageBox.containsKey(messageData["id"])){

          //get saved message
          message = Store().messageBox.get(messageData["id"]);
          if(message.hash != messageData["hash"]){
            message.text =  messageData["text"];
            message.hash =  messageData["hash"];
            message.decrypted = false;
            message.decrypt();
            message.save();
            print("message edit");
          }
          
        }else{

          //create new message
          message = new Message();
          message.id = messageData["id"];
          message.author =  Store().userBox.get(messageData["author"]);
          message.chat =  Store().chatBox.get(messageData["chat"]);
          message.reply = messageData["reply"];
          message.text =  messageData["text"];
          message.hash =  messageData["hash"];
          message.createdAt = DateTime.parse(messageData["createdAt"]);

          Store().messageBox.put(message.id, message);
          message.decrypt();
          message.save();

          Chat chat = Store().chatBox.get(messageData["chat"]);
          chat.messages.add(message);
          chat.save();
        }
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


    socket.on('fromServer', (_) => print(_));
  }
}

