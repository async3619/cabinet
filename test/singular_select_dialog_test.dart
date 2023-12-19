import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cabinet/widgets/form_widget/dialogs/singular_select_dialog.dart';

void main() {
  testWidgets('should render SingularSelectDialog properly',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SingularSelectDialog(
                title: "title", options: const [], onSubmit: (value) {}))));

    expect(find.text('title'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('should render SingularSelectDialog with options',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SingularSelectDialog(
                title: "title",
                options: const ['test'],
                onSubmit: (value) {}))));

    expect(find.text('test'), findsOneWidget);
    expect(find.byType(RadioListTile<String>), findsOneWidget);
  });

  testWidgets('should render SingularSelectDialog with selected option',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SingularSelectDialog(
                title: "title",
                options: const ['test', 'test2'],
                selectedOption: 'test2',
                onSubmit: (value) {}))));

    expect(find.text('test'), findsOneWidget);
    expect(find.byType(RadioListTile<String>), findsWidgets);

    var radioListTile = find
        .byType(RadioListTile<String>)
        .evaluate()
        .last
        .widget as RadioListTile<String>;

    expect(radioListTile.checked, true);
  });

  testWidgets('should call onSubmit with selected option',
      (widgetTester) async {
    var selectedOption = '';

    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SingularSelectDialog(
                title: "title",
                options: const ['test', 'test2'],
                selectedOption: 'test2',
                onSubmit: (value) {
                  selectedOption = value;
                }))));

    expect(find.text('test'), findsOneWidget);
    expect(find.byType(RadioListTile<String>), findsWidgets);

    await widgetTester.tap(find.byType(RadioListTile<String>).first);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text('Save'));
    await widgetTester.pumpAndSettle();

    expect(selectedOption, 'test');
  });
}
