import 'package:cabinet/widgets/form_widget/form_field_item.dart';
import 'package:flutter/material.dart';

class SelectDialog extends StatefulWidget {
  final String title;
  final Future<List<SelectOption>> Function() getOptions;
  final void Function(List<String>) onSubmit;
  final bool multiple;

  final List<String>? initialSelection;

  const SelectDialog({
    Key? key,
    required this.title,
    required this.getOptions,
    required this.onSubmit,
    this.multiple = false,
    this.initialSelection,
  }) : super(key: key);

  @override
  State<SelectDialog> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  Future<List<SelectOption>> optionsFuture = Future.value([]);
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    optionsFuture = widget.getOptions();
    selectedOptions = widget.initialSelection ?? [];
  }

  Widget buildOption(SelectOption option) {
    if (!widget.multiple) {
      return RadioListTile<String>(
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
      content: FutureBuilder<List<SelectOption>>(
        future: optionsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (var option in snapshot.data!) buildOption(option),
                ],
              ),
            );
          }

          return const SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
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
