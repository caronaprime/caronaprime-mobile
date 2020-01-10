import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:carona_prime/app/pages/notificacoes/notificacoes_page.dart';

main() {
  testWidgets('NotificacoesPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(
        buildTestableWidget(NotificacoesPageOld(title: 'Notificacoes')));
    final titleFinder = find.text('Notificacoes');
    expect(titleFinder, findsOneWidget);
  });
}
