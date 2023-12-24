import 'package:cabinet/database/filter.dart';
import 'package:cabinet/widgets/form_widget/dialogs/add_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../form_field_item.dart';

class FilterListInput extends StatefulWidget {
  final FilterFormFieldItem field;

  const FilterListInput({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<FilterListInput> createState() => _FilterListInputState();
}

class _FilterListInputState extends State<FilterListInput> {
  handleAddFilterClick(
      BuildContext context, FormFieldState<List<Filter>> field) {
    showDialog(
        context: context,
        builder: (context) => AddFilterDialog(
              onSubmit: (filter) {
                field.didChange([...field.value ?? [], filter]);
                Navigator.of(context).pop();
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<Filter>>(
      name: widget.field.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.field.validator,
      builder: (field) {
        var value = field.value ?? [];

        return Column(
          children: [
            for (var i = 0; i < value.length; i++)
              ListTile(
                title: Text("Filter ${i + 1}"),
                subtitle: Text(
                    "${value[i].keyword}, ${value[i].location!.name}, ${value[i].caseSensitive! ? 'Case Sensitive' : 'Case Insensitive'}"),
                trailing: IconButton(
                  splashRadius: 16,
                  iconSize: 20,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    value.removeAt(i);
                    field.didChange(value);
                  },
                ),
              ),
            ListTile(
              onTap: () => handleAddFilterClick(context, field),
              title: const Text("Add a new filter"),
              leading: const Icon(Icons.add),
            )
          ],
        );
      },
    );
  }
}
