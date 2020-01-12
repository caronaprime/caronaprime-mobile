import 'package:carona_prime/app/pages/grupo/lista_grupo/lista_grupo_page.dart';
import 'package:carona_prime/app/pages/inicio/inicio_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'application_controller.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var applicationController = GetIt.I.get<ApplicationController>();

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
              body1: TextStyle(color: Colors.black, fontSize: 14),
              body2: TextStyle(
                  color: Colors.black54, fontSize: 20, wordSpacing: 2)),
        ),
        home: Observer(
          builder: (_) {
            if (applicationController.logado) return ListaGrupoPage();

            return InicioPage();
          },
        ));
  }
}
