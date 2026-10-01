import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/state/ticket_sort.dart';
import 'package:repairman/components/expressive_menu.dart';

class TicketSortMenu extends ConsumerWidget {
  // final String label;
  final bool active;
  const TicketSortMenu({super.key, this.active = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(ticketSortProvider);
    final sortMode = sort.mode;
    final sortDirection = sort.direction;

    void onChanged(TicketSortMode sortMode, TicketSortDirection sortDirection) {
      ref.read(ticketSortProvider.notifier).setSort(sortMode, sortDirection);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ExpressiveMenu(
            builder:
                (
                  BuildContext context,
                  MenuController controller,
                  Widget? child,
                ) {
                  return TextButton.icon(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: Icon(Icons.sort),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        Text(switch (sortMode) {
                          TicketSortMode.service => 'Serviço',
                          TicketSortMode.status => 'Status',
                          TicketSortMode.client => 'Nome do Cliente',
                          TicketSortMode.startDate => 'Data de Entrada',
                          TicketSortMode.deliveryDate => 'Data de Entrega',
                        }),
                        Text(switch (sortDirection) {
                          TicketSortDirection.ascending => '(Crescente)',
                          TicketSortDirection.descending => '(Decrescente)',
                        }),
                      ],
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
                child: Text('Data de Entrada'),
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
                child: Text('Data de Entrega'),
              ),
              ExpressiveMenuItem(
                onPressed: () {
                  if (sortMode != TicketSortMode.client) {
                    onChanged(
                      TicketSortMode.client,
                      TicketSortDirection.ascending,
                    );
                  }
                },
                active: sortMode == TicketSortMode.client,
                leadingIcon: sortMode == TicketSortMode.client
                    ? Icon(Icons.check)
                    : Icon(null),
                child: Text('Nome do Cliente'),
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
                child: Text('Serviço'),
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
                child: Text('Status'),
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
                  TicketSortMode.startDate => 'Da mais antiga à mais nova',
                  TicketSortMode.deliveryDate =>
                    'Da mais próxima à mais distante',
                  TicketSortMode.service => 'A a Z',
                  TicketSortMode.client => 'A a Z',
                  _ => 'Crescente',
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
                  TicketSortMode.startDate => 'Da mais nova à mais antiga',
                  TicketSortMode.deliveryDate =>
                    'Da mais distante à mais próxima',
                  TicketSortMode.service => 'Z a A',
                  TicketSortMode.client => 'Z a A',
                  _ => 'Decrescente',
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
