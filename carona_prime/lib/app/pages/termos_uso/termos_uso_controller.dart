import 'package:mobx/mobx.dart';
part 'termos_uso_controller.g.dart';

class TermosUsoController = TermosUsoBase with _$TermosUsoController;

abstract class TermosUsoBase with Store {
  @observable
  bool aceito = false;

  @action
  void setAceito(bool value) => aceito = value;
}
