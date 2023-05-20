import 'package:flutter_test/flutter_test.dart';
import 'package:astral_organiser/main.dart';
import 'package:flutter/material.dart';
import 'package:astral_organiser/quantified/main_class.dart';

void main() {
  testWidgets('User creates a new QuantifiedCategory instance', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp()); // Replace MyApp with your app widget

    // Find the "Add category" button and tap it
    final addButton = find.byKey(Key('addCategoryButton'));
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Fill the form fields
    final titleField = find.byKey(Key('titleField'));
    await tester.enterText(titleField, 'New Category');

    // Submit the form
    final submitButton = find.byKey(Key('submitButton'));
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verify that a new instance of QuantifiedCategory is created
    final quantifiedCategories = find.byType(QuantifiedCategory);
    expect(quantifiedCategories, findsOneWidget);
  });

}
