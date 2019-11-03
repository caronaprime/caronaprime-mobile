import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase {
  bool _loginSucesso = true;
  var phoneTextController = TextEditingController();
  var codeTextController = TextEditingController();

  var _phoneNumberBehavior = BehaviorSubject<String>();
  Stream<String> get outPhoneNumber => _phoneNumberBehavior.stream;

  var _codeNumberBehavior = BehaviorSubject<String>();
  Stream<String> get outCodeNumber => _codeNumberBehavior.stream;

  var _statusBehavior = BehaviorSubject<String>();
  Stream<String> get outStatus => _statusBehavior.stream;

  entrar(BuildContext context) async {
    if (_loginSucesso) {
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void dispose() {
    _phoneNumberBehavior.close();
    _codeNumberBehavior.close();
    _statusBehavior.close();
    super.dispose();
  }

  setPhoneNumber(String value) => _phoneNumberBehavior.add(value);
  setCode(String value) => _codeNumberBehavior.add(value);

  enviarCodigo(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Informe o código recebido"),
            content: TextFormField(
              controller: codeTextController,
            ),
            actions: <Widget>[
              FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text("Fechar"),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text("Entrar"),
                  onPressed: () => entrar(context)),
            ],
          );
        });
  }
}
