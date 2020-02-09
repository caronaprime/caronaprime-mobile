import 'package:mobx/mobx.dart';
part 'politica_privacidade_controller.g.dart';

class PoliticaPrivacidadeController = PoliticaPrivacidadeBase
    with _$PoliticaPrivacidadeController;

abstract class PoliticaPrivacidadeBase with Store {
  @observable
  bool aceitoUsoDeInformacoes = false;

  @observable
  bool aceitoArmazenamento = false;

  @observable
  bool videoExecutando = false;

  @action
  void setVideoExecutando(bool value) => videoExecutando = value;

  @action
  void setAceitoUsoDeInformacoes(bool value) => aceitoUsoDeInformacoes = value;

  @action
  void setAceitoArmazenamento(bool value) => aceitoArmazenamento = value;
}
