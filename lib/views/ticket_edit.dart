import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/data/state/settings_state.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/messaging.dart';
import 'package:repairman/shortcuts.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/data/state/ticket_list.dart';
import 'package:repairman/data/models/status.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/data/models/part.dart';
import 'package:repairman/components/confirm_close.dart';
import 'package:repairman/components/number_input.dart';
import 'package:repairman/components/ticket_context_menu.dart';
import 'package:repairman/components/date_picker.dart';
import 'package:repairman/components/text_input.dart';
import 'package:repairman/components/part_input.dart';
import 'package:repairman/components/status_dropdown.dart';

class TicketEdit extends ConsumerStatefulWidget {
  const TicketEdit({super.key});

  @override
  ConsumerState<TicketEdit> createState() => _TicketEditState();
}

class _TicketEditState extends ConsumerState<TicketEdit> {
  Ticket initialTicket = Ticket.empty();

  int statusId = 1;
  String? service = '';
  double? servicePrice;
  DateTime? startDate;
  DateTime? deliveryDate;
  String? clientName;
  String? clientDocument;
  String? clientAddress;
  String? clientContact;
  String? location;
  String? repairTarget;
  String? repairCondition;
  String? repairDiagnosis;
  String? obs;

  double partsPrice = 0;
  List<Part> parts = [];

  bool modified = false;
  bool canSave = true;
  bool isCreating = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    isCreating = ref.watch(appStateProvider).isCreating;
    initialTicket =
        ref.watch(appStateProvider).openTicket ??
        Ticket(id: -1, service: '', statusId: 0);

    statusId = initialTicket.statusId;
    startDate = initialTicket.startDate;
    deliveryDate = initialTicket.deliveryDate;
    clientName = initialTicket.clientName;
    clientDocument = initialTicket.clientDocument;
    clientAddress = initialTicket.clientAddress;
    clientContact = initialTicket.clientContact;
    location = initialTicket.location;
    repairTarget = initialTicket.repairTarget;
    repairCondition = initialTicket.repairCondition;
    repairDiagnosis = initialTicket.repairDiagnosis;
    service = initialTicket.service;
    servicePrice = initialTicket.servicePrice;
    parts = initialTicket.parts ?? [];
    obs = initialTicket.obs;

    partsPrice = totalPartsPrice(parts);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final navigatorState = Navigator.of(context);
    final usesComma = localeUsesComma(Localizations.localeOf(context));

    void handleSave() async {
      if (canSave) {
        canSave = false;
        _formKey.currentState!.save();

        if (_formKey.currentState!.validate()) {
          final status = await DBController().getStatusById(statusId);

          Ticket ticket = Ticket(
            id: initialTicket.id,
            service: service,
            servicePrice: servicePrice,
            statusId: statusId,
            startDate: startDate,
            deliveryDate: deliveryDate,
            clientName: clientName,
            clientDocument: clientDocument,
            clientAddress: clientAddress,
            clientContact: clientContact,
            repairTarget: repairTarget,
            repairCondition: repairCondition,
            repairDiagnosis: repairDiagnosis,
            statusName: status?.name ?? '',
            done: status?.done ?? Done.inProgress,
            parts: parts,
          );

          int id = ticket.id;

          if (isCreating) {
            id = await ref.read(ticketListProvider.notifier).create(ticket);
          } else {
            ref.read(ticketListProvider.notifier).update(ticket);
          }

          List<Part> newParts = [];
          for (Part originalPart in ticket.parts ?? []) {
            final part = originalPart.copyWith(ticketId: id);
            if (part.markedForRemoval && part.id > 0) {
              DBController().deletePartById(part.id);
            } else if (part.id > 0) {
              DBController().updatePart(part);
              newParts.add(part);
            } else {
              final id = await DBController().createPart(part);
              newParts.add(part.copyWith(id: id));
            }
          }

          Ticket finalTicket = ticket.copyWith(id: id, parts: newParts);

          Ticket resultTicket = await DBController().getTicketById(id);

          setState(() {
            parts = newParts;
            modified = false;
            isCreating = false;
            initialTicket = resultTicket;
          });
          MessagingController().sendSnackBar(
            SnackBar(content: Text(locale.ticketSaved)),
          );

          ref.read(appStateProvider.notifier).setEditing(finalTicket);
          ref.read(appStateProvider.notifier).setModified(modified: false);
        } else {
          canSave = true;
        }
      }
    }

    void handleChanged() {
      if (!modified) {
        setState(() {
          canSave = true;
          modified = true;
        });
        ref.read(appStateProvider.notifier).setModified();
      }
    }

    void handleClose() async {
      if (context.mounted) {
        if (!await confirmClose(context, ref)) {
          return;
        }
        ref.read(appStateProvider.notifier).setIdle();
        if (ref.read(appStateProvider).openTicket != null) {
          navigatorState.pop();
        } else {
          navigatorState.popUntil((route) => route.isFirst);
        }
      }
    }

    ShortcutController().on<SaveEvent>().listen((eventContext) {
      handleSave();
    });

    return Focus(
      autofocus: true,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: handleClose),
          title: Text(
            initialTicket.id > 0
                ? ticketIdAsString(initialTicket.id)
                : 'Nova OS',
          ),
          actions: [
            if (modified)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: FilledButton.icon(
                  onPressed: handleSave,
                  label: Text('Salvar'),
                  icon: Icon(Icons.save),
                ),
              ),
            if (!modified && !isCreating)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),

                child: TicketMenu(
                  context: context,
                  ref: ref,
                  ticketId: initialTicket.id,
                  // navigatorKey: widget.navigatorKey,
                ).moreMenu(),
              ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double minWidth = 500;
            final double maxWidth = 800;
            final bool isSmallWidth = constraints.maxWidth < maxWidth;
            final Axis direction = isSmallWidth
                ? Axis.vertical
                : Axis.horizontal;
            return SingleChildScrollView(
              child: Center(
                heightFactor: 1.0,
                child: SizedBox(
                  width: isSmallWidth
                      ? min(minWidth, constraints.maxWidth)
                      : min(maxWidth, constraints.maxWidth),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 56),
                    child: Form(
                      onChanged: handleChanged,
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flex(
                            direction: direction,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: DatePicker(
                                  labelText: locale.ticketStartDate,
                                  initialDate: startDate,
                                  onChanged: (DateTime? value) {
                                    startDate = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: DatePicker(
                                  labelText: locale.ticketDeliveryDate,
                                  initialDate: deliveryDate,
                                  onChanged: (DateTime? value) {
                                    deliveryDate = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: StatusDropdown(
                                  labelText: locale.status,
                                  initialValue: statusId,
                                  onChanged: (int value) {
                                    statusId = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Flex(
                            direction: direction,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: locale.ticketClientName,
                                  initialValue: clientName,
                                  onSaved: (String? value) {
                                    clientName = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: locale.ticketClientDocument,
                                  initialValue: clientDocument,
                                  onSaved: (String? value) {
                                    clientDocument = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Flex(
                            direction: direction,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: locale.ticketClientAddress,
                                  initialValue: clientAddress,
                                  maxLines: 3,
                                  onSaved: (String? value) {
                                    clientAddress = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: locale.ticketClientContact,
                                  initialValue: clientContact,
                                  maxLines: 3,
                                  onSaved: (String? value) {
                                    clientContact = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Flex(
                            direction: direction,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: locale.ticketLocation,
                                  initialValue: location,
                                  onSaved: (String? value) {
                                    location = value;
                                  },
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: locale.ticketRepairTarget,
                                  initialValue: repairTarget,
                                  onSaved: (String? value) {
                                    repairTarget = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextInput(
                            labelText: locale.ticketRepairCondition,
                            initialValue: repairCondition,
                            maxLines: 4,
                            onSaved: (String? value) {
                              repairCondition = value;
                            },
                          ),
                          TextInput(
                            labelText: locale.ticketRepairDiagnosis,
                            initialValue: repairDiagnosis,
                            maxLines: 4,
                            onSaved: (String? value) {
                              repairDiagnosis = value;
                            },
                          ),
                          TextInput(
                            labelText: locale.ticketObs,
                            maxLines: 4,
                            initialValue: obs,
                            onSaved: (String? value) {
                              obs = value;
                            },
                          ),

                          Flex(
                            direction: direction,
                            mainAxisSize: MainAxisSize.min,

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: locale.ticketService,
                                  initialValue: service,
                                  onChanged: (String value) {
                                    setState(() {
                                      service = value;
                                    });
                                  },
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: NumberInput(
                                  labelText:
                                      "${locale.ticketServicePrice} (${ref.read(settingsStateProvider).currencyString(null)})",
                                  initialValue: priceAsString(
                                    servicePrice,
                                    comma: usesComma,
                                  ),
                                  comma: localeUsesComma(
                                    Localizations.localeOf(context),
                                  ),
                                  regex: usesComma
                                      ? RegExp(r'^\d*\,?\d{0,2}')
                                      : RegExp(r'^\d*\.?\d{0,2}'),
                                  onChanged: (value) {
                                    setState(() {
                                      servicePrice = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          PartInput(
                            key: ValueKey(parts),
                            ticketId: initialTicket.id,
                            parts: parts,
                            onModified: (parts) {
                              setState(() {
                                partsPrice = totalPartsPrice(parts);
                              });
                              handleChanged();
                            },
                          ),
                          Flex(
                            direction: direction,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        locale.ticketTotal,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        ref
                                            .read(settingsStateProvider)
                                            .currencyString(
                                              priceAsString(
                                                (servicePrice ?? 0) +
                                                    partsPrice,
                                                comma: usesComma,
                                              ),
                                            ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
