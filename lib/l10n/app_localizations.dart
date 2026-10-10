import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// Label for create work order button.
  ///
  /// In en, this message translates to:
  /// **'Create Work Order'**
  String get uiCreateTicket;

  /// Label for work order search bar.
  ///
  /// In en, this message translates to:
  /// **'Search Work Order'**
  String get uiSearch;

  /// Context menu entry
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get uiContextMenuPrint;

  /// Context menu entry
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get uiContextMenuExport;

  /// Context menu entry
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get uiContextMenuDelete;

  /// Main label for dialogue shown when closing a work order with unsaved changes.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes to Work Order?'**
  String get uiConfirmDiscardLabel;

  /// No description provided for @uiConfirmDiscardActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Discard'**
  String get uiConfirmDiscardActionConfirm;

  /// No description provided for @uiConfirmDiscardActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get uiConfirmDiscardActionCancel;

  /// Main label for work order deletion dialogue.
  ///
  /// In en, this message translates to:
  /// **'Delete Work Order?'**
  String get uiConfirmDeleteLabel;

  /// Secondary text for work order deletion dialogue.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get uiConfirmDeleteSubLabel;

  /// No description provided for @uiConfirmDeleteActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get uiConfirmDeleteActionConfirm;

  /// No description provided for @uiConfirmDeleteActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get uiConfirmDeleteActionCancel;

  /// Label for confirm dialogue shown when trying to export an unsaved work order.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes.\nYou must save them before proceeding. \nSave now?'**
  String get uiConfirmSaveLabel;

  /// No description provided for @uiConfirmSaveActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save and Continue'**
  String get uiConfirmSaveActionConfirm;

  /// No description provided for @uiConfirmSaveActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get uiConfirmSaveActionCancel;

  /// Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Project not started status.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get statusNotStarted;

  /// Awaiting materials status.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Materials'**
  String get statusAwaitingMaterials;

  /// Project is ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get statusOngoing;

  /// Project finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get statusFinished;

  /// Project delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// Show all work orders.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get statusShowAll;

  /// Work order.
  ///
  /// In en, this message translates to:
  /// **'Work Order'**
  String get ticket;

  /// Work orders (plural).
  ///
  /// In en, this message translates to:
  /// **'Work Orders'**
  String get tickets;

  /// Date of job acceptance
  ///
  /// In en, this message translates to:
  /// **'Entry Date'**
  String get ticketStartDate;

  /// Date of job delivery
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get ticketDeliveryDate;

  /// Name of the work order's client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get ticketClientName;

  /// Work order's client's id document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get ticketClientDocument;

  /// Address of the work order's client.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get ticketClientAddress;

  /// Contact info for the work order's client.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get ticketClientContact;

  /// Work order job location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get ticketLocation;

  /// Work order's item to be repaired.
  ///
  /// In en, this message translates to:
  /// **'Object/Equipment'**
  String get ticketRepairTarget;

  /// Work order's item's conditions at admittance.
  ///
  /// In en, this message translates to:
  /// **'Briefing/Item Conditions'**
  String get ticketRepairCondition;

  /// Work order's item's diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get ticketRepairDiagnosis;

  /// Observations for work order.
  ///
  /// In en, this message translates to:
  /// **'Obs.'**
  String get ticketObs;

  /// Work order's service to be conducted.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get ticketService;

  /// Work order's service price.
  ///
  /// In en, this message translates to:
  /// **'Service Price'**
  String get ticketServicePrice;

  /// Label for a work order's total price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get ticketTotal;

  /// Label for the snack bar shown when a work order is saved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved.'**
  String get ticketSaved;

  /// Default exported pdf file name.
  ///
  /// In en, this message translates to:
  /// **'work_order_{id}'**
  String ticketExportFileName(String id);

  /// Material/Part.
  ///
  /// In en, this message translates to:
  /// **'Material/Part'**
  String get part;

  /// Materials/Parts (plural).
  ///
  /// In en, this message translates to:
  /// **'Materials/Parts'**
  String get parts;

  /// Quantity of a material/part.
  ///
  /// In en, this message translates to:
  /// **'Qt.'**
  String get partQuantity;

  /// Label for the price of a material/part.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get partPrice;

  /// Label for add part button
  ///
  /// In en, this message translates to:
  /// **'Add Part'**
  String get partAdd;

  /// Label for cancel part addition button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get partAddCancel;

  /// Label for total materials/parts price.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get partTotal;

  /// Text for part removed snackbar.
  ///
  /// In en, this message translates to:
  /// **'Material {partName} Removed'**
  String partRemoved(String partName);

  /// Label for part removal snack bar's undo button.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get partRemovedUndo;

  /// Label for work order sort menu. Generic ascending sort.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sortAscending;

  /// Label for work order sort menu. Generic descending sort.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get sortDescending;

  /// Label for work order sort menu. Ascending sort for text values.
  ///
  /// In en, this message translates to:
  /// **'A to Z'**
  String get sortAscendingText;

  /// Label for work order sort menu. Descending sort for text values.
  ///
  /// In en, this message translates to:
  /// **'Z to A'**
  String get sortDescendingText;

  /// Label for work order sort menu. Descending sort for present/future date values.
  ///
  /// In en, this message translates to:
  /// **'Earlier to Later'**
  String get sortAscendingDate;

  /// Label for work order sort menu. Descending sort for present/future date values.
  ///
  /// In en, this message translates to:
  /// **'Later to Earlier'**
  String get sortDescendingDate;

  /// Label for work order sort menu. Descending sort for past date values.
  ///
  /// In en, this message translates to:
  /// **'Older to Newer'**
  String get sortAscendingDatePast;

  /// Label for work order sort menu. Descending sort for past date values.
  ///
  /// In en, this message translates to:
  /// **'Newer to Older'**
  String get sortDescendingDatePast;

  /// Settings menu title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for language selector.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Label for currency selector.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// Default value for language selector.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsLanguageDefault;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
