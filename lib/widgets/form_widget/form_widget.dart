import 'package:cabinet/widgets/form_widget/list_input/filter_list_input.dart';
import 'package:cabinet/widgets/form_widget/list_input/switch_list_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import './list_input/select_list_input.dart';
import './list_input/text_list_input.dart';

import './form_field_item.dart';

class FormFieldGroup {
  final String name;
  final List<FormFieldItem> fields;

  FormFieldGroup({
    required this.name,
    required this.fields,
  });
}

class FormWidget extends StatefulWidget {
  final List<FormFieldGroup> groups;
  final GlobalKey<FormBuilderState> formKey;
  final Map<String, dynamic>? initialValues;

  const FormWidget({
    Key? key,
    required this.groups,
    required this.formKey,
    this.initialValues,
  }) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  Widget buildField(FormFieldItem field, bool? last) {
    Widget fieldWidget;
    last ??= false;

    if (field is TextFormFieldItem) {
      fieldWidget = TextListInput(field: field);
    } else if (field is SelectFormFieldItem) {
      fieldWidget = SelectListInput(field: field);
    } else if (field is FilterFormFieldItem) {
      fieldWidget = FilterListInput(field: field);
    } else if (field is SwitchFormFieldItem) {
      fieldWidget = SwitchListInput(field: field);
    } else {
      throw Exception('Unknown field type');
    }

    return Column(
        children: last == false
            ? [fieldWidget]
            : [const Divider(height: 1, thickness: 1), fieldWidget]);
  }

  Widget buildGroup(FormFieldGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                group.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Column(
              children: [
                for (var i = 0; i < group.fields.length; i++)
                  buildField(group.fields[i], i == group.fields.length - 1)
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: widget.formKey,
        initialValue: widget.initialValues ?? {},
        child: Column(
          children: [
            for (var i = 0; i < widget.groups.length; i++)
              buildGroup(widget.groups[i]),
          ],
        ));
  }
}
