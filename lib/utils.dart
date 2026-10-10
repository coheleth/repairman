import 'package:intl/intl.dart';
import 'package:repairman/data/models/part.dart';

String? priceAsString(double? price, {bool comma = false}) {
  if (price == null) return null;
  String priceString = price.toStringAsFixed(2);
  if (comma) {
    int commaPosition = priceString.lastIndexOf('.');
    priceString = priceString
        .replaceAll(',', '.')
        .replaceRange(commaPosition, commaPosition + 1, ',');
  }
  return priceString;
}

String? quantityAsString(double? quantity, {bool comma = false}) {
  if (quantity == null) return null;
  String quantityString = quantity.toString();
  if (comma) {
    int commaPosition = quantityString.lastIndexOf('.');
    quantityString = quantityString
        .replaceAll(',', '.')
        .replaceRange(commaPosition, commaPosition + 1, ',');
  }
  return quantityString;
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
