import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/models/status.dart';
import 'package:repairman/data/state/status_list.dart';
import 'package:repairman/components/text_input.dart';

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
            isExpanded: true,
            initialValue: safeInitialValue,
            decoration: defaultDecoration(context)
                .copyWith(labelText: labelText),
            items: List<DropdownMenuItem>.generate(
              statuses.length,
              (int index) => DropdownMenuItem(
                value: statuses[index].id,
                child: Text(
                  Status.localisedName(statuses[index].name, context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
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
