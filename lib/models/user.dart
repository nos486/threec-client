import 'package:hive/hive.dart';
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
