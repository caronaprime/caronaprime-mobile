import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/pages/grupo/grupo_page.dart';
import 'package:carona_prime/app/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase {
  var _auth = FirebaseAuth.instance;
  String _verificationId;
  var phoneTextController = TextEditingController();
  var codeTextController = TextEditingController();

  var _logadoBehavior = BehaviorSubject<bool>();
  Stream<bool> get outLogado => _logadoBehavior.stream;

  var _phoneNumberBehavior = BehaviorSubject<String>();
  Stream<String> get outPhoneNumber => _phoneNumberBehavior.stream;

  var _codeNumberBehavior = BehaviorSubject<String>();
  Stream<String> get outCodeNumber => _codeNumberBehavior.stream;

  var _statusBehavior = BehaviorSubject<String>();
  Stream<String> get outStatus => _statusBehavior.stream;

  Future<void> entrar(BuildContext context, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _verificationId, smsCode: smsCode);

      AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;  
      print('Usuário logado com sucesso $user');
      _logadoBehavior.sink.add(true);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GrupoPage()));
    } catch (e) {
      print("verificaPhone ERROR: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    _phoneNumberBehavior.close();
    _codeNumberBehavior.close();
    _statusBehavior.close();
    _logadoBehavior.close();
    super.dispose();
  }

  setPhoneNumber(String value) => _phoneNumberBehavior.add(value);
  setCode(String value) => _codeNumberBehavior.add(value);

  enviarCodigo(BuildContext context) async {
    try {
      final phoneNumber = "+55" +
          phoneTextController.text
              .replaceAll("(", "")
              .replaceAll(")", "")
              .replaceAll("-", "");
      if (phoneTextController.text.length >= 11) {
        final PhoneVerificationCompleted verificationCompleted =
            (AuthCredential phoneAuthCredential) {
          _auth.signInWithCredential(phoneAuthCredential);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
          print('Auto login realizado: user');
        };

        final PhoneVerificationFailed verificationFailed =
            (AuthException authException) {
          print(
              'Verificação para o número ${phoneNumber.toString()} falhou. Código: ${authException.code}. Motivo: ${authException.message}');
        };

        final PhoneCodeSent codeSent =
            (String verificationId, [int forceResendingToken]) async {
          _verificationId = verificationId;
          print("Código enviado para " + phoneNumber);
        };

        final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
            (String verificationId) {
          _verificationId = verificationId;
          print("Tempo limite esgotado!");
        };

        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: Duration(seconds: 30),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      }
    } catch (e) {
      print("_signInWithPhoneNumber ERROR: ${e.toString()}");
    }
  }

  void mostrarDialogoCodigo(BuildContext context) {
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
                  onPressed: () => entrar(context, codeTextController.text)),
            ],
          );
        });
  }
}
