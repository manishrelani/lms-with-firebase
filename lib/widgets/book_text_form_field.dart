import 'package:flutter/material.dart';

class BookTextFormField extends StatelessWidget {
  final String labelText;
  final String errorText;

  final TextEditingController controller;

  BookTextFormField({
    @required this.labelText,
    @required this.errorText,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.caption.copyWith(
            fontSize: 16.0,
          ),
      decoration: InputDecoration(
          labelText: labelText,
          errorStyle: TextStyle(
            fontSize: 15.0,
            height: 0.9,
          ),
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty || value.trim().isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }
}
