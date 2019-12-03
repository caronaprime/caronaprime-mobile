import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:carona_prime/app/selecionar-contatos/selecionar-contatos_bloc.dart';
import 'package:carona_prime/app/app_module.dart';

void main() {

  initModule(AppModule());
  Selecionar-contatosBloc bloc;
  
  setUp(() {
      bloc = AppModule.to.bloc<Selecionar-contatosBloc>();
  });

  group('Selecionar-contatosBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<Selecionar-contatosBloc>());
    });
  });

}
  