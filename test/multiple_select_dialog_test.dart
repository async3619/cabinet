import 'package:cabinet/widgets/dialogs/multiple_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should render MultipleSelectDialog properly',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MultipleSelectDialog(
                title: "title", options: const [], onSubmit: (values) {}))));

    expect(find.text('title'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('should render MultipleSelectDialog with options',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MultipleSelectDialog(
                title: "title",
                options: const ['test'],
                onSubmit: (values) {}))));

    expect(find.text('test'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });

  testWidgets('should render MultipleSelectDialog with selected options',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MultipleSelectDialog(
                title: "title",
                options: const ['test'],
                selectedOptions: const ['test'],
                onSubmit: (values) {}))));

    expect(find.text('test'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);

    var checkboxListTile = find.byType(CheckboxListTile).evaluate().first.widget
        as CheckboxListTile;

    expect(checkboxListTile.value, true);
  });

  testWidgets('should render MultipleSelectDialog with no selected options',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MultipleSelectDialog(
                title: "title",
                options: const ['test'],
                onSubmit: (values) {}))));

    expect(find.text('test'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);

    var checkboxListTile = find.byType(CheckboxListTile).evaluate().first.widget
        as CheckboxListTile;

    expect(checkboxListTile.value, false);
  });

  testWidgets('should call onSubmit with selected options',
      (widgetTester) async {
    var selectedOptions = [];

    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MultipleSelectDialog(
                title: "title",
                options: const ['test'],
                onSubmit: (values) {
                  selectedOptions = values;
                }))));

    expect(find.text('test'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);

    await widgetTester.tap(find.byType(CheckboxListTile).last);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text('Save'));
    await widgetTester.pumpAndSettle();

    expect(selectedOptions, ['test']);
  });
}
