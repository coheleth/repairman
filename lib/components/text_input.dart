import 'package:flutter/material.dart';

InputDecoration defaultDecoration(BuildContext context) => InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.always,
  fillColor: Theme.of(context).colorScheme.surfaceContainer,
  filled: true,
);

class TextInput extends StatefulWidget {
  final String labelText;
  final Function(String? value)? onSaved;
  final Function(String value)? onChanged;
  final String? initialValue;
  final int? minLines;
  final int? maxLines;
  final bool required;
  const TextInput({
    super.key,
    required this.labelText,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.minLines,
    this.maxLines,
    this.required = false,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: TextFormField(
        decoration: defaultDecoration(context)
            .copyWith(labelText: widget.labelText),
        initialValue: widget.initialValue,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: (value) {
          if (widget.required && (value == null || value.isEmpty)) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }
}
