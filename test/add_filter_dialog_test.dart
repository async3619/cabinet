import 'package:cabinet/models/filter.dart';
import 'package:cabinet/widgets/form_widget/dialogs/add_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("should render AddFilterDialog properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: AddFilterDialog(
        onSubmit: (filter) {},
      ),
    )));

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets("should call onSubmit when the form is valid", (tester) async {
    var onSubmitCalled = false;

    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: AddFilterDialog(
        onSubmit: (filter) {
          onSubmitCalled = true;
          expect(filter.keyword, "keyword");
          expect(filter.location, SearchLocation.Subject);
          expect(filter.caseSensitive, true);
        },
      ),
    )));

    await tester.enterText(find.byType(FormBuilderTextField), "keyword");
    await tester.tap(find.text("Search Location"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Subject").last);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Case Sensitive"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Add"));
    await tester.pumpAndSettle();

    expect(onSubmitCalled, true);
  });
}
