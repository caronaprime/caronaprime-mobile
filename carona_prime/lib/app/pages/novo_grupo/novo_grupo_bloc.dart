import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:rxdart/rxdart.dart';

class NovoGrupoBloc extends BlocBase {
  LocalModel _localDePartida;
  LocalModel _localDeDestino;

  var _localDePartidaController = BehaviorSubject<LocalModel>();

  Observable<LocalModel> get outLocalDePartida =>
      _localDePartidaController.stream;

  void setLocalDePartida(LocalModel local) {
    _localDePartida = local;
    _localDePartidaController.sink.add(local);
  }

  var _localDeDestinoController = BehaviorSubject<LocalModel>();

  Observable<LocalModel> get outLocalDeDestino =>
      _localDeDestinoController.stream;

  void setLocalDeDestino(LocalModel local) {
    _localDeDestino = local;
    _localDeDestinoController.sink.add(local);
  }

  LocalModel get localDePartida => _localDePartida;
  LocalModel get localDeDestino => _localDeDestino;

  @override
  void dispose() {
    _localDePartidaController.close();
    _localDeDestinoController.close();
    super.dispose();
  }
}
