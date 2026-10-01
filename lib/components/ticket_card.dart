import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/data/state/ticket_sort.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/models/ticket.dart';

class TicketCard extends ConsumerWidget {
  final Ticket ticket;
  final TicketSortMode sortMode;
  final GestureTapCallback onTap;
  final GlobalKey<NavigatorState> navigatorKey;
  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
    required this.navigatorKey,
    this.sortMode = TicketSortMode.startDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final bool isThisTicketOpen = (appState.openTicket?.id ?? -1) == ticket.id;
    final contents = TicketCardContents(
      ticket: ticket,
      sortMode: sortMode,
      onTap: onTap,
      navigatorKey: navigatorKey,
      active: isThisTicketOpen,
    );
    return (appState.isEditing)
        ? contents
        : LayoutBuilder(
            builder: ((context, constraints) {
              return LongPressDraggable(
                data: ticket.id,
                feedback: SizedBox(
                  width: constraints.maxWidth,
                  child: contents,
                ),
                child: contents,
              );
            }),
          );
  }
}

class TicketCardContents extends StatelessWidget {
  final Ticket ticket;
  final TicketSortMode sortMode;
  final GestureTapCallback onTap;
  final GlobalKey<NavigatorState> navigatorKey;
  final bool active;
  const TicketCardContents({
    super.key,
    required this.ticket,
    required this.sortMode,
    required this.onTap,
    required this.navigatorKey,
    this.active = false,
  });
  @override
  Widget build(BuildContext context) {
    String subtitle;

    switch (sortMode) {
      case TicketSortMode.deliveryDate:
        subtitle = ticket.deliveryDate != null
            ? "Prometido para ${dateAsString(ticket.deliveryDate)}"
            : "-";
      case TicketSortMode.client:
        subtitle = (ticket.clientName ?? "").isNotEmpty
            ? 'Cliente: ${ticket.clientName}'
            : '-';
      case TicketSortMode.status:
        subtitle = ticket.statusName ?? "-";
      default:
        subtitle = ticket.startDate != null
            ? "Iniciado em ${dateAsString(ticket.startDate)}"
            : "-";
    }
    final textStyle = TextStyle(
      color: active
          ? Theme.of(context).colorScheme.onSecondaryContainer
          : Theme.of(context).colorScheme.onSurface,
    );
    return Card(
      color: active ? Theme.of(context).colorScheme.secondaryContainer : null,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(
          ticket.service,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
        subtitle: Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
        isThreeLine: false,
        onTap: onTap,
      ),
    );
  }
}
