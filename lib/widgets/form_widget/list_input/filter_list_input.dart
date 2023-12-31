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

  String buildFilterText(Filter filter) {
    final tokens = <String>[filter.keyword!];

    if (filter.location != null) {
      String location;
      switch (filter.location!) {
        case SearchLocation.content:
          location = 'Content';
          break;

        case SearchLocation.subject:
          location = 'Subject';
          break;

        case SearchLocation.subjectContent:
          location = 'Subject or Content';
          break;
      }

      tokens.add(location);
    }

    tokens.add(
        filter.caseSensitive == true ? 'Case Sensitive' : 'Case Insensitive');

    if (filter.exclude == true) {
      tokens.add('Exclude');
    }

    return tokens.join(', ');
  }

  Widget buildItem(FormFieldState<List<Filter>> field, Filter filter, int index,
      List<Filter> value) {
    return ListTile(
      title: Text('Filter ${index + 1}'),
      subtitle: Text(buildFilterText(filter)),
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
              buildItem(field, value[i], i, value),
            ListTile(
              onTap: () => handleAddFilterClick(context, field),
              title: Text(
                field.errorText ?? 'Add a new filter',
                style: TextStyle(
                  color: field.errorText != null
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
              leading: const Icon(Icons.add),
            )
          ],
        );
      },
    );
  }
}
