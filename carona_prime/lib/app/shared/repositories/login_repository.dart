import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class LoginRepository {
  var applicationController = GetIt.I.get<ApplicationController>();
  var _auth = FirebaseAuth.instance;
  String _verificationId;

  void enviarCodigo(String number) async {
    try {
      final phoneNumber = "+55" +
          number.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "");
      if (number.length >= 11) {
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: Duration(seconds: 30),
            verificationCompleted: _verificationCompleted,
            verificationFailed: _verificationFailed,
            codeSent: _codeSent,
            codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout);
      }
    } catch (e) {
      print("_signInWithPhoneNumber ERROR: ${e.toString()}");
    }
  }

  Future<bool> entrar(String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _verificationId, smsCode: smsCode);

      AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      print('Usuário logado com sucesso $user');      
      applicationController.logar(UsuarioModel(user.displayName, user.phoneNumber));
      return true;
    } catch (e) {      
      return false;
    }
  }

  _verificationCompleted(AuthCredential phoneAuthCredential) {
    _auth.signInWithCredential(phoneAuthCredential);       
  }

  _verificationFailed(AuthException authException) {
    print("FAILED Não implementado: ${authException.message}");
  }

  _codeSent(String verificationId, [int forceResendingToken]) async {
    _verificationId = verificationId;
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;
    print("Tempo limite esgotado!");
  }
}
