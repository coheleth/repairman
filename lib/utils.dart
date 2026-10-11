import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:repairman/data/models/part.dart';
import 'package:repairman/data/state/settings_state.dart';

String quantityAsString(double quantity, Locale locale) {
  String valueString = quantity.toString();
  if (localeUsesComma(locale)) {
    int commaPosition = valueString.lastIndexOf('.');
    valueString = valueString
        .replaceAll(',', '.')
        .replaceRange(commaPosition, commaPosition + 1, ',');
  }
  return valueString;
}

String priceAsString(double value, Currency currency, Locale locale) {
  String valueString = value.toStringAsFixed(2);
  if (localeUsesComma(locale)) {
    int commaPosition = valueString.lastIndexOf('.');
    valueString = valueString
        .replaceAll(',', '.')
        .replaceRange(commaPosition, commaPosition + 1, ',');
  }
  return switch (currency) {
    Currency.usd => "\$$valueString",
    Currency.brl => "R\$$valueString",
    Currency.gbp => "£$valueString",
    Currency.eur => "$valueString€",
  };
}

double totalPartsPrice(List<Part> parts) {
  double totalPrice = 0;
  for (Part part in parts) {
    totalPrice += part.price * part.quantity;
  }
  return totalPrice;
}

String? dateAsString(DateTime? date) =>
    date != null ? DateFormat("dd/MM/yyyy").format(date) : null;

DateTime unixTimeStampToDate(int timeStamp) =>
    DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

int dateToUnixTimeStamp(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

String ticketIdAsString(int id) {
  return '#${id.toString().padLeft(4, '0')}';
}

bool localeUsesComma(Locale locale) => switch (locale.languageCode) {
  'en' => false,
  'pt' => true,
  _ => true,
};
