import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/state/ticket_sort.dart';
import 'package:repairman/shortcuts.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/data/state/ticket_list.dart';
import 'package:repairman/components/status_tab_list.dart';
import 'package:repairman/components/ticket_sort_menu.dart';
import 'package:repairman/components/confirm_close.dart';
import 'package:repairman/components/ticket_card.dart';

class NewTicketIntent extends Intent {
  const NewTicketIntent();
}

class TicketList extends ConsumerWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const TicketList({super.key, required this.navigatorKey});

  void _handleNew(BuildContext context, WidgetRef ref) async {
    if (context.mounted) {
      if (ref.read(appStateProvider).isEditing) {
        if (!await confirmClose(context, ref)) {
          return;
        }
      }
      ref.read(appStateProvider.notifier).setCreating();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      navigatorKey.currentState!.pushNamed('edit');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ShortcutController().on<NewEvent>().listen((event) {
      if (context.mounted) _handleNew(context, ref);
    });

    final ticketList = ref.watch(ticketListProvider);
    final ticketSort = ref.watch(ticketSortProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.0,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: FilledButton.icon(
                  onPressed: () {
                    _handleNew(context, ref);
                  },
                  style: FilledButton.styleFrom(padding: EdgeInsets.all(18)),
                  label: Text('Nova Ordem de Serviço'),
                  icon: Icon(Icons.add),
                ),
              ),
              StatusTabList(),
              TicketSortMenu(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ticketList.length,
                itemBuilder: (context, index) => TicketCard(
                  ticket: ticketList[index],
                  navigatorKey: navigatorKey,
                  sortMode: ticketSort.mode,
                  onTap: () async {
                    if (ref.read(appStateProvider).isEditing) {
                      if (!await confirmClose(context, ref)) {
                        return;
                      }
                    }
                    ref.read(appStateProvider.notifier).setIdle();
                    DBController().getTicketById(ticketList[index].id).then((
                      ticket,
                    ) {
                      ref.read(appStateProvider.notifier).setTicket(ticket);
                    });
                    navigatorKey.currentState!.popUntil(
                      (route) => route.isFirst,
                    );
                    navigatorKey.currentState!.pushNamed('view');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
