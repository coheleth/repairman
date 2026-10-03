import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/components/confirm_close.dart';

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
    final textStyle = TextStyle(
      color: active
          ? Theme.of(context).colorScheme.onSecondaryContainer
          : Theme.of(context).colorScheme.onSurface,
    );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
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
                Text(
                  ticket.service,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight(600),
                  ),
                ),
                Text(
                  ticket.statusName ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                Text(
                  'Cliente: ${ticket.clientName ?? '-'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Data de Entrada: ${dateAsString(ticket.startDate)}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Prometido para: ${dateAsString(ticket.deliveryDate)}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ),
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
