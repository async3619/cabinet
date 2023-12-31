import 'package:cabinet/database/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddFilterDialog extends StatefulWidget {
  final void Function(Filter) onSubmit;

  const AddFilterDialog({
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  State<AddFilterDialog> createState() => _AddFilterDialogState();
}

class _AddFilterDialogState extends State<AddFilterDialog> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a new filter'),
      content: SingleChildScrollView(
          child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'keyword',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Keyword',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            FormBuilderDropdown<SearchLocation>(
              name: 'location',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              decoration: const InputDecoration(
                labelText: 'Search Location',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              ),
              items: const [
                DropdownMenuItem(
                  value: SearchLocation.subject,
                  child: Text('Subject'),
                ),
                DropdownMenuItem(
                  value: SearchLocation.content,
                  child: Text('Content'),
                ),
                DropdownMenuItem(
                  value: SearchLocation.subjectContent,
                  child: Text('Subject, Content'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FormBuilderCheckbox(
              name: 'caseSensitive',
              title: const Text('Case Sensitive'),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      )),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.saveAndValidate()) {
              final values = formKey.currentState!.value;
              final filter = Filter();
              filter.keyword = values['keyword'];
              filter.location = values['location'];
              filter.caseSensitive = values['caseSensitive'];

              widget.onSubmit(filter);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
