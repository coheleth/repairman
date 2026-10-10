import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/views/settings.dart';
import 'package:repairman/views/ticket_edit.dart';
import 'package:repairman/views/ticket_list.dart';

class TicketDashboard extends ConsumerWidget {
  const TicketDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listKey = GlobalKey();
    final appState = ref.watch(appStateProvider);
    final ticketList = TicketList(
      key: listKey,
      onOpenSettings: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Settings()));
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            if (MediaQuery.of(context).size.width >= 800)
              SizedBox(width: 360, child: ticketList),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                child: Material(
                  child: IndexedStack(
                    index: appState.isEditing ? 1 : 0,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (MediaQuery.of(context).size.width < 800) {
                            return ticketList;
                          } else {
                            return Center(child: Text('repairman'));
                          }
                        },
                      ),
                      TicketEdit(key: ValueKey(appState.openTicket)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
