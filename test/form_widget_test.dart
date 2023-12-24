import 'package:cabinet/widgets/form_widget/form_field_item.dart';
import 'package:cabinet/widgets/form_widget/form_widget.dart';
import 'package:cabinet/widgets/form_widget/list_input/select_list_input.dart';
import 'package:cabinet/widgets/form_widget/list_input/text_list_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("should render FormWidget properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormWidget(
          groups: const [],
          formKey: GlobalKey<FormBuilderState>(),
        ),
      ),
    ));

    expect(find.byType(FormWidget), findsOneWidget);
  });

  testWidgets("should render SelectListInput field properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormWidget(
          groups: [
            FormFieldGroup(name: "General", fields: [
              SelectFormFieldItem(
                name: "name",
                label: "Label",
                getOptions: () async => [],
              ),
            ]),
          ],
          formKey: GlobalKey<FormBuilderState>(),
        ),
      ),
    ));

    expect(find.byType(SelectListInput), findsOneWidget);
  });

  testWidgets("should render TextListInput field properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormWidget(
          groups: [
            FormFieldGroup(name: "General", fields: [
              TextFormFieldItem(
                name: "name",
                label: "Label",
              ),
            ]),
          ],
          formKey: GlobalKey<FormBuilderState>(),
        ),
      ),
    ));

    expect(find.byType(TextListInput), findsOneWidget);
  });
}
