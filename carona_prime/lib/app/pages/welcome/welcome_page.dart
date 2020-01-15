import 'package:carona_prime/app/pages/inicio/inicio_controller.dart';
import 'package:carona_prime/app/shared/widgets/logo_carona.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  final PageController pageController;
  final InicioController inicioController;

  WelcomePage(this.inicioController, this.pageController);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF424242),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text(
              'Prosseguir',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              int nextIndex = 1;                            
              widget.pageController.animateToPage(nextIndex, duration: Duration(milliseconds: 300), curve: Curves.decelerate);           
              widget.inicioController.setPageIndex(nextIndex);
            },
          ),
        ],
      )),
      body: Center(
        child: ListView(
          shrinkWrap: false,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 60.0),
            LogoCarona(),
            SizedBox(height: 25.0),
            welcomeLabel()
          ],
        ),
      ),
    );
  }

  Center welcomeLabel() {
    return Center(
        child: Text('Bem vindo ao Carona Prime',
            style: TextStyle(color: Colors.white, fontSize: 18)));
  }
}
