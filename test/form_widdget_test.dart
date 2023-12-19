import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cabinet/widgets/form_field_item.dart';
import 'package:cabinet/widgets/form_widget.dart';

void main() {
  testWidgets('should render empty form widget if no fields are provided',
      (WidgetTester tester) async {
    final formKey = GlobalKey<FormBuilderState>();
    final List<FormFieldItem> fields = [];

    await tester.pumpWidget(FormWidget(items: fields, formKey: formKey));

    expect(find.byType(FormBuilder), findsOneWidget);
    expect(find.byType(FormField), findsNothing);
  });

  testWidgets('should throw error if invalid field type is provided',
      (WidgetTester tester) async {
    final formKey = GlobalKey<FormBuilderState>();
    final List<dynamic> fields = [1];

    await tester.pumpWidget(FormWidget(items: fields, formKey: formKey));

    expect(tester.takeException(), isInstanceOf<Exception>());
  });

  testWidgets('should render form widget group with fields',
      (WidgetTester tester) async {
    final formKey = GlobalKey<FormBuilderState>();
    final fields = [
      FormFieldGroup(name: "General", fields: [
        TextFormFieldItem(
          name: 'name',
          label: 'Name',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
        )
      ])
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormWidget(items: fields, formKey: formKey),
        ),
      ),
    );

    expect(find.byType(FormBuilder), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.byType(FormBuilderTextField), findsOneWidget);
  });

  testWidgets('should render form widget with text form field',
      (WidgetTester tester) async {
    final formKey = GlobalKey<FormBuilderState>();

    final fields = [
      TextFormFieldItem(
        name: 'name',
        label: 'Name',
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormWidget(items: fields, formKey: formKey),
        ),
      ),
    );

    expect(find.byType(FormBuilder), findsOneWidget);
    expect(find.byType(FormBuilderTextField), findsOneWidget);
  });

  testWidgets('should render form widget with select form field',
      (WidgetTester tester) async {
    final formKey = GlobalKey<FormBuilderState>();
    final fields = [
      SelectFormFieldItem(
        name: 'url',
        label: 'URL',
        options: [
          'https://www.google.com',
          'https://www.facebook.com',
          'https://www.twitter.com',
        ],
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormWidget(items: fields, formKey: formKey),
        ),
      ),
    );

    expect(find.byType(FormBuilder), findsOneWidget);
    expect(find.byType(FormBuilderDropdown<String>), findsOneWidget);
  });
}
