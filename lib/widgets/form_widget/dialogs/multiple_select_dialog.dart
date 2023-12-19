import 'package:flutter/material.dart';

class MultipleSelectDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String>? selectedOptions;
  final void Function(List<String>) onSubmit;

  const MultipleSelectDialog({
    Key? key,
    required this.title,
    required this.options,
    required this.onSubmit,
    this.selectedOptions,
  }) : super(key: key);

  @override
  State<MultipleSelectDialog> createState() => _MultipleSelectDialogState();
}

class _MultipleSelectDialogState extends State<MultipleSelectDialog> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.selectedOptions ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (var option in widget.options)
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(option),
                value: selectedOptions.contains(option),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedOptions.add(option);
                    } else {
                      selectedOptions.remove(option);
                    }
                  });
                },
              ),
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
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
