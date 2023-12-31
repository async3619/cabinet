import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/filter.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../widgets/form_widget/form_field_item.dart';
import '../widgets/form_widget/form_widget.dart';

class CreateWatcherRoute extends StatefulWidget {
  const CreateWatcherRoute({
    Key? key,
    required this.title,
    this.watcher,
  }) : super(key: key);

  final String title;
  final Watcher? watcher;

  @override
  State<CreateWatcherRoute> createState() => _CreateWatcherRouteState();
}

class _CreateWatcherRouteState extends State<CreateWatcherRoute> {
  final formKey = GlobalKey<FormBuilderState>();
  final ImageBoardApi api = ImageBoardApi(
    baseUrl: 'https://a.4cdn.org',
  );

  final Map<String, dynamic> initialValues = {};
  List<Board> _boards = [];

  @override
  void initState() {
    super.initState();

    (() async {
      final holder = Provider.of<RepositoryHolder>(context, listen: false);
      final boards = await holder.board.getBoards();

      setState(() {
        _boards = boards;
      });
    })();

    if (widget.watcher != null) {
      initialValues['name'] = widget.watcher!.name;
      initialValues['boards'] =
          widget.watcher!.boards.map((board) => board.code!).toList();
      initialValues['filters'] = widget.watcher!.filters.toList();
      initialValues['crawlingInterval'] = widget.watcher!.crawlingInterval;
      initialValues['archived'] = widget.watcher!.archived;
    }
  }

  List<FormFieldGroup> getFormFields(BuildContext context) {
    return [
      FormFieldGroup(name: 'General', fields: [
        TextFormFieldItem(
            name: 'name',
            label: 'Name',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]))
      ]),
      FormFieldGroup(name: 'Target', fields: [
        MultipleSelectFormFieldItem<String>(
          name: 'boards',
          label: 'Boards',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
          formatValue: (values) =>
              values.map((code) => '/$code/').join(', ').toString(),
          getOptions: () => _boards.map((board) {
            return SelectOption(value: board.code!, label: board.name);
          }).toList(),
        ),
        SwitchFormFieldItem(
            name: 'archived',
            label: 'Check Archived',
            description: 'Enable if you want to check archived post')
      ]),
      FormFieldGroup(name: 'Filters', fields: [
        FilterFormFieldItem(
          name: 'filters',
          label: 'Filters',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
        )
      ]),
      FormFieldGroup(name: 'Settings', fields: [
        SingularSelectFormFieldItem(
            name: 'crawlingInterval',
            label: 'Crawling Interval',
            getOptions: () => [
                  SelectOption(value: 15, label: '15 Minutes'),
                  SelectOption(value: 30, label: '30 Minutes'),
                  SelectOption(value: 60, label: '1 Hour'),
                  SelectOption(value: 120, label: '2 Hours'),
                  SelectOption(value: 240, label: '4 Hours'),
                  SelectOption(value: 480, label: '8 Hours'),
                  SelectOption(value: 1440, label: '1 Day'),
                ])
      ])
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
      List<String> boardCodes = value['boards'].cast<String>();
      List<Filter> filters = value['filters'];
      int crawlingInterval = value['crawlingInterval'];
      bool archived = value['archived'] ?? false;

      var selectedBoards =
          boards.where((board) => boardCodes.contains(board.code)).toList();

      if (widget.watcher != null) {
        holder.watcher.update(widget.watcher!.id,
            name: name,
            boards: selectedBoards,
            filters: filters,
            crawlingInterval: crawlingInterval,
            archived: archived);
      } else {
        holder.watcher
            .create(name, selectedBoards, filters, crawlingInterval, archived);
      }
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
            FormWidget(
                formKey: formKey,
                groups: getFormFields(context),
                initialValues: initialValues),
          ],
        ),
      ),
    );
  }
}
