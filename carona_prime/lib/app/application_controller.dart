import 'package:intl/intl.dart';
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

  String descricaoData(DateTime data) {
    final _formatter = DateFormat('dd/MM/yyyy');
    DateTime now = DateTime.now();
    var diferenca = DateTime(data.year, data.month, data.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diferenca == 0) return "Hoje";
    if (diferenca == 1) return "Amanhã";

    return _formatter.format(data);
  }


  bool isNumber(String text) => '0123456789'.split('').contains(text);

  String onlyNumbers(String text) =>
      text.split('').where((c) => isNumber(c)).join('');

  String phoneNumber(String text) {
    if (text == null) return null;

    var number = onlyNumbers(text);
    if (number.length <= 11) return number;

    return number.substring(number.length - 11);
  }
}
