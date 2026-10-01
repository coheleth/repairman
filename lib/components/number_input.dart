import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInput extends StatefulWidget {
  final String labelText;
  final Function(double? value) onSaved;
  final String? initialValue;
  final RegExp? regex;
  final bool comma;
  final bool required;
  const NumberInput({
    super.key,
    required this.labelText,
    required this.onSaved,
    this.initialValue,
    this.regex,
    this.comma = false,
    this.required = false,
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
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
        inputFormatters: [
          if (widget.regex != null)
            FilteringTextInputFormatter.allow(widget.regex!),
        ],
        onSaved: (value) {
          if ((value ?? "") != "") {
            if (widget.comma) {
              value = value!.replaceAll(',', '.');
            }
            widget.onSaved(double.parse(value!));
          } else {
            widget.onSaved(null);
          }
        },
      ),
    );
  }
}
