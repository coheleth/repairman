import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/data/state/settings_state.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;
    final MenuController languageController = MenuController();
    final MenuController currencyController = MenuController();
    return Scaffold(
      appBar: AppBar(title: Text(locale.settings)),
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          width: min(constraints.maxWidth, 600),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(locale.settingsLanguage)),
                    DropdownMenu(
                      selectOnly: true,
                      menuController: languageController,
                      initialSelection: ref.read(settingsStateProvider).locale,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: null,
                          label: locale.settingsLanguageDefault,
                        ),
                        DropdownMenuEntry(
                          value: Locale('en'),
                          label: 'English',
                        ),
                        DropdownMenuEntry(
                          value: Locale('pt'),
                          label: 'Português',
                        ),
                      ],
                      onSelected: (value) {
                        ref
                            .read(settingsStateProvider.notifier)
                            .setLocale(value);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text(locale.settingsCurrency)),
                    DropdownMenu(
                      selectOnly: true,
                      menuController: currencyController,
                      initialSelection: ref
                          .read(settingsStateProvider)
                          .currency,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: Currency.usd,
                          label: 'US Dollar (USD)',
                        ),
                        DropdownMenuEntry(
                          value: Currency.eur,
                          label: 'Euro (EUR)',
                        ),
                        DropdownMenuEntry(
                          value: Currency.gbp,
                          label: 'Pound Sterling (GBP)',
                        ),
                        DropdownMenuEntry(
                          value: Currency.brl,
                          label: 'Real (BRL)',
                        ),
                      ],
                      onSelected: (value) {
                        ref
                            .read(settingsStateProvider.notifier)
                            .setCurrency(value ?? Currency.usd);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
