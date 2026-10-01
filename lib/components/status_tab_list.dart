import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/models/status.dart';
import 'package:repairman/data/state/status_list.dart';
import 'package:repairman/data/state/ticket_sort.dart';

class StatusTabList extends ConsumerWidget {
  const StatusTabList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusList = ref.watch(statusListProvider);
    final ticketSort = ref.watch(ticketSortProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: statusList.when(
        data: (data) {
          final statuses = [Status(id: 0, name: 'Tudo'), ...data];
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                spacing: 6.0,
                children: List<Widget>.generate(statuses.length, (int index) {
                  final key = GlobalKey();
                  return ChoiceChip(
                    key: key,
                    label: Text(statuses[index].name),
                    showCheckmark: false,
                    selected: statuses[index].id == ticketSort.status,
                    onSelected: (value) {
                      ref
                          .read(ticketSortProvider.notifier)
                          .setStatus(statuses[index].id);

                      Scrollable.ensureVisible(
                        key.currentContext!,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                      );
                    },
                  );
                }),
              ),
            ),
          );
        },
        error: (error, stackTrace) => Container(),
        loading: () => Container(),
      ),
    );
  }
}
