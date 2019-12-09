import 'package:carona_prime/app/shared/widgets/default_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carona Prime')),
      drawer: DefaultDrawer(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Usuário: \n"
              "Numero: \n"
              "Status: ",
            ),
          ],
        ),
      ),
    );
  }
}
