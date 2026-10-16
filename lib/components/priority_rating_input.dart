import 'package:material_ui/material_ui.dart';

class PriorityRatingInput extends StatefulWidget {
  final String label;
  final int? rating;
  final Function(int value)? onChanged;
  const PriorityRatingInput({
    super.key,
    required this.label,
    this.rating = 0,
    this.onChanged,
  });

  @override
  State<PriorityRatingInput> createState() => _PriorityRatingInputState();
}

class _PriorityRatingInputState extends State<PriorityRatingInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              5,
              (index) => IconButton(
                icon: Icon(
                  (widget.rating ?? 0) >= index
                      ? Icons.radio_button_on
                      : Icons.radio_button_off,
                ),
                onPressed: () {
                  widget.onChanged?.call(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
