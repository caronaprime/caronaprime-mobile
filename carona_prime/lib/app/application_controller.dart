import 'package:mobx/mobx.dart';

import 'models/usuario_model.dart';
part 'application_controller.g.dart';

class ApplicationController = ApplicationBase with _$ApplicationController;

abstract class ApplicationBase with Store {
  @observable
  UsuarioModel usuarioLogado;

  @computed
  bool get logado => usuarioLogado != null;

  @action
  void logar(UsuarioModel usuario) => usuarioLogado = usuario;

  @action
  void deslogar() => usuarioLogado = null;
}