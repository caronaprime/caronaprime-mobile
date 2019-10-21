import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/pages/login_mode/login_mode_page.dart';
import 'package:carona_prime/app/widgets/logo_carona.dart';
import 'package:flutter/material.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _bloc = AppModule.to.getBloc<LoginBloc>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carona Prime')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: LogoCarona(),
          ),
          Expanded(flex: 2, child: SizedBox()),
          Center(child: Text("Informe seu número de celular")),
          Expanded(flex: 2, child: SizedBox()),
          phoneTextField(),
          loginButton(),
          forgotLabel(),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
    );
  }

  FlatButton forgotLabel() {
    return FlatButton(
      child: Text('Para que servem esses dados?',
          style: TextStyle(color: Colors.black54)),
      onPressed: () {},
    );
  }

  loginButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text("Entrar"),
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginModePage()));
        },
      ),
    );
  }

  phoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _bloc.phoneController,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: InputDecoration(
          labelText: "Celular",
          hintText: 'Ex: (99) 9 9999 9999 ',
        ),
      ),
    );
  }
}
