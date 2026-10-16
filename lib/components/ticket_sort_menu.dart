import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/data/state/ticket_sort.dart';
import 'package:repairman/components/expressive_menu.dart';

class TicketSortMenu extends ConsumerWidget {
  // final String label;
  final bool active;
  const TicketSortMenu({super.key, this.active = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;

    final sort = ref.watch(ticketSortProvider);
    final sortMode = sort.mode;
    final sortDirection = sort.direction;

    final sortModeText = switch (sortMode) {
      TicketSortMode.service => locale.ticketService,
      TicketSortMode.status => locale.status,
      TicketSortMode.client => locale.ticketClientName,
      TicketSortMode.startDate => locale.ticketStartDate,
      TicketSortMode.deliveryDate => locale.ticketDeliveryDate,
      TicketSortMode.priority => locale.ticketPriority,
    };

    final sortDirectionText = switch (sortDirection) {
      TicketSortDirection.ascending => locale.sortAscending,
      TicketSortDirection.descending => locale.sortDescending,
    };
    // final sortDirectionText = switch (sortMode) {
    //   TicketSortMode.startDate => switch (sortDirection) {
    //     TicketSortDirection.ascending => locale.sortAscendingDatePast,
    //     TicketSortDirection.descending => locale.sortDescendingDatePast,
    //   },
    //   TicketSortMode.deliveryDate => switch (sortDirection) {
    //     TicketSortDirection.ascending => locale.sortAscendingDate,
    //     TicketSortDirection.descending => locale.sortDescendingDate,
    //   },
    //   TicketSortMode.client ||
    //   TicketSortMode.service => switch (sortDirection) {
    //     TicketSortDirection.ascending => locale.sortAscendingText,
    //     TicketSortDirection.descending => locale.sortDescendingText,
    //   },
    //   _ => switch (sortDirection) {
    //     TicketSortDirection.ascending => locale.sortAscending,
    //     TicketSortDirection.descending => locale.sortDescending,
    //   },
    // };

    final buttonLabelText = "$sortModeText - $sortDirectionText";

    void onChanged(TicketSortMode sortMode, TicketSortDirection sortDirection) {
      ref.read(ticketSortProvider.notifier).setSort(sortMode, sortDirection);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: ExpressiveMenu(
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
              return TextButton.icon(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: Icon(Icons.sort),
                label: Text(
                  buttonLabelText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
        menuChildren: [
          ExpressiveMenuItem(
            onPressed: () {
              if (sortMode != TicketSortMode.startDate) {
                onChanged(
                  TicketSortMode.startDate,
                  TicketSortDirection.descending,
                );
              }
            },
            active: sortMode == TicketSortMode.startDate,
            leadingIcon: sortMode == TicketSortMode.startDate
                ? Icon(Icons.check)
                : Icon(null),
            child: Text(locale.ticketStartDate),
          ),
          ExpressiveMenuItem(
            onPressed: () {
              if (sortMode != TicketSortMode.deliveryDate) {
                onChanged(
                  TicketSortMode.deliveryDate,
                  TicketSortDirection.ascending,
                );
              }
            },
            active: sortMode == TicketSortMode.deliveryDate,
            leadingIcon: sortMode == TicketSortMode.deliveryDate
                ? Icon(Icons.check)
                : Icon(null),
            child: Text(locale.ticketDeliveryDate),
          ),
          ExpressiveMenuItem(
            onPressed: () {
              if (sortMode != TicketSortMode.priority) {
                onChanged(
                  TicketSortMode.priority,
                  TicketSortDirection.ascending,
                );
              }
            },
            active: sortMode == TicketSortMode.priority,
            leadingIcon: sortMode == TicketSortMode.priority
                ? Icon(Icons.check)
                : Icon(null),
            child: Text(locale.ticketPriority),
          ),
          ExpressiveMenuItem(
            onPressed: () {
              if (sortMode != TicketSortMode.client) {
                onChanged(TicketSortMode.client, TicketSortDirection.ascending);
              }
            },
            active: sortMode == TicketSortMode.client,
            leadingIcon: sortMode == TicketSortMode.client
                ? Icon(Icons.check)
                : Icon(null),
            child: Text(locale.ticketClientName),
          ),
          ExpressiveMenuItem(
            onPressed: () {
              if (sortMode != TicketSortMode.service) {
                onChanged(
                  TicketSortMode.service,
                  TicketSortDirection.ascending,
                );
              }
            },
            active: sortMode == TicketSortMode.service,
            leadingIcon: sortMode == TicketSortMode.service
                ? Icon(Icons.check)
                : Icon(null),
            child: Text(locale.ticketService),
          ),
          ExpressiveMenuItem(
            onPressed: () {
              if (sortMode != TicketSortMode.status) {
                onChanged(
                  TicketSortMode.status,
                  TicketSortDirection.descending,
                );
              }
            },
            active: sortMode == TicketSortMode.status,
            leadingIcon: sortMode == TicketSortMode.status
                ? Icon(Icons.check)
                : Icon(null),
            child: Text(locale.status),
          ),
          PopupMenuDivider(),

          ExpressiveMenuItem(
            onPressed: () {
              if (sortDirection != TicketSortDirection.ascending) {
                onChanged(sortMode, TicketSortDirection.ascending);
              }
            },
            active: sortDirection == TicketSortDirection.ascending,
            leadingIcon: sortDirection == TicketSortDirection.ascending
                ? Icon(Icons.check)
                : Icon(null),
            child: Text(switch (sortMode) {
              TicketSortMode.startDate => locale.sortAscendingDatePast,
              TicketSortMode.deliveryDate => locale.sortAscendingDate,
              TicketSortMode.service ||
              TicketSortMode.client => locale.sortAscendingText,
              _ => locale.sortAscending,
            }),
          ),

          ExpressiveMenuItem(
            onPressed: () {
              if (sortDirection != TicketSortDirection.descending) {
                onChanged(sortMode, TicketSortDirection.descending);
              }
            },
            active: sortDirection == TicketSortDirection.descending,
            leadingIcon: sortDirection == TicketSortDirection.descending
                ? Icon(Icons.check)
                : Icon(null),
            child: Text(switch (sortMode) {
              TicketSortMode.startDate => locale.sortDescendingDatePast,
              TicketSortMode.deliveryDate => locale.sortDescendingDate,
              TicketSortMode.service ||
              TicketSortMode.client => locale.sortDescendingText,
              _ => locale.sortDescending,
            }),
          ),
        ],
      ),
    );
  }
}
