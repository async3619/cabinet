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

class SelectFormFieldItem extends FormFieldItem {
  final List<String> options;
  final bool? multiple;

  SelectFormFieldItem({
    required String name,
    required String label,
    FormFieldValidator? validator,
    required this.options,
    this.multiple,
  }) : super(
    name: name,
    label: label,
    validator: validator,
  );
}
