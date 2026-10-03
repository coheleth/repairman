import 'package:flutter/material.dart';
import 'package:repairman/views/ticket_edit.dart';
import 'package:repairman/views/ticket_list.dart';

class TicketDashboard extends StatelessWidget {
  const TicketDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final listKey = GlobalKey();
    final navigatorKey = GlobalKey<NavigatorState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            if (MediaQuery.of(context).size.width >= 800)
              SizedBox(
                width: 360,
                child: Navigator(
                  onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (context) =>
                        TicketList(key: listKey, navigatorKey: navigatorKey),
                  ),
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
                      if (settings.name == 'open') {
                        return MaterialPageRoute(
                          builder: (context) =>
                              TicketEdit(navigatorKey: navigatorKey),
                        );
                      }

                      return MaterialPageRoute(
                        builder: (context) => LayoutBuilder(
                          builder: (context, constraints) {
                            if (MediaQuery.of(context).size.width < 800) {
                              return TicketList(
                                key: listKey,
                                navigatorKey: navigatorKey,
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
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
