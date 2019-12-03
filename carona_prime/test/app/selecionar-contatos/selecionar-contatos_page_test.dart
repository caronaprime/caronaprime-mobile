import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:carona_prime/app/selecionar-contatos/selecionar-contatos_page.dart';

main() {
  testWidgets('Selecionar-contatosPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(
        Selecionar - contatosPage(title: 'Selecionar-contatos')));
    final titleFinder = find.text('Selecionar-contatos');
    expect(titleFinder, findsOneWidget);
  });
}
