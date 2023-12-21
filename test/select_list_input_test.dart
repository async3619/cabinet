import 'package:cabinet/widgets/form_widget/form_field_item.dart';
import 'package:cabinet/widgets/form_widget/list_input/select_list_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  testWidgets("should render SelectListInput properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectListInput(
          field: SelectFormFieldItem(
            name: "name",
            label: "Label",
            getOptions: () async => [],
          ),
        ),
      ),
    ));

    expect(find.byType(SelectListInput), findsOneWidget);
  });

  testWidgets("should show SelectDialog on tap", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectListInput(
          field: SelectFormFieldItem(
            name: "name",
            label: "Label",
            getOptions: () async => [],
          ),
        ),
      ),
    ));

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets("should render SelectListInput with value", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormBuilder(
          key: GlobalKey<FormBuilderState>(),
          initialValue: const {
            'name': ['test', 'test2']
          },
          child: SelectListInput(
            field: SelectFormFieldItem(
              name: "name",
              label: "Label",
              getOptions: () async => [],
            ),
          ),
        ),
      ),
    ));

    expect(find.text('2 items selected'), findsOneWidget);
  });

  testWidgets("should render SelectListInput with error", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormBuilder(
          key: GlobalKey<FormBuilderState>(),
          child: SelectListInput(
            field: SelectFormFieldItem(
              name: "name",
              label: "Label",
              getOptions: () async => [],
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();

    expect(find.text('This field cannot be empty.'), findsOneWidget);
  });
}
