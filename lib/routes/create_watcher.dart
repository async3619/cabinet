import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/filter.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../widgets/form_widget/form_field_item.dart';
import '../widgets/form_widget/form_widget.dart';

class CreateWatcherRoute extends StatefulWidget {
  const CreateWatcherRoute({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CreateWatcherRoute> createState() => _CreateWatcherRouteState();
}

class _CreateWatcherRouteState extends State<CreateWatcherRoute> {
  final formKey = GlobalKey<FormBuilderState>();
  final ImageBoardApi api = ImageBoardApi(
    baseUrl: 'https://a.4cdn.org',
  );

  List<FormFieldGroup> getFormFields(BuildContext context) {
    return [
      FormFieldGroup(name: "General", fields: [
        TextFormFieldItem(
            name: 'name',
            label: 'Name',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]))
      ]),
      FormFieldGroup(name: "Target", fields: [
        SelectFormFieldItem(
          name: 'boards',
          label: 'Boards',
          multiple: true,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
          getOptions: () async {
            return context
                .read<RepositoryHolder>()
                .board
                .getBoards()
                .then((boards) {
              return boards.map((board) {
                return SelectOption(value: board.code!, label: board.name);
              }).toList();
            });
          },
        )
      ]),
      FormFieldGroup(
          name: "Filters",
          fields: [FilterFormFieldItem(name: "filters", label: "Filters")])
    ];
  }

  void handleSubmit(RepositoryHolder holder) {
    if (!formKey.currentState!.saveAndValidate()) {
      return;
    }

    (() async {
      final value = formKey.currentState!.value;
      final boards = await holder.board.getBoards();

      String name = value['name'];
      List<String> boardCodes = value['boards'];
      List<Filter> filters = value['filters'];

      var selectedBoards =
          boards.where((board) => boardCodes.contains(board.code)).toList();

      holder.watcher.create(name, selectedBoards, filters);
    })()
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final holder = Provider.of<RepositoryHolder>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // add submit button
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => handleSubmit(holder)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FormWidget(formKey: formKey, groups: getFormFields(context)),
          ],
        ),
      ),
    );
  }
}
