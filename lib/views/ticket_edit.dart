import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/data/state/ticket_list.dart';
import 'package:repairman/data/models/part.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/components/ticket_form.dart';
import 'package:repairman/components/confirm_close.dart';

class TicketEdit extends ConsumerWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const TicketEdit({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCreating = ref.watch(appStateProvider).isCreating;
    final initialTicket =
        ref.watch(appStateProvider).openTicket ??
        Ticket(id: -1, service: '', statusId: 0);

    return TicketForm(
      navigatorKey: navigatorKey,
      initialTicket: initialTicket,
      isCreating: isCreating,
      onChanged: () {
        ref.read(appStateProvider.notifier).setModified();
      },
      onClose: () async {
        if (!await confirmClose(context, ref)) {
          return;
        }

        if (context.mounted) {
          ref.read(appStateProvider.notifier).setIdle();
          if (ref.read(appStateProvider).openTicket != null) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      },
      onSave: (ticket) async {
        int id = ticket.id;

        if (isCreating) {
          id = await ref.read(ticketListProvider.notifier).create(ticket);
        } else {
          ref.read(ticketListProvider.notifier).update(ticket);
        }

        List<Part> parts = [];
        for (Part originalPart in ticket.parts ?? []) {
          final part = originalPart.copyWith(ticketId: id);
          if (part.markedForRemoval && part.id > 0) {
            DBController().deletePartById(part.id);
          } else if (part.id > 0) {
            DBController().updatePart(part);
            parts.add(part);
          } else {
            DBController().createPart(part);
            parts.add(part);
          }
        }

        Ticket finalTicket = ticket.copyWith(id: id, parts: parts);
        ref.read(appStateProvider.notifier).setEditing(finalTicket);
        ref.read(appStateProvider.notifier).setModified(modified: false);
      },
    );
  }
}
