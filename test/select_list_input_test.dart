import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cabinet/widgets/form_widget/form_field_item.dart';
import 'package:cabinet/widgets/form_widget/list_input/select_list_input.dart';
import 'package:cabinet/widgets/form_widget/dialogs/multiple_select_dialog.dart';
import 'package:cabinet/widgets/form_widget/dialogs/singular_select_dialog.dart';

void main() {
  testWidgets('should render list tile item with field data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: Scaffold(
              body: FormBuilder(
        key: GlobalKey<FormBuilderState>(),
        child: SelectListInput(
            field: SelectFormFieldItem(
                name: "name", label: "Label", options: ['test'])),
      ))),
    );

    expect(find.text('Label'), findsOneWidget);
    expect(find.text('Nothing selected'), findsOneWidget);
  });

  testWidgets(
      'should render list tile item with value name if select is singular form',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: Scaffold(
              body: FormBuilder(
        key: GlobalKey<FormBuilderState>(),
        initialValue: const {'name': 'test'},
        child: SelectListInput(
            field: SelectFormFieldItem(
                name: "name", label: "Label", options: ['test'])),
      ))),
    );

    expect(find.text('Label'), findsOneWidget);
    expect(find.text('test'), findsOneWidget);
  });

  testWidgets(
      'should render list tile item with value length if select is multiple form',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: Scaffold(
              body: FormBuilder(
        key: GlobalKey<FormBuilderState>(),
        initialValue: const {
          'name': ['test']
        },
        child: SelectListInput(
            field: SelectFormFieldItem(
                name: "name",
                label: "Label",
                options: ['test'],
                multiple: true)),
      ))),
    );

    expect(find.text('Label'), findsOneWidget);
    expect(find.text('1 items selected'), findsOneWidget);
  });

  testWidgets('should open singular select dialog on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: Scaffold(
              body: FormBuilder(
        key: GlobalKey<FormBuilderState>(),
        child: SelectListInput(
            field: SelectFormFieldItem(
                name: "name", label: "Label", options: ['test'])),
      ))),
    );

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(SingularSelectDialog), findsOneWidget);
  });

  testWidgets('should open multiple select dialog on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: Scaffold(
              body: FormBuilder(
        key: GlobalKey<FormBuilderState>(),
        child: SelectListInput(
            field: SelectFormFieldItem(
                name: "name",
                label: "Label",
                options: ['test'],
                multiple: true)),
      ))),
    );

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(MultipleSelectDialog), findsOneWidget);
  });
}
