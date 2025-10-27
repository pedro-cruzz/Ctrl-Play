import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/main.dart';

void main() {
  testWidgets('Verifica se o título do filme é exibido', (WidgetTester tester) async {
    await tester.pumpWidget(const CtrlPlayApp());

    // Verifica se o título do filme está presente
    expect(find.text('Título do Filme'), findsOneWidget);
  });
}