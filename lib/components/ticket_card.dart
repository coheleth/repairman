import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/models/status.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/components/confirm_close.dart';
import 'package:repairman/components/ticket_context_menu.dart';

class TicketCard extends ConsumerWidget {
  final Ticket ticket;
  final GlobalKey<NavigatorState> navigatorKey;
  const TicketCard({
    super.key,
    required this.ticket,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final bool active = (appState.openTicket?.id ?? -1) == ticket.id;
    final color = active
        ? Theme.of(context).colorScheme.onSecondaryContainer
        : Theme.of(context).colorScheme.onSurface;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child:
          TicketMenu(
            context: context,
            ref: ref,
            navigatorKey: navigatorKey,
            ticketId: ticket.id,
          ).contextMenu(
            onTap: () async {
              final appState = ref.read(appStateProvider);
              if (appState.openTicket?.id == ticket.id) {
                return;
              }
              if (appState.isEditing) {
                if (!await confirmClose(context, ref)) {
                  return;
                }
              }
              final liveTicket = await DBController().getTicketById(ticket.id);
              ref.read(appStateProvider.notifier).setEditing(liveTicket);
              navigatorKey.currentState?.popUntil((route) => route.isFirst);
              navigatorKey.currentState?.pushNamed('open');
            },
            child: Card(
              color: active
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : null,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticketIdAsString(ticket.id),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: color),
                              ),
                              Text(
                                ticket.statusName ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: color),
                              ),
                            ],
                          ),
                        ),
                        Icon(switch (ticket.done) {
                          Done.inProgress => null,
                          Done.done => Icons.done,
                          Done.doneAll => Icons.done_all,
                        }),
                      ],
                    ),
                    Container(height: 8),

                    Text(
                      'Cliente: ${ticket.clientName ?? '-'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: color),
                    ),
                    Text(
                      'Serviço: ${ticket.service ?? '-'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: color),
                    ),
                    Text(
                      "Data de Entrada: ${dateAsString(ticket.startDate) ?? '-'}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: color),
                    ),
                    Text(
                      "Prometido para: ${dateAsString(ticket.deliveryDate) ?? '-'}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: color),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
