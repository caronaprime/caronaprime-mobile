import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/shared/default_url.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class LoginRepository {
  var applicationController = GetIt.I.get<ApplicationController>();
  var defaultUrl = GetIt.I.get<DefaultUrl>();
  var dio = Dio();
  var _auth = FirebaseAuth.instance;
  String _verificationId;

  void enviarCodigo(String number) async {
    try {
      final phoneNumber = "+55" + applicationController.onlyNumbers(number);
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

  Future<bool> entrar(String smsCode, String phoneNumber, String nome) async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _verificationId, smsCode: smsCode);

      AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      var usuarioModel =
          await buscarOuCriarUsuario(nome, phoneNumber, user.uid);
      print('Usuário logado com sucesso $user');
      applicationController.logar(usuarioModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UsuarioModel> buscarOuCriarUsuario(
      String nome, String phoneNumber, String userId) async {
    try {
      var json = {"nome": nome, "numero": phoneNumber, "userId": userId};
      var response = await dio
          .post(defaultUrl.url + "/usuarios/buscar-ou-criar", data: json);
      var jsonResponse = response.data;
      return UsuarioModel.fromJson(jsonResponse);
    } catch (e) {
      return null;
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
