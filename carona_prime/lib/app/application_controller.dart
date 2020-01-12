import 'package:mobx/mobx.dart';
part 'application_controller.g.dart';

class ApplicationController = ApplicationBase with _$ApplicationController;

abstract class ApplicationBase with Store {
  @observable
  bool logado = false;

  @action
  void logar() => logado = true;

  @action
  void deslogar() => logado = false;
}