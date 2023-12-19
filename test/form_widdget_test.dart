import 'package:cabinet/widgets/form_field_item.dart';
import 'package:cabinet/widgets/list_input/select_list_input.dart';
import 'package:cabinet/widgets/list_input/text_list_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cabinet/widgets/form_widget.dart';

void main() {
  testWidgets("should render empty form widget if no groups are provided",
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormWidget(
      groups: [],
      formKey: GlobalKey<FormBuilderState>(),
    ))));

    expect(find.byType(FormWidget), findsOneWidget);
    expect(find.byType(Card), findsNothing);
  });

  testWidgets("should render groups provided to form widget properly",
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormWidget(formKey: GlobalKey<FormBuilderState>(), groups: [
      FormFieldGroup(name: "First", fields: []),
      FormFieldGroup(name: "Second", fields: []),
    ]))));

    expect(find.byType(FormWidget), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.text("First"), findsOneWidget);
    expect(find.text("Second"), findsOneWidget);
  });

  testWidgets("should render fields provided to form widget properly",
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormWidget(formKey: GlobalKey<FormBuilderState>(), groups: [
      FormFieldGroup(name: "First", fields: [
        TextFormFieldItem(name: "test", label: "Test"),
      ]),
    ]))));

    expect(find.byType(FormWidget), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.text("First"), findsOneWidget);
    expect(find.text("Test"), findsOneWidget);
  });

  testWidgets("should render text field properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormWidget(formKey: GlobalKey<FormBuilderState>(), groups: [
      FormFieldGroup(name: "First", fields: [
        TextFormFieldItem(name: "test", label: "Test"),
      ]),
    ]))));

    expect(find.byType(FormWidget), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.text("First"), findsOneWidget);
    expect(find.text("Test"), findsOneWidget);
    expect(find.byType(TextListInput), findsOneWidget);
  });

  testWidgets("should render select field properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormWidget(formKey: GlobalKey<FormBuilderState>(), groups: [
      FormFieldGroup(name: "First", fields: [
        SelectFormFieldItem(
          name: 'site',
          label: 'Site',
          options: [
            'test1',
            'test2',
            'test3',
          ],
        ),
      ]),
    ]))));

    expect(find.byType(FormWidget), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.text("First"), findsOneWidget);
    expect(find.text("Site"), findsOneWidget);
    expect(find.byType(SelectListInput), findsOneWidget);
  });
}
