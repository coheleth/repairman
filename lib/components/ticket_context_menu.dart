import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/data/state/ticket_list.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/components/expressive_menu.dart';
import 'package:repairman/components/ticket_pdf.dart';

class TicketContextMenu extends ConsumerWidget {
  final int ticketId;
  final GlobalKey<NavigatorState> navigatorKey;
  const TicketContextMenu({
    super.key,
    required this.ticketId,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleDelete() {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('Excluir Ordem de Serviço?'),
          content: Text('Isso não pode ser desfeito!'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(ticketListProvider.notifier).delete(ticketId);
                Navigator.of(dialogContext).pop();
                if ((ref.read(appStateProvider).openTicket?.id ?? -1) ==
                    ticketId) {
                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                }
              },
              child: Text('Sim, excluir'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              autofocus: true,
              child: Text('Não excluir'),
            ),
          ],
        ),
      );
    }

    void handleExport() async {
      Ticket ticket = await DBController().getTicketById(ticketId);
      final pdfBytes = await ticketToPDF(ticket);
      FilePicker.saveFile(fileName: 'Ordem de Serviço.pdf', bytes: pdfBytes);
    }

    void handlePrint() async {
      Ticket ticket = await DBController().getTicketById(ticketId);
      final pdfBytes = await ticketToPDF(ticket);
      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
    }

    return ExpressiveMenu(
      builder: (context, controller, widget) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icon(Icons.more_vert_outlined),
        );
      },
      menuChildren: [
        ExpressiveMenuItem(
          onPressed: handleExport,
          child: Text('Exportar PDF'),
        ),
        ExpressiveMenuItem(onPressed: handlePrint, child: Text('Imprimir')),
        ExpressiveMenuItem(onPressed: handleDelete, child: Text('Excluir')),
      ],
    );
  }
}
