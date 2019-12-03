import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:carona_prime/app/pages/selecionar_contatos/selecionar_contatos_page.dart';

main() {
  testWidgets('SelecionarContatosPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(
        SelecionarContatosPage(title: 'SelecionarContatos')));
    final titleFinder = find.text('SelecionarContatos');
    expect(titleFinder, findsOneWidget);
  });
}
