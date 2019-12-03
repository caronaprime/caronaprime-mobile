import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:carona_prime/app/pages/selecionar_contatos/selecionar_contatos_bloc.dart';
import 'package:carona_prime/app/app_module.dart';

void main() {
  initModule(AppModule());
  SelecionarContatosBloc bloc;

  setUp(() {
    bloc = AppModule.to.bloc<SelecionarContatosBloc>();
  });

  group('SelecionarContatosBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<SelecionarContatosBloc>());
    });
  });
}
