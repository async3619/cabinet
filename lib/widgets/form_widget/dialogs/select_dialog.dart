import 'package:cabinet/widgets/form_widget/form_field_item.dart';
import 'package:flutter/material.dart';

class SelectDialog<T> extends StatefulWidget {
  final String title;
  final List<SelectOption<T>> options;
  final void Function(List<T>) onSubmit;
  final bool multiple;

  final List<T>? initialSelection;

  const SelectDialog({
    Key? key,
    required this.title,
    required this.options,
    required this.onSubmit,
    this.multiple = false,
    this.initialSelection,
  }) : super(key: key);

  @override
  State<SelectDialog<T>> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<SelectDialog<T>> {
  List<T> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.initialSelection ?? [];
  }

  Widget buildOption(SelectOption option) {
    if (!widget.multiple) {
      return RadioListTile<T>(
        dense: true,
        title: Text(option.label),
        value: option.value,
        groupValue: selectedOptions.firstOrNull,
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            selectedOptions = [value];
          });
        },
      );
    }

    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      title: Text(option.label),
      value: selectedOptions.contains(option.value),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            selectedOptions.add(option.value);
          } else {
            selectedOptions.remove(option.value);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (var option in widget.options) buildOption(option),
          ],
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
            widget.onSubmit(selectedOptions);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
