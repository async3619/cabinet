import 'package:cabinet/models/filter.dart';
import 'package:cabinet/widgets/form_widget/form_field_item.dart';
import 'package:cabinet/widgets/form_widget/list_input/filter_list_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("should render FilterListInput properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FilterListInput(
          field: FilterFormFieldItem(
            name: "name",
            label: "Label",
          ),
        ),
      ),
    ));

    expect(find.byType(FilterListInput), findsOneWidget);
    expect(find.text("Add a new filter"), findsOneWidget);
  });

  testWidgets("should render value filters listed properly",
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: FormBuilder(
      key: GlobalKey<FormBuilderState>(),
      initialValue: {
        "name": [
          Filter(
            keyword: "keyword",
            location: SearchLocation.Subject,
            caseSensitive: true,
          ),
        ]
      },
      child: Column(
        children: [
          FilterListInput(
            field: FilterFormFieldItem(
              name: "name",
              label: "Label",
            ),
          ),
        ],
      ),
    ))));

    expect(find.text("keyword, Subject, Case Sensitive"), findsOneWidget);
  });
}
