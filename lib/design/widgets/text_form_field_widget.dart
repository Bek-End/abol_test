import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines,
  });

  final String label;
  final TextEditingController controller;
  final int? maxLines;

  OutlineInputBorder get border => OutlineInputBorder(
        borderSide: const BorderSide(width: 2.0),
        borderRadius: BorderRadius.circular(12),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        label: Text(label),
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
      ),
    );
  }
}
