import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/models/status.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/components/confirm_close.dart';
import 'package:repairman/components/ticket_context_menu.dart';

class TicketCard extends ConsumerWidget {
  final Ticket ticket;
  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;

    final appState = ref.watch(appStateProvider);
    final bool active = (appState.openTicket?.id ?? -1) == ticket.id;
    final color = active
        ? Theme.of(context).colorScheme.onSecondaryContainer
        : Theme.of(context).colorScheme.onSurface;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TicketMenu(context: context, ref: ref, ticketId: ticket.id).contextMenu(
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
                            Status.localisedName(
                              ticket.statusName ?? '-',
                              context,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: color),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(
                        5,
                        (index) => Icon(
                          (ticket.priority ?? 0) >= index
                              ? Icons.radio_button_on
                              : Icons.radio_button_off,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${locale.ticketClientName}: ${ticket.clientName ?? '-'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: color),
                          ),
                          Text(
                            '${locale.ticketService}: ${ticket.service ?? '-'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: color),
                          ),
                          Text(
                            "${locale.ticketStartDate}: ${dateAsString(ticket.startDate) ?? '-'}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: color),
                          ),
                          Text(
                            "${locale.ticketDeliveryDate}: ${dateAsString(ticket.deliveryDate) ?? '-'}",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
