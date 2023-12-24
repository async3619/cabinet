import 'package:cabinet/widgets/form_widget/dialogs/select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../form_field_item.dart';

class SelectListInput extends StatefulWidget {
  final SelectFormFieldItem field;

  const SelectListInput({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<SelectListInput> createState() => _SelectListInputState();
}

class _SelectListInputState extends State<SelectListInput> {
  handleListTap(FormFieldState<dynamic> field) {
    showDialog(
        context: context,
        builder: (context) {
          return SelectDialog(
              title: widget.field.label,
              getOptions: widget.field.getOptions,
              onSubmit: (value) {
                field.didChange(value);
                Navigator.of(context).pop();
              },
              multiple: widget.field.multiple ?? false,
              initialSelection: field.value);
        });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<dynamic>(
      name: widget.field.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.field.validator,
      builder: (field) {
        String valueLabel;

        dynamic value = field.value;
        if (value is List?) {
          if (value == null || value.isEmpty) {
            valueLabel = 'Nothing selected';
          } else {
            valueLabel = '${value.length} items selected';
          }
        } else if (value is String?) {
          valueLabel = value ?? 'Nothing selected';
        } else {
          throw Exception('Unknown value type');
        }

        return ListTile(
          title: Text(
            widget.field.label,
            style: TextStyle(
              color: field.errorText != null
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
          ),
          subtitle: Text(
            field.errorText ?? valueLabel,
            style: TextStyle(
              color: field.errorText != null
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
          ),
          onTap: () {
            handleListTap(field);
          },
        );
      },
    );
  }
}
