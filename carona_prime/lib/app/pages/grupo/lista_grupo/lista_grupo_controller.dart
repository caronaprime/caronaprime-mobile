import 'package:carona_prime/app/shared/repositories/grupo_repository.dart';
import 'package:carona_prime/app/shared/responses/lista_grupos_response.dart';
import 'package:mobx/mobx.dart';

part 'lista_grupo_controller.g.dart';

class ListaGrupoController = ListaGrupoBase with _$ListaGrupoController;

abstract class ListaGrupoBase with Store {
  var _repository = GrupoRepository();

  @observable
  ObservableList<ListaGruposResponse> gruposResponse =
      ObservableList<ListaGruposResponse>().asObservable();

  @observable
  bool consultou = false;

  @action
  Future carregarGrupos() async {
    consultou = false;
    gruposResponse.clear();
    gruposResponse.addAll(await _repository.getGrupos());
    consultou = true;
  }
}
