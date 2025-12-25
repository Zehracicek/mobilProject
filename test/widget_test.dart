import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygproject/main.dart';

void main() {
  testWidgets('Uygulama açılıyor mu?', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MyApp(),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
