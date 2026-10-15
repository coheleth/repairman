import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/state/settings_state.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/views/ticket_dashboard.dart';
import 'package:repairman/messaging.dart';
import 'package:repairman/shortcuts.dart';
import 'package:repairman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final prefs = await SharedPreferences.getInstance();
  final settings = container.read(settingsStateProvider.notifier);

  settings.setValues(
    Currency.values[prefs.getInt('currency') ?? 0],
    prefs.getString('locale') != null
        ? Locale(prefs.getString('locale')!)
        : null,
  );

  runApp(RepairmanApp(container: container));
}

class RepairmanApp extends StatelessWidget {
  final ProviderContainer container;
  const RepairmanApp({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: container,
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
