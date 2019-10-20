import 'package:carona_prime/app/pages/login/login_page.dart';
import 'package:carona_prime/app/widgets/logo_carona.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text('Prosseguir'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
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
          style: Theme.of(context).textTheme.body2),
    );
  }
}
