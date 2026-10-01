import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/views/ticket_dashboard.dart';
import 'package:repairman/messaging.dart';
import 'package:repairman/shortcuts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Shortcuts(
        shortcuts: shortcuts,
        child: Actions(
          actions: {
            SaveIntent: CallbackAction(
              onInvoke: (intent) => ShortcutController().dispatch(SaveEvent()),
            ),
            NewIntent: CallbackAction(
              onInvoke: (intent) => ShortcutController().dispatch(NewEvent()),
            ),
          },
          child: Focus(
            autofocus: true,
            child: MaterialApp(
              title: 'Repairman',
              theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.cyan)),
              // darkTheme: ThemeData(
              //   colorScheme: .fromSeed(
              //     seedColor: Colors.cyan,
              //     brightness: Brightness.dark,
              //   ),
              // ),
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    MessagingController().on<SnackBarEvent>().listen((event) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(event.snackBar);
                      }
                    });
                    return TicketDashboard();
                  },
                ),
              ),
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
  }
}
