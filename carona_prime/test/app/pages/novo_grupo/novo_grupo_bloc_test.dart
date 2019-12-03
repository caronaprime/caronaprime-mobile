import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:carona_prime/app/pages/novo_grupo/novo_grupo_bloc.dart';
import 'package:carona_prime/app/app_module.dart';

void main() {
  initModule(AppModule());
  NovoGrupoBloc bloc;

  setUp(() {
    bloc = AppModule.to.bloc<NovoGrupoBloc>();
  });

  group('NovoGrupoBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<NovoGrupoBloc>());
    });
  });
}
