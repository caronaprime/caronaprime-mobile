import 'package:carona_prime/app/pages/inicio/inicio_controller.dart';
import 'package:carona_prime/app/pages/login/login_page.dart';
import 'package:carona_prime/app/pages/politica_privacidade/politica_privacidade_page.dart';
import 'package:carona_prime/app/pages/termos_uso/termos_uso_page.dart';
import 'package:carona_prime/app/pages/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final pageController = PageController();
  final controller = InicioController();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          WelcomePage(controller, pageController),
          TermosUsoPage(controller, pageController),
          PoliticaPrivacidadePage(controller, pageController),
          LoginPage(controller, pageController),
        ],
      ),
    );
  }
}
