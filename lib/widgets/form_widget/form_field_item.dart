import 'package:flutter/material.dart';

class FormFieldItem {
  final String name;
  final String label;
  final FormFieldValidator? validator;

  FormFieldItem({
    required this.name,
    required this.label,
    this.validator,
  });
}

class TextFormFieldItem extends FormFieldItem {
  TextFormFieldItem({
    required String name,
    required String label,
    FormFieldValidator? validator,
  }) : super(
          name: name,
          label: label,
          validator: validator,
        );
}

class SelectOption {
  final String value;
  final String label;

  SelectOption({
    required this.value,
    required this.label,
  });
}

class SelectFormFieldItem extends FormFieldItem {
  final Future<List<SelectOption>> Function() getOptions;
  final bool? multiple;

  SelectFormFieldItem({
    required String name,
    required String label,
    FormFieldValidator? validator,
    required this.getOptions,
    this.multiple,
  }) : super(
          name: name,
          label: label,
          validator: validator,
        );
}
