import 'package:carona_prime/app/models/grupo_model.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:mobx/mobx.dart';

part 'grupo_controller.g.dart';

class GrupoController = GrupoBase with _$GrupoController;

abstract class GrupoBase with Store {
  List<GrupoModel> _grupos = List<GrupoModel>();
  @observable
  List<GrupoModel> grupos;

  @action
  void novoGrupoFake() {
    _grupos.add(GrupoModel("nome do grupo", LocalModel("Origem", 0, 0, ""),
        LocalModel("Destino", 0, 0, ""), Duration(hours: 12)));
    grupos = _grupos;
  }
}
