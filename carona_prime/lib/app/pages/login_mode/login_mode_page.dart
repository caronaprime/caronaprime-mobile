import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/enums/modo_login.dart';
import 'package:carona_prime/app/pages/home/home_page.dart';
import 'package:flutter/material.dart'; 
import 'login_mode_bloc.dart';

class LoginModePage extends StatefulWidget {
  @override
  _LoginModePageState createState() => _LoginModePageState();
}

class _LoginModePageState extends State<LoginModePage> {
  bool pressAttention = true;
  var _bloc = AppModule.to.bloc<LoginModeBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carona Prime')),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text('Prosseguir'),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Text("Selecione o modo de uso")),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                caroneiroButton(),
                motoristaButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  motoristaButton() =>
      modoButton(ModoDeLogin.motorista, Icons.directions_car, "Motorista");
  caroneiroButton() =>
      modoButton(ModoDeLogin.caroneiro, Icons.directions_walk, "Caroneiro");

  modoButton(ModoDeLogin modo, IconData icon, String label) {
    return StreamBuilder(
      stream: _bloc.outModoDeLogin,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(300)),
              onPressed:
                  snapshot.data == modo ? null : () => _bloc.setModo(modo),
              child: Icon(icon, size: 80),
            ),
            Text(label)
          ],
        );
      },
    );
  }
}
