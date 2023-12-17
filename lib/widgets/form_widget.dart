import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'form_field_item.dart';

class FormFieldGroup {
  final String name;
  final List<FormFieldItem> fields;

  FormFieldGroup({
    required this.name,
    required this.fields,
  });
}

class FormWidget extends StatefulWidget {
  final List<dynamic> items;
  final GlobalKey<FormBuilderState> formKey;

  const FormWidget({
    Key? key,
    required this.items,
    required this.formKey,
  }) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  Widget buildField(FormFieldItem field, bool? last) {
    Widget fieldWidget;
    last ??= false;

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
      padding: EdgeInsets.only(bottom: last ? 0 : 16.0),
      child: fieldWidget,
    );
  }

  Widget buildGroup(FormFieldGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                group.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            for (var i = 0; i < group.fields.length; i++)
              buildField(group.fields[i], i == group.fields.length - 1),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: [
          for (var i = 0; i < widget.items.length; i++)
            if (widget.items[i] is FormFieldGroup)
              buildGroup(widget.items[i])
            else if (widget.items[i] is FormFieldItem)
              buildField(widget.items[i], i == widget.items.length - 1)
            else
              throw Exception('Unknown item type'),
        ],
      )
    );
  }
}