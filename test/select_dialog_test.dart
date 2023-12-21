import 'package:cabinet/widgets/form_widget/dialogs/select_dialog.dart';
import 'package:cabinet/widgets/form_widget/form_field_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("should render SelectDialog properly", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectDialog(
          title: "Title",
          getOptions: () async => [],
          onSubmit: (_) {},
        ),
      ),
    ));

    expect(find.text("Title"), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets("should render SelectDialog with options", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectDialog(
          title: "Title",
          getOptions: () async => [
            SelectOption(value: "1", label: "One"),
            SelectOption(value: "2", label: "Two"),
          ],
          onSubmit: (_) {},
        ),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text("Title"), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text("One"), findsOneWidget);
    expect(find.text("Two"), findsOneWidget);
  });

  testWidgets("should render radio list tile if multiple is false",
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectDialog(
          title: "Title",
          getOptions: () async => [
            SelectOption(value: "1", label: "One"),
            SelectOption(value: "2", label: "Two"),
          ],
          onSubmit: (_) {},
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.tap(find.text("One"));
    await tester.pumpAndSettle();

    expect(find.text("Title"), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(RadioListTile<String>), findsNWidgets(2));
  });

  testWidgets("should render checkbox list tile if multiple is true",
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectDialog(
          title: "Title",
          multiple: true,
          getOptions: () async => [
            SelectOption(value: "1", label: "One"),
            SelectOption(value: "2", label: "Two"),
          ],
          onSubmit: (_) {},
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.tap(find.text("One"));
    await tester.pumpAndSettle();

    expect(find.text("Title"), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNWidgets(2));
  });

  testWidgets("should call onSubmit with selected value", (tester) async {
    List<String> selectedValue = [];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectDialog(
          title: "Title",
          getOptions: () async => [
            SelectOption(value: "1", label: "One"),
            SelectOption(value: "2", label: "Two"),
          ],
          onSubmit: (value) => selectedValue = value,
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.tap(find.text("One"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();

    expect(selectedValue, ["1"]);
  });

  testWidgets("should close dialog on cancel", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectDialog(
          title: "Title",
          getOptions: () async => [
            SelectOption(value: "1", label: "One"),
            SelectOption(value: "2", label: "Two"),
          ],
          onSubmit: (_) {},
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.tap(find.text("Cancel"));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
