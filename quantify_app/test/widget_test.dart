// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quantify_app/screens/main.dart';

void main() {

  testWidgets('Testing menu buttons', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that we start on Home
    expect(find.text('Monday Dec 12'), findsOneWidget);
    expect(find.text('Diarypage'), findsNothing);
    expect(find.text('Profilepage'), findsNothing);
    expect(find.text('Settingspage'), findsNothing);

    // Tap the Diary icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.book));
    await tester.pump();

    // Verify that we moved to Diary
    expect(find.text('Monday Dec 12'), findsNothing);
    expect(find.text('Diarypage'), findsOneWidget);
    expect(find.text('Profilepage'), findsNothing);
    expect(find.text('Settingspage'), findsNothing);

    // Tap the Profile icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.people));
    await tester.pump();

    // Verify that we moved to Profile
    expect(find.text('Monday Dec 12'), findsNothing);
    expect(find.text('Diarypage'), findsNothing);
    expect(find.text('Profilepage'), findsOneWidget);
    expect(find.text('Settingspage'), findsNothing);

    // Tap the Settings icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();

    // Verify that we moved to Settings
    expect(find.text('Monday Dec 12'), findsNothing);
    expect(find.text('Diarypage'), findsNothing);
    expect(find.text('Profilepage'), findsNothing);
    expect(find.text('Settingspage'), findsOneWidget);
  });
  
}
