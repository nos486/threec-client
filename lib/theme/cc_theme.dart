import 'package:flutter/material.dart';

class CCTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.cyan[400],
        primaryColor: Colors.cyan,
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: Colors.white,

        snackBarTheme: SnackBarThemeData(
          // behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey.shade300,
          contentTextStyle: TextStyle(
            color: Colors.grey.shade900
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              elevation: 0,
            padding: EdgeInsets.all(20),
            textStyle: TextStyle(
              color: Colors.white
            )
          ),
        ),
        appBarTheme: AppBarTheme(
            elevation: 0
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.cyan.shade800,
          selectionColor: Colors.cyan.shade200
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
        ),
        iconTheme: IconThemeData(
          color: Colors.cyan.shade900,
        ),
        textTheme: TextTheme(

          button: TextStyle(
              color: Colors.white
          ),
          bodyText2: TextStyle(color: Colors.cyan.shade900),
          // subtitle1: TextStyle(color: Colors.cyan.shade900)
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
        ),
      inputDecorationTheme: InputDecorationTheme(
      )

    );

  }
}
