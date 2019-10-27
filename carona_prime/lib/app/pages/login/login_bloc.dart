import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/pages/login_mode/login_mode_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase {
  var phoneTextController = TextEditingController();
  var firebaseAuth = FirebaseAuth.instance;

  AuthCredential _authCredential;

  String _phoneNumber;
  String verificationId;

  LoginBloc() {
    _phoneNumberBehavior.listen((value) => _phoneNumber = value);
  }

  var _phoneNumberBehavior = BehaviorSubject<String>();
  Stream<String> get outPhoneNumber => _phoneNumberBehavior.stream;

  var _statusBehavior = BehaviorSubject<String>();
  Stream<String> get outStatus => _statusBehavior.stream;

  entrar(BuildContext context) {
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (auth) {
          verificationCompleted(auth, context);
        },
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void codeSent(String verId, [int forceResendingToken]) async {
    verificationId = verId;
    _statusBehavior.add("\n Informe o código enviado para " + _phoneNumber);
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    this.verificationId = verificationId;
    _statusBehavior.add("\nTempo de carregamento automático esgotado");
  }

  void verificationFailed(AuthException authException) {
    _statusBehavior.add('${authException.message}');

    if (authException.message.contains('not authorized'))
      _statusBehavior.add('Alguma coisa deu errado: ${authException.message}');
    else if (authException.message.contains('Network'))
      _statusBehavior.add('Problemas com a conexão com a internet');
    else
      _statusBehavior.add('Alguma coisa deu errado2: ${authException.message}');
  }  

  void verificationCompleted(AuthCredential auth, BuildContext context) {
    _statusBehavior.add('Auto retrieving verification code');

    firebaseAuth.signInWithCredential(_authCredential).then((AuthResult value) {      
      if (value.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginModePage()));
      } else {
        _statusBehavior.add('Invalid code/invalid authentication');
      }
    }).catchError((error) {
      _statusBehavior.add('error: $error');
    });
  }

  @override
  void dispose() {
    _phoneNumberBehavior.close();
    super.dispose();
  }

  setPhoneNumber(String value) => _phoneNumberBehavior.add(value);
}
