import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:mobx/mobx.dart';

part 'detalhes_grupo_controller.g.dart';

class DetalhesGrupoController = DetalhesGrupoBase
    with _$DetalhesGrupoController;

abstract class DetalhesGrupoBase with Store {
  @observable
  int pageIndex = 0;


  @observable
  ObservableList<UsuarioModel> membros = [
    UsuarioModel("Riquelminho Gaucho", "999423412349"),
    UsuarioModel("Cristiano Messi", "6599942002"),
    UsuarioModel("Lionel Ronaldo", "6623450403"),
  ].asObservable();

  @action
  void setPageIndex(int newPageIndex) => pageIndex = newPageIndex;
}
