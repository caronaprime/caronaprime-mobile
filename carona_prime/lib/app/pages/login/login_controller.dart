import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/shared/repositories/login_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = LoginBase with _$LoginController;

abstract class LoginBase with Store {
  var applicationController = GetIt.I.get<ApplicationController>();
  var _repository = LoginRepository();

  @observable
  bool logado = false;

  @observable
  String phoneNumber = "";

  @observable
  String codeNumber = "";

  @observable
  String status = "";

  @observable
  String error;

  @action
  void setPhoneNumber(String value) => phoneNumber = value;

  @action
  enviarCodigo(String number) async => _repository.enviarCodigo(number);

  Future<bool> entrar(String smsCode) async {
    var entrou = await _repository.entrar(smsCode);
    if (entrou)
      error = null;
    else
      error =
          "Código inválido.";

    return entrou;
  }
}
