import 'package:cabinet/widgets/form_widget/dialogs/select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../form_field_item.dart';

class SelectListInput<T> extends StatefulWidget {
  final SelectFormFieldItem<T> field;

  const SelectListInput({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<SelectListInput<T>> createState() => _SelectListInputState<T>();
}

class _SelectListInputState<T> extends State<SelectListInput<T>> {
  handleListTap(FormFieldState<dynamic> field) {
    final options = widget.field.getOptions();
    final multiple = widget.field is MultipleSelectFormFieldItem;
    final initialSelection = multiple ? field.value : [field.value];

    showDialog(
        context: context,
        builder: (context) {
          return SelectDialog(
              title: widget.field.label,
              options: options,
              onSubmit: (value) {
                field.didChange(
                  multiple ? value : value.firstOrNull,
                );
                Navigator.of(context).pop();
              },
              multiple: multiple,
              initialSelection: initialSelection);
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

        final widgetField = widget.field;
        final options = widget.field.getOptions();
        dynamic value = field.value;
        if (value is List<T> && widgetField is MultipleSelectFormFieldItem<T>) {
          final formatValue = (widgetField as dynamic).formatValue;

          if (value.isEmpty) {
            valueLabel = "Nothing selected";
          } else if (formatValue != null) {
            valueLabel = formatValue!(value);
          } else {
            valueLabel = "${value.length} items selected";
          }
        } else if (value is T? &&
            widgetField is SingularSelectFormFieldItem<T>) {
          if (value == null) {
            valueLabel = "Nothing selected";
          } else if (widgetField.formatValue != null) {
            valueLabel = widgetField.formatValue!(value);
          } else {
            final option =
                options.firstWhere((option) => option.value == value);

            valueLabel = option.label;
          }
        } else {
          throw Exception("Unknown value type");
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
