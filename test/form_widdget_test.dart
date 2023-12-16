import 'package:cabinet/components/widgets/form_field_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cabinet/components/widgets/form_widget.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  testWidgets('should render empty form widget if no fields are provided', (WidgetTester tester) async {
    final formKey = GlobalKey<FormBuilderState>();
    final List<FormFieldItem> fields = [];

    await tester.pumpWidget(FormWidget(fields: fields, formKey: formKey));

    expect(find.byType(FormBuilder), findsOneWidget);
    expect(find.byType(FormField), findsNothing);
  });

  testWidgets('should render form widget with text form field', (WidgetTester tester) async {
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
          body: FormWidget(fields: fields, formKey: formKey),
        ),
      ),
    );

    expect(find.byType(FormBuilder), findsOneWidget);
    expect(find.byType(FormBuilderTextField), findsOneWidget);
  });

  testWidgets('should render form widget with select form field', (WidgetTester tester) async {
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
          body: FormWidget(fields: fields, formKey: formKey),
        ),
      ),
    );

    expect(find.byType(FormBuilder), findsOneWidget);
    expect(find.byType(FormBuilderDropdown<String>), findsOneWidget);
  });
}
