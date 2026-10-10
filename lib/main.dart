import 'package:flutter_localizations/flutter_localizations.dart'
    as flutter_localizations;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/state/settings_state.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/views/ticket_dashboard.dart';
import 'package:repairman/messaging.dart';
import 'package:repairman/shortcuts.dart';
import 'package:repairman/app_theme.dart';

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
          child: Focus(autofocus: true, child: AppWrapper()),
        ),
      ),
    );
  }
}

class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    return MaterialApp(
      title: 'Repairman',
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      restorationScopeId: 'root_app_scope',
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,

      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            MessagingController().on<SnackBarEvent>().listen((event) {
              if (context.mounted) {
                if (event.hidePrevious) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }
                ScaffoldMessenger.of(context).showSnackBar(event.snackBar);
              }
            });
            return TicketDashboard();
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
