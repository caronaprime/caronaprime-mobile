import 'package:carona_prime/app/application_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = LoginBase with _$LoginController;

abstract class LoginBase with Store {
  var applicationController = GetIt.I.get<ApplicationController>();
  var _auth = FirebaseAuth.instance;
  String _verificationId;
  var phoneTextController = TextEditingController();
  var codeTextController = TextEditingController();

  @observable
  bool logado = false;

  @observable
  String phoneNumber = "";

  @observable
  String codeNumber = "";

  @observable
  String status = "";

  @action
  void setPhoneNumber(String value) => phoneNumber = value;

  @action
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

          applicationController.logar();
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

  @action
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

  Future<void> entrar(BuildContext context, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _verificationId, smsCode: smsCode);

      AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      print('Usuário logado com sucesso $user');
      applicationController.logar();
      while (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      print("verificaPhone ERROR: ${e.toString()}");
    }
  }
}
