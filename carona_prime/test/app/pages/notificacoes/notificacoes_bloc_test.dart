import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:carona_prime/app/pages/notificacoes/notificacoes_bloc.dart';
import 'package:carona_prime/app/app_module.dart';

void main() {
  initModule(AppModule());
  NotificacoesBlocOld bloc;

  setUp(() {
    bloc = AppModule.to.bloc<NotificacoesBlocOld>();
  });

  group('NotificacoesBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<NotificacoesBlocOld>());
    });
  });
}
