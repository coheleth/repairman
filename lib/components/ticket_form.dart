import 'dart:math';

import 'package:flutter/material.dart';
import 'package:repairman/components/number_input.dart';
import 'package:repairman/components/ticket_context_menu.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/data/models/part.dart';
import 'package:repairman/components/date_picker.dart';
import 'package:repairman/components/text_input.dart';
import 'package:repairman/components/part_input.dart';
import 'package:repairman/components/status_dropdown.dart';
import 'package:repairman/messaging.dart';
import 'package:repairman/shortcuts.dart';
import 'package:repairman/utils.dart';

class SaveIntent extends Intent {
  const SaveIntent();
}

class TicketForm extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Ticket initialTicket;
  final bool isCreating;
  final Function()? onClose;
  final Future<List<Part>> Function(Ticket ticket)? onSave;
  final Function? onChanged;
  const TicketForm({
    super.key,
    required this.navigatorKey,
    required this.initialTicket,
    this.isCreating = true,
    this.onClose,
    this.onSave,
    this.onChanged,
  });

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
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

  final _formKey = GlobalKey<FormState>();

  void _handleSave(BuildContext context) async {
    if (canSave) {
      canSave = false;
      _formKey.currentState!.save();

      if (_formKey.currentState!.validate()) {
        Ticket finalTicket = Ticket(
          id: widget.initialTicket.id,
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
          parts: parts,
        );

        final newParts = await widget.onSave?.call(finalTicket);

        setState(() {
          parts = newParts ?? parts;
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
      widget.onChanged?.call();
    }
  }

  @override
  void initState() {
    super.initState();
    parts = widget.initialTicket.parts ?? [];
    statusId = widget.initialTicket.statusId;
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          forceMaterialTransparency: true,
          leading: BackButton(
            onPressed: () async {
              if (widget.onClose != null) {
                widget.onClose!();
              }
            },
          ),
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
            if (!modified && !widget.isCreating)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: TicketContextMenu(
                  ticketId: widget.initialTicket.id,
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
            return Center(
              heightFactor: 1.0,
              child: SizedBox(
                width: isSmallWidth
                    ? min(minWidth, constraints.maxWidth)
                    : min(maxWidth, constraints.maxWidth),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 56),
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
                                  initialDate: widget.initialTicket.startDate,
                                  onChanged: (DateTime? value) {
                                    startDate = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: DatePicker(
                                  labelText: 'Prometido Para',
                                  initialDate:
                                      widget.initialTicket.deliveryDate,
                                  onChanged: (DateTime? value) {
                                    deliveryDate = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: StatusDropdown(
                                  labelText: 'Status',
                                  initialValue: widget.initialTicket.statusId,
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
                                  initialValue: widget.initialTicket.clientName,
                                  onSaved: (String value) {
                                    clientName = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: 'CPF/CNPJ',
                                  initialValue:
                                      widget.initialTicket.clientDocument,
                                  onSaved: (String value) {
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
                                  initialValue:
                                      widget.initialTicket.clientAddress,
                                  maxLines: 3,
                                  onSaved: (String value) {
                                    clientAddress = value;
                                  },
                                ),
                              ),

                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: 'Contato',
                                  initialValue:
                                      widget.initialTicket.clientContact,
                                  maxLines: 3,
                                  onSaved: (String value) {
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
                                  initialValue: widget.initialTicket.location,
                                  onSaved: (String value) {
                                    location = value;
                                  },
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: 'Objeto/Equipamento',
                                  initialValue:
                                      widget.initialTicket.repairTarget,
                                  onSaved: (String value) {
                                    repairTarget = value;
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
                                  labelText: 'Briefing/Condições de Entrada',
                                  initialValue:
                                      widget.initialTicket.repairCondition,
                                  maxLines: 4,
                                  onSaved: (String value) {
                                    repairCondition = value;
                                  },
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: 'Diagnóstico',
                                  initialValue:
                                      widget.initialTicket.repairDiagnosis,
                                  maxLines: 4,
                                  onSaved: (String value) {
                                    repairDiagnosis = value;
                                  },
                                ),
                              ),
                            ],
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
                                  initialValue: widget.initialTicket.service,
                                  onSaved: (String value) {
                                    service = value;
                                  },
                                  required: true,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: NumberInput(
                                  labelText: 'Mão de Obra (R\$)',
                                  initialValue: priceAsString(
                                    widget.initialTicket.servicePrice,
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

                          Flex(
                            direction: direction,
                            mainAxisSize: MainAxisSize.min,

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                fit: isSmallWidth
                                    ? FlexFit.loose
                                    : FlexFit.tight,
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: PartInput(
                                    ticketId: widget.initialTicket.id,
                                    parts: parts,
                                    onModified: (parts) {
                                      setState(() {
                                        partsPrice = totalPartsPrice(parts);
                                      });
                                      _handleChanged();
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: TextInput(
                                  labelText: 'Obs.',
                                  maxLines: 4,
                                  initialValue: widget.initialTicket.obs,
                                  onSaved: (String value) {
                                    obs = value;
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
