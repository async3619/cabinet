import 'package:cabinet/widgets/form_field_item.dart';
import 'package:cabinet/widgets/list_input/text_list_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should render list tile item with field data',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormBuilder(
      key: GlobalKey<FormBuilderState>(),
      child:
          TextListInput(field: TextFormFieldItem(name: "name", label: "Label")),
    ))));

    expect(find.text('Label'), findsOneWidget);
    expect(find.text('(empty)'), findsOneWidget);
  });

  testWidgets('should render list tile item with value',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormBuilder(
      key: GlobalKey<FormBuilderState>(),
      initialValue: const {'name': 'test'},
      child:
          TextListInput(field: TextFormFieldItem(name: "name", label: "Label")),
    ))));

    expect(find.text('Label'), findsOneWidget);
    expect(find.text('test'), findsOneWidget);
  });

  testWidgets('should open dialog on tap', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormBuilder(
      key: GlobalKey<FormBuilderState>(),
      child:
          TextListInput(field: TextFormFieldItem(name: "name", label: "Label")),
    ))));

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
