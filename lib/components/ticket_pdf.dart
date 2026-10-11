import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:repairman/data/state/settings_state.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/models/part.dart';
import 'package:repairman/data/models/ticket.dart';

pw.Widget textDisplay(String label, String? text) {
  String finalText = text ?? '-';
  if (finalText.isEmpty) {
    finalText = '-';
  }
  return pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(label, style: pw.TextStyle(fontSize: 8)),
      pw.Text(finalText, style: pw.TextStyle(fontSize: 12)),
      pw.Padding(padding: pw.EdgeInsets.all(6)),
    ],
  );
}

List<pw.Widget> partDisplay(
  String label,
  List<Part>? parts,
  AppLocalizations localisation,
  Currency currency,
  Locale locale,
) {
  final cellPadding = pw.EdgeInsets.all(4);
  return [
    pw.Text(label, style: pw.TextStyle(fontSize: 8)),
    parts?.isNotEmpty ?? false
        ? pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(),
              1: pw.IntrinsicColumnWidth(),
              2: pw.IntrinsicColumnWidth(),
            },
            children: [
              ...List.generate(
                parts!.length,
                (index) => pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: index % 2 == 1 ? PdfColors.grey200 : null,
                  ),
                  children: [
                    pw.Padding(
                      padding: cellPadding,
                      child: pw.Text(
                        parts[index].name,
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ),
                    pw.Padding(
                      padding: cellPadding,
                      child: pw.Text(
                        priceAsString(parts[index].price, currency, locale),
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ),
                    pw.Padding(
                      padding: cellPadding,
                      child: pw.Text(
                        quantityAsString(parts[index].quantity, locale),
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: PdfColors.grey)),
                ),
                children: [
                  pw.Padding(
                    padding: cellPadding,
                    child: pw.Text(
                      localisation.partTotal,
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                  pw.Padding(
                    padding: cellPadding,
                    child: pw.Text(
                      priceAsString(totalPartsPrice(parts), currency, locale),
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                  pw.Container(),
                ],
              ),
            ],
          )
        : pw.Text('-', style: pw.TextStyle(fontSize: 12)),
    pw.Padding(padding: pw.EdgeInsets.all(6)),
  ];
}

Future<Uint8List> ticketToPDF(
  Ticket ticket,
  AppLocalizations localisation,
  Currency currency,
) async {
  final pdf = pw.Document();
  final totalPrice =
      (ticket.servicePrice ?? 0) + totalPartsPrice(ticket.parts ?? []);
  final locale = Locale(localisation.localeName);
  final ticketWidget = [
    pw.Row(
      children: [
        pw.Expanded(
          child: textDisplay(
            localisation.ticketStartDate,
            dateAsString(ticket.startDate),
          ),
        ),
        pw.Expanded(
          child: textDisplay(
            localisation.ticketDeliveryDate,
            dateAsString(ticket.deliveryDate),
          ),
        ),
      ],
    ),
    pw.Row(
      children: [
        pw.Expanded(
          child: textDisplay(localisation.ticketClientName, ticket.clientName),
        ),
        pw.Expanded(
          child: textDisplay(
            localisation.ticketClientDocument,
            ticket.clientDocument,
          ),
        ),
      ],
    ),
    pw.Row(
      children: [
        pw.Expanded(
          child: textDisplay(
            localisation.ticketClientAddress,
            ticket.clientAddress,
          ),
        ),
        pw.Expanded(
          child: textDisplay(
            localisation.ticketClientContact,
            ticket.clientContact,
          ),
        ),
      ],
    ),
    if ((ticket.location ?? "").isNotEmpty)
      textDisplay(localisation.ticketLocation, ticket.location),
    if ((ticket.repairTarget ?? "").isNotEmpty)
      textDisplay(localisation.ticketRepairTarget, ticket.repairTarget),
    if ((ticket.repairCondition ?? "").isNotEmpty)
      textDisplay(localisation.ticketRepairCondition, ticket.repairCondition),
    if ((ticket.repairDiagnosis ?? "").isNotEmpty)
      textDisplay(localisation.ticketRepairDiagnosis, ticket.repairDiagnosis),
    if ((ticket.obs ?? "").isNotEmpty)
      textDisplay(localisation.ticketObs, ticket.obs),
    pw.Row(
      children: [
        pw.Expanded(
          child: textDisplay(localisation.ticketService, ticket.service),
        ),
        pw.Expanded(
          child: textDisplay(
            localisation.ticketServicePrice,
            priceAsString(ticket.servicePrice ?? 0, currency, locale),
          ),
        ),
      ],
    ),
    ...partDisplay(
      localisation.parts,
      ticket.parts,
      localisation,
      currency,
      locale,
    ),
    textDisplay(
      localisation.ticketTotal,
      priceAsString(totalPrice, currency, locale),
    ),
  ];
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => ticketWidget,
    ),
  );
  return await pdf.save();
}
