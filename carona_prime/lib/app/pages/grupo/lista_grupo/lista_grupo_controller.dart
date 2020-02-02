import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/shared/repositories/grupo_repository.dart';
import 'package:carona_prime/app/shared/responses/lista_grupos_response.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'lista_grupo_controller.g.dart';

class ListaGrupoController = ListaGrupoBase with _$ListaGrupoController;

abstract class ListaGrupoBase with Store {
  var _repository = GrupoRepository();
  var applicationController = GetIt.I.get<ApplicationController>();

  @observable
  ObservableList<ListaGruposResponse> gruposResponse =
      ObservableList<ListaGruposResponse>().asObservable();

  @observable
  bool consultou = false;

  @action
  Future carregarGrupos() async {
    consultou = false;
    gruposResponse.clear();
    var grupos =
        await _repository.getGrupos(applicationController.usuarioLogado.id);
    if (grupos != null) gruposResponse.addAll(grupos);
    consultou = true;
  }

  @action
  Future<bool> sairDoGrupo(int grupoId) async {
    var saiu = await _repository.sairDoGrupo(
        grupoId, applicationController.usuarioLogado.id);
    if (saiu) await carregarGrupos();
    return saiu;
  }
}
