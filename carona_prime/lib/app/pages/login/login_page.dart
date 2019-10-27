import 'package:carona_prime/app/app_module.dart';
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
          code(),
          phoneTextField(),
          loginButton(),
          forgotLabel(),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
    );
  }

  code() {
    return StreamBuilder(
      stream: _bloc.outStatus,
      initialData: "",
      builder: (context, snapshot) {
        return Container(
          child: snapshot.hasData
              ? Text(snapshot.data)
              : CircularProgressIndicator(),
        );
      },
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
          child: Text("Entrar"), onPressed: () => _bloc.entrar(context)),
    );
  }

  phoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (value) => _bloc.setPhoneNumber(value),
        controller: _bloc.phoneTextController,
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
