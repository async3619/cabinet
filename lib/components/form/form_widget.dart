import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'form_field_item.dart';

class FormWidget extends StatefulWidget {
  final List<FormFieldItem> fields;
  final GlobalKey<FormBuilderState> formKey;

  const FormWidget({
    Key? key,
    required this.fields,
    required this.formKey,
  }) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: widget.fields.map((field) {
          Widget fieldWidget;

          if (field is TextFormFieldItem) {
            fieldWidget = FormBuilderTextField(
              name: field.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                labelText: field.label,
                border: const OutlineInputBorder(),
              ),
              validator: field.validator,
            );
          } else if (field is SelectFormFieldItem) {
            fieldWidget = FormBuilderDropdown(
              name: field.name,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                labelText: field.label,
                border: const OutlineInputBorder(),
              ),
              validator: field.validator,
              items: field.options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            );
          } else {
            throw Exception('Unknown field type');
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: fieldWidget,
          );
        }).toList(),
      )
    );
  }
}