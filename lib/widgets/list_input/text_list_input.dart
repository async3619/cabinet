import 'package:flutter/material.dart';

import 'package:cabinet/widgets/form_field_item.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TextListInput extends StatefulWidget {
  final TextFormFieldItem field;

  const TextListInput({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<TextListInput> createState() => _TextListInputState();
}

class _TextListInputState extends State<TextListInput> {
  final TextEditingController _controller = TextEditingController();

  handleListTap(FormFieldState<String?> field) {
    _controller.value = _controller.value.copyWith(text: field.value ?? '');

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: widget.field.label,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    field.didChange(null);
                  } else {
                    field.didChange(_controller.text);
                  }

                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String?>(
      name: widget.field.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.field.validator,
      builder: (field) => ListTile(
        title: Text(
          widget.field.label,
          style: TextStyle(
            color: field.hasError ? Theme.of(context).colorScheme.error : null,
          ),
        ),
        subtitle: Text(
          field.errorText ?? field.value ?? '(empty)',
          style: TextStyle(
            color: field.hasError ? Theme.of(context).colorScheme.error : null,
          ),
        ),
        onTap: () => handleListTap(field),
      ),
    );
  }
}
