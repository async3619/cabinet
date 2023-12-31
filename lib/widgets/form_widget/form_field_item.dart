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

class SelectOption<T> {
  final T value;
  final String label;

  SelectOption({
    required this.value,
    required this.label,
  });
}

abstract class SelectFormFieldItem<T> extends FormFieldItem {
  final List<SelectOption<T>> Function() getOptions;

  SelectFormFieldItem({
    required String name,
    required String label,
    FormFieldValidator? validator,
    required this.getOptions,
  }) : super(
          name: name,
          label: label,
          validator: validator,
        );
}

class SingularSelectFormFieldItem<T> extends SelectFormFieldItem<T> {
  final String Function(T?)? formatValue;

  SingularSelectFormFieldItem({
    required String name,
    required String label,
    FormFieldValidator? validator,
    required List<SelectOption<T>> Function() getOptions,
    this.formatValue,
  }) : super(
          name: name,
          label: label,
          validator: validator,
          getOptions: getOptions,
        );
}

class MultipleSelectFormFieldItem<T> extends SelectFormFieldItem<T> {
  final String Function(List<T>)? formatValue;

  MultipleSelectFormFieldItem({
    required String name,
    required String label,
    FormFieldValidator? validator,
    required List<SelectOption<T>> Function() getOptions,
    this.formatValue,
  }) : super(
          name: name,
          label: label,
          validator: validator,
          getOptions: getOptions,
        );
}

class FilterFormFieldItem extends FormFieldItem {
  FilterFormFieldItem({
    required String name,
    required String label,
    FormFieldValidator? validator,
  }) : super(
          name: name,
          label: label,
          validator: validator,
        );
}
