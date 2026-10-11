import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  void setCurrency(Currency currency) {
    state = state.withCurrency(currency);
  }

  void setLocale(Locale? locale) {
    state = state.withLocale(locale);
  }
}
