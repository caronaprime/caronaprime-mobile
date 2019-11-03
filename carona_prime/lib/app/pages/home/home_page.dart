import 'package:carona_prime/app/pages/welcome/welcome_page.dart';
import 'package:carona_prime/app/widgets/default_drawer.dart';
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
      // bottomNavigationBar: BottomAppBar(
      //     child: Row(
      //   mainAxisSize: MainAxisSize.max,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: <Widget>[
      //     FlatButton(
      //       child: Text(
      //         'Voltar',
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 20.0,
      //         ),
      //       ),
      //       onPressed: () {
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => WelcomePage()));
      //       },
      //     ),
      //   ],
      // )),
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
