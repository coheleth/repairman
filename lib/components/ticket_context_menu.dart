import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/shortcuts.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/data/state/ticket_list.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/components/expressive_menu.dart';
import 'package:repairman/components/ticket_pdf.dart';

class TicketMenu {
  final int ticketId;
  final BuildContext context;
  final WidgetRef ref;
  const TicketMenu({
    required this.context,
    required this.ref,
    required this.ticketId,
  });

  List<Widget> _ticketContextMenuItems({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final locale = AppLocalizations.of(context)!;

    Future<bool> confirmSaveBeforeExport() async {
      if (ticketId != ref.read(appStateProvider).openTicket?.id) {
        return true;
      }
      bool confirmed = false;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(locale.uiConfirmSaveLabel),
          actions: [
            TextButton(
              onPressed: () {
                ShortcutController().dispatch(SaveEvent());
                Navigator.of(context).pop();
                confirmed = true;
              },
              child: Text(locale.uiConfirmSaveActionConfirm),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(locale.uiConfirmSaveActionCancel),
            ),
          ],
        ),
      );
      return confirmed;
    }

    void handleDelete() {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(locale.uiConfirmDeleteLabel),
          content: Text(locale.uiConfirmDeleteSubLabel),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                ref.read(ticketListProvider.notifier).delete(ticketId);
                Navigator.of(dialogContext).pop();
                if (ref.read(appStateProvider).openTicket?.id == ticketId) {
                  ref.read(appStateProvider.notifier).setIdle();
                }
              },
              child: Text(locale.uiConfirmDeleteActionConfirm),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              autofocus: true,
              child: Text(locale.uiConfirmDeleteActionCancel),
            ),
          ],
        ),
      );
    }

    void handleExport() async {
      if (ref.read(appStateProvider).modified) {
        if (!await confirmSaveBeforeExport()) {
          return;
        }
      }
      Ticket ticket = await DBController().getTicketById(ticketId);
      String id = ticket.id.toString().padLeft(4, "0");
      final pdfBytes = await ticketToPDF(ticket);
      FilePicker.saveFile(
        fileName: '${locale.ticketExportFileName(id)}.pdf',
        bytes: pdfBytes,
      );
    }

    void handlePrint() async {
      if (ref.read(appStateProvider).modified) {
        if (!await confirmSaveBeforeExport()) {
          return;
        }
      }
      Ticket ticket = await DBController().getTicketById(ticketId);
      final pdfBytes = await ticketToPDF(ticket);
      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
    }

    return [
      ExpressiveMenuItem(
        onPressed: handleExport,
        child: Text(locale.uiContextMenuExport),
      ),
      ExpressiveMenuItem(
        onPressed: handlePrint,
        child: Text(locale.uiContextMenuPrint),
      ),
      ExpressiveMenuItem(
        onPressed: handleDelete,
        child: Text(locale.uiContextMenuDelete),
      ),
    ];
  }

  Widget moreMenu() => ExpressiveMenu(
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
    menuChildren: _ticketContextMenuItems(context: context, ref: ref),
  );

  Widget contextMenu({required Widget child, GestureTapCallback? onTap}) {
    final MenuController menuController = MenuController();
    Offset? tapPosition;
    return ExpressiveMenu(
      controller: menuController,
      builder: (context, controller, widget) => GestureDetector(
        onTap: onTap,
        onSecondaryTapDown: (TapDownDetails details) {
          tapPosition = details.localPosition;
        },
        onSecondaryTapUp: (TapUpDetails details) {
          if (controller.isOpen) {
            controller.close();
          } else {
            // Open at the exact click position
            controller.open(position: tapPosition);
          }
        },
        child: child,
      ),
      menuChildren: _ticketContextMenuItems(context: context, ref: ref),
    );
  }
}
