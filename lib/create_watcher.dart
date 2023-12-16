import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'components/widgets/form_field_item.dart';
import 'components/widgets/form_widget.dart';

class CreateWatcherRoute extends StatefulWidget {
  const CreateWatcherRoute({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CreateWatcherRoute> createState() => _CreateWatcherRouteState();
}

class _CreateWatcherRouteState extends State<CreateWatcherRoute> {
  final formKey = GlobalKey<FormBuilderState>();

  get formFields => [
    TextFormFieldItem(
      name: 'name',
      label: 'Name',
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    ),
    SelectFormFieldItem(
      name: 'url',
      label: 'URL',
      options: [
        'https://www.google.com',
        'https://www.facebook.com',
        'https://www.twitter.com',
      ],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // add submit button
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (formKey.currentState!.saveAndValidate()) {
              }
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormWidget(
                formKey: formKey,
                fields: formFields,
              )
            ),
          ],
        ),
      ),
    );
  }
}