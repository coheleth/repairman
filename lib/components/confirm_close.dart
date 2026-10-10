import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/data/state/app_state.dart';

Future<bool> confirmClose(BuildContext context, WidgetRef ref) async {
  final locale = AppLocalizations.of(context)!;
  if (!ref.read(appStateProvider).modified) {
    return true;
  }
  bool confirmed = false;
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(locale.uiConfirmDiscardLabel),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              confirmed = true;
            },
            child: Text(locale.uiConfirmDiscardActionConfirm),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            autofocus: true,
            child: Text(locale.uiConfirmDiscardActionCancel),
          ),
        ],
      );
    },
  );
  return confirmed;
}
