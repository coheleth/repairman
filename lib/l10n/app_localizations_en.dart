// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get uiCreateTicket => 'Create Work Order';

  @override
  String get uiSearch => 'Search Work Order';

  @override
  String get uiContextMenuPrint => 'Print';

  @override
  String get uiContextMenuExport => 'Export PDF';

  @override
  String get uiContextMenuDelete => 'Delete';

  @override
  String get uiConfirmDiscardLabel => 'Discard Changes to Work Order?';

  @override
  String get uiConfirmDiscardActionConfirm => 'Yes, Discard';

  @override
  String get uiConfirmDiscardActionCancel => 'Cancel';

  @override
  String get uiConfirmDeleteLabel => 'Delete Work Order?';

  @override
  String get uiConfirmDeleteSubLabel => 'This cannot be undone.';

  @override
  String get uiConfirmDeleteActionConfirm => 'Yes, Delete';

  @override
  String get uiConfirmDeleteActionCancel => 'Cancel';

  @override
  String get uiConfirmSaveLabel =>
      'You have unsaved changes.\nYou must save them before proceeding. \nSave now?';

  @override
  String get uiConfirmSaveActionConfirm => 'Save and Continue';

  @override
  String get uiConfirmSaveActionCancel => 'Cancel';

  @override
  String get status => 'Status';

  @override
  String get statusNotStarted => 'Not Started';

  @override
  String get statusAwaitingMaterials => 'Awaiting Materials';

  @override
  String get statusOngoing => 'Ongoing';

  @override
  String get statusFinished => 'Finished';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusShowAll => 'All';

  @override
  String get ticket => 'Work Order';

  @override
  String get tickets => 'Work Orders';

  @override
  String get ticketStartDate => 'Entry Date';

  @override
  String get ticketDeliveryDate => 'Delivery Date';

  @override
  String get ticketClientName => 'Client';

  @override
  String get ticketClientDocument => 'Document';

  @override
  String get ticketClientAddress => 'Address';

  @override
  String get ticketClientContact => 'Contact';

  @override
  String get ticketLocation => 'Location';

  @override
  String get ticketRepairTarget => 'Object/Equipment';

  @override
  String get ticketRepairCondition => 'Briefing/Item Conditions';

  @override
  String get ticketRepairDiagnosis => 'Diagnosis';

  @override
  String get ticketObs => 'Obs.';

  @override
  String get ticketService => 'Service';

  @override
  String get ticketServicePrice => 'Service Price';

  @override
  String get ticketPriority => 'Priority';

  @override
  String get ticketTotal => 'Total Price';

  @override
  String get ticketSaved => 'Changes saved.';

  @override
  String ticketExportFileName(String id) {
    return 'work_order_$id';
  }

  @override
  String get part => 'Material/Part';

  @override
  String get parts => 'Materials/Parts';

  @override
  String get partQuantity => 'Qt.';

  @override
  String get partPrice => 'Price';

  @override
  String get partAdd => 'Add Part';

  @override
  String get partAddCancel => 'Cancel';

  @override
  String get partTotal => 'Total';

  @override
  String partRemoved(String partName) {
    return 'Material $partName Removed';
  }

  @override
  String get partRemovedUndo => 'Undo';

  @override
  String get sortAscending => 'Ascending';

  @override
  String get sortDescending => 'Descending';

  @override
  String get sortAscendingText => 'A to Z';

  @override
  String get sortDescendingText => 'Z to A';

  @override
  String get sortAscendingDate => 'Earlier to Later';

  @override
  String get sortDescendingDate => 'Later to Earlier';

  @override
  String get sortAscendingDatePast => 'Older to Newer';

  @override
  String get sortDescendingDatePast => 'Newer to Older';

  @override
  String get settings => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsLanguageDefault => 'System Default';
}
