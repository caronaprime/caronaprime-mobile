import 'package:flutter/material.dart';
import 'package:carona_prime/app/pages/home/home_module.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carona Prime',
      theme: ThemeData(    
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.white,        
        primaryColor: Color(0xFFe64a19),
        primaryColorLight: Color(0xFFff7d47),
        primaryColorDark: Color(0xFFac0800),
        backgroundColor: Color(0xFF424242),
        bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFFe64a19)),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(16),
          labelStyle: TextStyle(fontSize: 24),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        buttonTheme: ButtonThemeData(          
          height: 50,
          textTheme: ButtonTextTheme.accent,
          shape: RoundedRectangleBorder(            
            borderRadius: BorderRadius.circular(10.0),
          ),
          disabledColor: Colors.grey[300],          
          splashColor: Colors.white24,
        ),
        textTheme: TextTheme(
          button: TextStyle(fontSize: 18.0),
          body1: TextStyle(color: Colors.black, fontSize: 18)          
        ),
      ),
      home: HomeModule(),
    );
  }
}
