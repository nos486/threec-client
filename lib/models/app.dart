import 'package:hive/hive.dart';
import 'package:threec/models/chat.dart';
part "app.g.dart";


@HiveType(typeId: 0)
class App extends HiveObject {
  @HiveField(0)
  String jwtToken;
  @HiveField(1)
  String refreshToken;
  @HiveField(2)
  Chat selectedChat;

  App();

  @override
  String toString() {
    return "token: $jwtToken, refreshToken: $refreshToken";
  }

}

// class AppAdapter extends TypeAdapter<App> {
//   @override
//   final typeId = 0;
//
//   @override
//   App read(BinaryReader reader) {
//     App app = new App();
//     app.jwtToken = reader.read();
//     app.refreshToken = reader.read();
//     app.selectedChat = reader.read();
//
//     return app;
//   }
//
//   @override
//   void write(BinaryWriter writer, App obj) {
//     writer.write(obj.jwtToken);
//     writer.write(obj.refreshToken);
//     writer.write(obj.selectedChat);
//   }
// }
