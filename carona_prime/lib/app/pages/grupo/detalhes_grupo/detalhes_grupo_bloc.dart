import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class DetalhesGrupoBloc extends BlocBase {
  var _pageIndexController = BehaviorSubject<int>();
  Observable<int> get outPageIndex => _pageIndexController.stream;
  @override
  void dispose() {
    _pageIndexController.close();
    super.dispose();
  }

  void setIndex(int index) => _pageIndexController.sink.add(index);
}
