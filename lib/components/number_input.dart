import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:repairman/components/text_input.dart';

class NumberInput extends StatefulWidget {
  final String labelText;
  final Function(double? value)? onSaved;
  final Function(double? value)? onChanged;
  final String? initialValue;
  final RegExp? regex;
  final bool comma;
  final bool required;
  const NumberInput({
    super.key,
    required this.labelText,
    this.onSaved,
    this.onChanged,
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
        decoration: defaultDecoration(context)
            .copyWith(labelText: widget.labelText),
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
            widget.onSaved?.call(double.parse(value!));
          } else {
            widget.onSaved?.call(null);
          }
        },
        onChanged: (value) {
          if (value != "") {
            if (widget.comma) {
              value = value.replaceAll(',', '.');
            }
            widget.onChanged?.call(double.parse(value));
          } else {
            widget.onChanged?.call(null);
          }
        },
      ),
    );
  }
}
