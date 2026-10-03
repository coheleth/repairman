import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/messaging.dart';
import 'package:repairman/shortcuts.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/data/state/ticket_list.dart';
import 'package:repairman/data/models/part.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/components/confirm_close.dart';
import 'package:repairman/components/number_input.dart';
import 'package:repairman/components/ticket_context_menu.dart';
import 'package:repairman/components/date_picker.dart';
import 'package:repairman/components/text_input.dart';
import 'package:repairman/components/part_input.dart';
import 'package:repairman/components/status_dropdown.dart';

// class TicketEdit extends ConsumerWidget {
//   final GlobalKey<NavigatorState> navigatorKey;
//   const TicketEdit({super.key, required this.navigatorKey});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isCreating = ref.watch(appStateProvider).isCreating;
//     final initialTicket =
//         ref.watch(appStateProvider).openTicket ??
//         Ticket(id: -1, service: '', statusId: 0);

//     return TicketForm(
//       navigatorKey: navigatorKey,
//       initialTicket: initialTicket,
//       isCreating: isCreating,
//       onChanged: () {
//         ref.read(appStateProvider.notifier).setModified();
//       },
//       onClose: () async {
//         if (!await confirmClose(context, ref)) {
//           return;
//         }

//         if (context.mounted) {
//           ref.read(appStateProvider.notifier).setIdle();
//           if (ref.read(appStateProvider).openTicket != null) {
//             Navigator.of(context).pop();
//           } else {
//             Navigator.of(context).popUntil((route) => route.isFirst);
//           }
//         }
//       },
//       onSave: (ticket) async {
//         int id = ticket.id;

//         if (isCreating) {
//           id = await ref.read(ticketListProvider.notifier).create(ticket);
//         } else {
//           ref.read(ticketListProvider.notifier).update(ticket);
//         }

//         List<Part> parts = [];
//         for (Part originalPart in ticket.parts ?? []) {
//           final part = originalPart.copyWith(ticketId: id);
//           if (part.markedForRemoval && part.id > 0) {
//             DBController().deletePartById(part.id);
//           } else if (part.id > 0) {
//             DBController().updatePart(part);
//             parts.add(part);
//           } else {
//             final id = await DBController().createPart(part);
//             parts.add(part.copyWith(id: id));
//           }
//         }

//         Ticket finalTicket = ticket.copyWith(id: id, parts: parts);
//         ref.read(appStateProvider.notifier).setEditing(finalTicket);
//         ref.read(appStateProvider.notifier).setModified(modified: false);

//         return parts;
//       },
//     );
//   }
// }

class TicketEdit extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const TicketEdit({super.key, required this.navigatorKey});

  @override
  ConsumerState<TicketEdit> createState() => _TicketEditState();
}

class _TicketEditState extends ConsumerState<TicketEdit> {
  Ticket initialTicket = Ticket.empty();

  String service = '';
  int statusId = 1;
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

  void _handleSave(BuildContext context) async {
    if (canSave) {
      canSave = false;
      _formKey.currentState!.save();

      if (_formKey.currentState!.validate()) {
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
          statusName: await DBController().getStatusName(statusId),
          parts: parts,
        );

        // final newParts = await widget.onSave?.call(finalTicket);
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
        ref.read(appStateProvider.notifier).setEditing(finalTicket);
        ref.read(appStateProvider.notifier).setModified(modified: false);

        setState(() {
          parts = newParts;
          modified = false;
        });
        MessagingController().sendSnackBar(
          SnackBar(content: const Text('Alterações Salvas')),
        );
      } else {
        canSave = true;
      }
    }
  }

  void _handleChanged() {
    if (!modified) {
      setState(() {
        canSave = true;
        modified = true;
      });
      ref.read(appStateProvider.notifier).setModified();
    }
  }

  void _handleClose() async {
    if (context.mounted) {
      if (!await confirmClose(context, ref)) {
        return;
      }
      final navigator = Navigator.of(context);
      ref.read(appStateProvider.notifier).setIdle();
      if (ref.read(appStateProvider).openTicket != null) {
        navigator.pop();
      } else {
        navigator.popUntil((route) => route.isFirst);
      }
    }
  }

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
    ShortcutController().on<SaveEvent>().listen((eventContext) {
      if (context.mounted) {
        _handleSave(context);
      }
    });

    return Focus(
      autofocus: true,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _handleClose),
          title: Text(service.isNotEmpty ? service : 'Ordem de Serviço'),
          actions: [
            if (modified)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: FilledButton.icon(
                  onPressed: () {
                    if (context.mounted) {
                      _handleSave(context);
                    }
                  },
                  label: Text('Salvar'),
                  icon: Icon(Icons.save),
                ),
              ),
            if (!modified && !isCreating)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: TicketContextMenu(
                  ticketId: initialTicket.id,
                  navigatorKey: widget.navigatorKey,
                ),
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
                      onChanged: _handleChanged,
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
                                  labelText: 'Data de Entrada',
                                  initialDate: startDate,
                                  onChanged: (DateTime? value) {
                                    startDate = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: DatePicker(
                                  labelText: 'Prometido Para',
                                  initialDate: deliveryDate,
                                  onChanged: (DateTime? value) {
                                    deliveryDate = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: StatusDropdown(
                                  labelText: 'Status',
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
                                  labelText: 'Cliente',
                                  initialValue: clientName,
                                  onSaved: (String? value) {
                                    clientName = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: 'CPF/CNPJ',
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
                                  labelText: 'Endereço',
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
                                  labelText: 'Contato',
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
                                  labelText: 'Local',
                                  initialValue: location,
                                  onSaved: (String? value) {
                                    location = value;
                                  },
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: 'Objeto/Equipamento',
                                  initialValue: repairTarget,
                                  onSaved: (String? value) {
                                    repairTarget = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextInput(
                            labelText: 'Briefing/Condições de Entrada',
                            initialValue: repairCondition,
                            maxLines: 4,
                            onSaved: (String? value) {
                              repairCondition = value;
                            },
                          ),
                          TextInput(
                            labelText: 'Diagnóstico',
                            initialValue: repairDiagnosis,
                            maxLines: 4,
                            onSaved: (String? value) {
                              repairDiagnosis = value;
                            },
                          ),
                          TextInput(
                            labelText: 'Obs.',
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
                                  labelText: 'Serviço',
                                  initialValue: service,
                                  onChanged: (String value) {
                                    setState(() {
                                      service = value;
                                    });
                                  },
                                  required: true,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: NumberInput(
                                  labelText: 'Mão de Obra (R\$)',
                                  initialValue: priceAsString(
                                    servicePrice,
                                    comma: true,
                                  ),
                                  comma: true,
                                  regex: RegExp(r'^\d*\,?\d{0,2}'),
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
                              _handleChanged();
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
                                        'Valor Total',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        'R\$${priceAsString((servicePrice ?? 0) + partsPrice, comma: true)}',
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
