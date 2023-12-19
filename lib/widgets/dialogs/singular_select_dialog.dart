import 'package:flutter/material.dart';

class SingularSelectDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? selectedOption;
  final void Function(String) onSubmit;

  const SingularSelectDialog({
    Key? key,
    required this.title,
    required this.options,
    required this.onSubmit,
    this.selectedOption,
  }) : super(key: key);

  @override
  State<SingularSelectDialog> createState() => _SingularSelectDialogState();
}

class _SingularSelectDialogState extends State<SingularSelectDialog> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
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
              RadioListTile(
                dense: true,
                title: Text(option),
                value: option,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
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
            widget.onSubmit(selectedOption!);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
