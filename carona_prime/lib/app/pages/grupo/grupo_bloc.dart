import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/models/grupo_model.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:rxdart/rxdart.dart';

class GrupoBloc extends BlocBase {
  List<GrupoModel> _grupos = [];

  var _listaGruposController = BehaviorSubject<List<GrupoModel>>();
  Observable<List<GrupoModel>> get outListaGrupos =>
      _listaGruposController.stream;

  void novoGrupoFake() {
    _grupos.add(GrupoModel("nome do grupo", LocalModel("Origem", 0, 0, ""),
        LocalModel("Destino", 0, 0, ""), Duration(hours: 12)));
    _listaGruposController.sink.add(_grupos);
  }

  @override
  void dispose() {
    _listaGruposController.close();
    super.dispose();
  }
}
