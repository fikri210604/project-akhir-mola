// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic smoke test builds a widget tree', (WidgetTester tester) async {
    // Build a minimal widget tree to verify the test harness runs.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Center(child: Text('Otolink'))),
    ));

    // Verify that our text renders.
    expect(find.text('Otolink'), findsOneWidget);
  });
}
