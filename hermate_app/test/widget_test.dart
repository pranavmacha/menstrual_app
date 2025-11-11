// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hermate_app/main.dart';

void main() {
  testWidgets('shows onboarding content on launch', (WidgetTester tester) async {
    // Build the app and allow it to settle.
    await tester.pumpWidget(const MenstrualApp());
    await tester.pumpAndSettle();

    // Verify that key onboarding texts are visible to the user.
    expect(find.text('Track your cycle with confidence 💗'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
