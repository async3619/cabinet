import 'package:cabinet/widgets/form_widget/form_field_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SwitchListInput extends StatefulWidget {
  final SwitchFormFieldItem field;

  const SwitchListInput({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<SwitchListInput> createState() => _SwitchListInputState();
}

class _SwitchListInputState extends State<SwitchListInput> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: widget.field.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.field.validator,
      builder: (field) {
        final subtitle = field.errorText ?? widget.field.description;

        return SwitchListTile(
          title: Text(
            widget.field.label,
            style: TextStyle(
              color:
                  field.hasError ? Theme.of(context).colorScheme.error : null,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: field.hasError
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                )
              : null,
          value: field.value ?? false,
          onChanged: field.didChange,
        );
      },
    );
  }
}
