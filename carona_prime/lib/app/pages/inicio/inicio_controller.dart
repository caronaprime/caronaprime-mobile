import 'package:mobx/mobx.dart';
part 'inicio_controller.g.dart';

class InicioController = InicioBase with _$InicioController;

abstract class InicioBase with Store {
  @observable
  int pageIndex = 0;

  @action
  void setPageIndex(int value) => pageIndex = value;
}
