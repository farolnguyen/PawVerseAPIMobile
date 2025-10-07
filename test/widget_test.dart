// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawversemobile/data/services/storage_service.dart';
import 'package:pawversemobile/main.dart';

void main() {
  testWidgets('App should start with login screen', (WidgetTester tester) async {
    // Initialize storage service for test
    final storageService = StorageService();
    await storageService.init();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(storageService: storageService));

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that login screen elements are present
    expect(find.text('PawVerse'), findsWidgets);
  });
}
