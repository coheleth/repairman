import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/state/status_list.dart';

class StatusDropdown extends ConsumerWidget {
  final String labelText;
  final Function onChanged;
  final int initialValue;
  const StatusDropdown({
    super.key,
    required this.labelText,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusList = ref.watch(statusListProvider);
    return statusList.when(
      data: (statuses) {
        final values = List<int>.generate(
          statuses.length,
          (index) => statuses[index].id,
        );
        final safeInitialValue = values.contains(initialValue)
            ? initialValue
            : values[0];
        return Padding(
          padding: EdgeInsets.all(12),
          child: DropdownButtonFormField(
            initialValue: safeInitialValue,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(),
            ),

            items: List<DropdownMenuItem>.generate(
              statuses.length,
              (int index) => DropdownMenuItem(
                value: statuses[index].id,
                child: Text(statuses[index].name),
              ),
            ),

            onChanged: (value) {
              onChanged(value);
            },
          ),
        );
      },
      error: (error, stackTrace) => Container(),
      loading: () => Container(),
    );
  }
}
