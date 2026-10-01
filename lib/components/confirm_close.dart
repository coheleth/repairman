import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/state/app_state.dart';

Future<bool> confirmClose(BuildContext context, WidgetRef ref) async {
  if (!ref.read(appStateProvider).modified) {
    return true;
  }
  bool confirmed = false;
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Cancelar alterações?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              confirmed = true;
            },
            child: Text('Sim'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            autofocus: true,
            child: Text('Não'),
          ),
        ],
      );
    },
  );
  return confirmed;
}
