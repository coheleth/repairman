import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String labelText;
  final Function onSaved;
  final String? initialValue;
  final int? minLines;
  final int? maxLines;
  final bool required;
  const TextInput({
    super.key,
    required this.labelText,
    required this.onSaved,
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
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(),
        ),
        initialValue: widget.initialValue,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        onSaved: (String? value) => widget.onSaved(value),
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
