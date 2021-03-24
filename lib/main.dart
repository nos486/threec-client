import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:threec/models/User.dart';
import 'package:threec/models/server.dart';
import 'package:threec/store.dart';
import 'package:threec/theme/cc_theme.dart';
import 'screens/home/home.dart';
import 'screens/login/login.dart';

Future<void> main() async {
  await Store().initHive();
  print("after 212121");

  runApp(GlobalLoaderOverlay(
    useDefaultLoading: true,
    overlayColor: Colors.cyan.shade200,
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: CCTheme.lightTheme,
        // home: Home(),
        initialRoute: "/login",
        routes: {
          "/login": (context) => Login(),
          "/home": (context) => Home(),
          // "/message": (context) => MessageLayout(),
        }),
  ));
}

initStore() async {

}


