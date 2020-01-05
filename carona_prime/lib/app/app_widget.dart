import 'package:carona_prime/app/pages/home/home_module.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Carona Prime',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          backgroundColor: Colors.white,
          bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFFe64a19)),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.all(16),
            labelStyle: TextStyle(fontSize: 24),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          buttonTheme: ButtonThemeData(
            height: 50,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            disabledColor: Colors.grey[300],
            splashColor: Colors.white24,
          ),
          textTheme: TextTheme(
              button: TextStyle(fontSize: 14),
              body1: TextStyle(color: Colors.black, fontSize: 14)),
        ),
        home: HomeModule());
  }
}
