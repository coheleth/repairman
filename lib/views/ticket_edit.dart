import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/components/priority_rating_input.dart';
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
  int? priority;

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
    priority = initialTicket.priority;

    partsPrice = totalPartsPrice(parts);
  }

  @override
  Widget build(BuildContext context) {
    final navigatorState = Navigator.of(context);
    final localisation = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final currency = ref.read(settingsStateProvider).currency;
    final usesComma = localeUsesComma(locale);

    void handleSave() async {
      if (canSave) {
        canSave = false;
        _formKey.currentState!.save();

        if (_formKey.currentState!.validate()) {
          final status = await DBController().getStatusById(statusId);

          Ticket ticket = Ticket(
            id: initialTicket.id,
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
            obs: obs,
            service: service,
            servicePrice: servicePrice,
            priority: priority,
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
            SnackBar(content: Text(localisation.ticketSaved)),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: StatusDropdown(
                                  labelText: localisation.status,
                                  initialValue: statusId,
                                  onChanged: (int value) {
                                    statusId = value;
                                  },
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: PriorityRatingInput(
                                  label: localisation.ticketPriority,
                                  rating: priority,
                                  onChanged: (value) {
                                    setState(() {
                                      priority = value;
                                      modified = true;
                                    });
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
                                child: DatePicker(
                                  labelText: localisation.ticketStartDate,
                                  initialDate: startDate,
                                  onChanged: (DateTime? value) {
                                    startDate = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: DatePicker(
                                  labelText: localisation.ticketDeliveryDate,
                                  initialDate: deliveryDate,
                                  onChanged: (DateTime? value) {
                                    deliveryDate = value;
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
                                  labelText: localisation.ticketClientName,
                                  initialValue: clientName,
                                  onSaved: (String? value) {
                                    clientName = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: localisation.ticketClientDocument,
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
                                  labelText: localisation.ticketClientAddress,
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
                                  labelText: localisation.ticketClientContact,
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
                                  labelText: localisation.ticketLocation,
                                  initialValue: location,
                                  onSaved: (String? value) {
                                    location = value;
                                  },
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: localisation.ticketRepairTarget,
                                  initialValue: repairTarget,
                                  onSaved: (String? value) {
                                    repairTarget = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextInput(
                            labelText: localisation.ticketRepairCondition,
                            initialValue: repairCondition,
                            maxLines: 4,
                            onSaved: (String? value) {
                              repairCondition = value;
                            },
                          ),
                          TextInput(
                            labelText: localisation.ticketRepairDiagnosis,
                            initialValue: repairDiagnosis,
                            maxLines: 4,
                            onSaved: (String? value) {
                              repairDiagnosis = value;
                            },
                          ),
                          TextInput(
                            labelText: localisation.ticketObs,
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
                                  labelText: localisation.ticketService,
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
                                      "${localisation.ticketServicePrice} (${ref.read(settingsStateProvider).currencyString(null)})",
                                  initialValue: priceAsString(
                                    servicePrice ?? 0,
                                    currency,
                                    locale,
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
                                        localisation.ticketTotal,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        priceAsString(
                                          (servicePrice ?? 0) + partsPrice,
                                          currency,
                                          locale,
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
