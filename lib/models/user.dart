import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:threec/services/urls.dart';
import 'package:threec/store.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

part "user.g.dart";

@HiveType(typeId : 21)
enum Role{
@HiveField(0)
user,

@HiveField(1)
admin,
}

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String email;
  @HiveField(3)
  Role role;
  @HiveField(4)
  Uint8List avatarUint8List ;

  User({this.id = "", this.username = "", this.email = ""});

  setRole(String stringRole){
    switch(stringRole){
      case "admin":
        role = Role.admin;
        break;

      case "user" :
        role = Role.user;
        break;
    }
  }

  updateAvatar() async {

    // avatar = NetworkImage(avatarPath(username),headers: {"Authorization":"Bearer " + Store().storeBox.get("jwtToken")});
    // avatar.obtainKey(createLocalImageConfiguration(context))
    // print("avatar downloaded $avatar");

    Dio dio = new Dio();

    try{
      var res =  await dio.get(avatarPath(id),options: Options(responseType: ResponseType.bytes,headers: {"Authorization":"Bearer " + Store().storeBox.get("jwtToken")}));
      avatarUint8List = Uint8List.fromList(res.data) ;
      print("get avatar");
      save();
    } on DioError catch(e){
      print(e);
    }

  }

  toString() => 'User{id: $id, username: $username}';
}


//
// class UserAdapter extends TypeAdapter<User> {
//   @override
//   final typeId = 1;
//
//   @override
//   User read(BinaryReader reader) {
//     User user = new User();
//     user.id = reader.read();
//     user.email = reader.read();
//     user.username = reader.read();
//     user.role = reader.read();
//
//     return user;
//   }
//
//   @override
//   void write(BinaryWriter writer, User obj) {
//     writer.write(obj.id);
//     writer.write(obj.email);
//     writer.write(obj.username);
//     writer.write(obj.role);
//   }
// }
