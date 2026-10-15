import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.g.dart';

enum Currency { usd, brl, gbp, eur }

@immutable
class SettingsStateObject {
  final Currency currency;
  final Locale? locale;

  const SettingsStateObject({this.currency = Currency.usd, this.locale});

  SettingsStateObject withCurrency(Currency currency) =>
      SettingsStateObject(currency: currency, locale: locale);

  SettingsStateObject withLocale(Locale? locale) =>
      SettingsStateObject(currency: currency, locale: locale);

  String currencyString(String? value) => switch (currency) {
    Currency.usd => "\$${value ?? ''}",
    Currency.brl => "R\$${value ?? ''}",
    Currency.gbp => "£${value ?? ''}",
    Currency.eur => "${value ?? ''}€",
  };
}

@Riverpod(keepAlive: true)
class SettingsState extends _$SettingsState {
  @override
  SettingsStateObject build() => SettingsStateObject();

  void setValues(Currency currency, Locale? locale) {
    state = SettingsStateObject(currency: currency, locale: locale);
  }

  void setCurrency(Currency currency) async {
    state = state.withCurrency(currency);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currency', currency.index);
  }

  void setLocale(Locale? locale) async {
    state = state.withLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    if (locale != null) {
      prefs.setString('locale', locale.languageCode);
    } else {
      await prefs.remove('locale');
    }
  }
}
