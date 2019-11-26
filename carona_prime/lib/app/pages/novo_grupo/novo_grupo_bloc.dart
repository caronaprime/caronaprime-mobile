import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/shared/models/local_model.dart';
import 'package:rxdart/rxdart.dart';

class NovoGrupoBloc extends BlocBase {
  var _localDePartidaController = BehaviorSubject<LocalModel>();
  Observable<LocalModel> get outLocalDePartida =>
      _localDePartidaController.stream;
  void setLocalDePartida(LocalModel local) =>
      _localDePartidaController.sink.add(local);

  var _localDeDestinoController = BehaviorSubject<LocalModel>();
  Observable<LocalModel> get outLocalDeDestino =>
      _localDeDestinoController.stream;
  void setLocalDeDestino(LocalModel local) =>
      _localDeDestinoController.sink.add(local);

  @override
  void dispose() {
    _localDePartidaController.close();
    _localDeDestinoController.close();
    super.dispose();
  }
}
