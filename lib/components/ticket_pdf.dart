import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

List<pw.Widget> partDisplay(String label, List<Part>? parts) {
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
                        'R\$${priceAsString(parts[index].price, comma: true)}',
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ),
                    pw.Padding(
                      padding: cellPadding,
                      child: pw.Text(
                        quantityAsString(parts[index].quantity, comma: true) ??
                            "-",
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
                      'Total Materiais/Peças',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                  pw.Padding(
                    padding: cellPadding,
                    child: pw.Text(
                      'R\$${priceAsString(totalPartsPrice(parts), comma: true)}',
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

Future<Uint8List> ticketToPDF(Ticket ticket) async {
  final pdf = pw.Document();
  final totalPrice =
      (ticket.servicePrice ?? 0) + totalPartsPrice(ticket.parts ?? []);
  final ticketWidget = [
    pw.Row(
      children: [
        pw.Expanded(
          child: textDisplay('Data de Entrada', dateAsString(ticket.startDate)),
        ),
        pw.Expanded(
          child: textDisplay(
            'Prometido Para',
            dateAsString(ticket.deliveryDate),
          ),
        ),
      ],
    ),
    pw.Row(
      children: [
        pw.Expanded(child: textDisplay('Cliente', ticket.clientName)),
        pw.Expanded(child: textDisplay('CPF/CNPJ', ticket.clientDocument)),
      ],
    ),
    pw.Row(
      children: [
        pw.Expanded(child: textDisplay('Endereço', ticket.clientAddress)),
        pw.Expanded(child: textDisplay('Contato', ticket.clientContact)),
      ],
    ),
    if ((ticket.location ?? "").isNotEmpty)
      textDisplay('Local', ticket.location),
    if ((ticket.repairTarget ?? "").isNotEmpty)
      textDisplay('Aparelho/Equipamento', ticket.repairTarget),
    if ((ticket.repairCondition ?? "").isNotEmpty)
      textDisplay('Condições de Entrada', ticket.repairCondition),
    if ((ticket.repairDiagnosis ?? "").isNotEmpty)
      textDisplay('Diagnóstico', ticket.repairDiagnosis),
    if ((ticket.obs ?? "").isNotEmpty) textDisplay('Obs.', ticket.obs),
    pw.Row(
      children: [
        pw.Expanded(child: textDisplay('Serviço', ticket.service)),
        pw.Expanded(
          child: textDisplay(
            'Mão De Obra',
            'R\$${priceAsString(ticket.servicePrice ?? 0)}',
          ),
        ),
      ],
    ),
    ...partDisplay('Materiais/Peças', ticket.parts),
    textDisplay('Valor Total', 'R\$${priceAsString(totalPrice)}'),
  ];
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => ticketWidget,
    ),
  );
  return await pdf.save();
}
