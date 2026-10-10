import 'package:material_ui/material_ui.dart';
import 'package:repairman/views/settings.dart';
import 'package:repairman/views/ticket_edit.dart';
import 'package:repairman/views/ticket_list.dart';

class TicketDashboard extends StatelessWidget {
  const TicketDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final listKey = GlobalKey();
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    final ticketList = TicketList(
      key: listKey,
      navigatorKey: navigatorKey,
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
              SizedBox(
                width: 360,
                child: Navigator(
                  onGenerateRoute: (settings) =>
                      MaterialPageRoute(builder: (context) => ticketList),
                ),
              ),
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
                  child: Navigator(
                    key: navigatorKey,
                    onGenerateRoute: (settings) {
                      Widget page;
                      if (settings.name == 'open') {
                        page = TicketEdit(navigatorKey: navigatorKey);
                      } else {
                        page = LayoutBuilder(
                          builder: (context, constraints) {
                            if (MediaQuery.of(context).size.width < 800) {
                              return ticketList;
                            } else {
                              return Center(child: Text('repairman'));
                            }
                          },
                        );
                      }

                      return MaterialPageRoute<void>(
                        builder: (context) => page,
                        settings: settings,
                      );
                    },
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
