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

  Widget renderItem(FormFieldState<List<Filter>> field, Filter filter,
      int index, List<Filter> value) {
    final keyword = filter.keyword;
    final location = filter.location?.name ?? "(not set)";
    final caseSensitive = filter.caseSensitive ?? false;

    return ListTile(
      title: Text("Filter ${index + 1}"),
      subtitle: Text(
          "$keyword, $location, ${caseSensitive ? 'Case Sensitive' : 'Case Insensitive'}"),
      trailing: IconButton(
        splashRadius: 16,
        iconSize: 20,
        icon: const Icon(Icons.delete),
        onPressed: () {
          value.removeAt(index);
          field.didChange(value);
        },
      ),
    );
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
              renderItem(field, value[i], i, value),
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
