import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/enums/modo_login.dart';
import 'package:rxdart/rxdart.dart';

class LoginModeBloc extends BlocBase {  

  var _modoDeLoginController = BehaviorSubject<ModoDeLogin>.seeded(ModoDeLogin.caroneiro);
  Observable<ModoDeLogin> get outModoDeLogin => _modoDeLoginController.stream;
  void setModo(ModoDeLogin value) => _modoDeLoginController.sink.add(value);
  
  @override
  void dispose() {
    _modoDeLoginController.close();
    super.dispose();
  }
}
