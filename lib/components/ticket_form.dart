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
  final Function(Ticket ticket)? onSave;
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
  String? repairTarget;
  String? repairCondition;
  String? repairDiagnosis;
  List<Part> parts = [];

  bool modified = false;

  final _formKey = GlobalKey<FormState>();

  void _handleSave() async {
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
      if (widget.onSave != null) {
        widget.onSave!(finalTicket);
      }
      setState(() {
        modified = false;
      });
    }
  }

  void _handleChanged() {
    if (!modified && widget.onChanged != null) {
      setState(() {
        modified = true;
      });
      widget.onChanged!();
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
    ShortcutController().on<SaveEvent>().listen((context) => _handleSave());
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
                  onPressed: _handleSave,
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
            return Center(
              heightFactor: 1.0,
              child: SizedBox(
                width: min(800, constraints.maxWidth),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(top: 56),
                    child: Form(
                      onChanged: _handleChanged,
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flex(
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextInput(
                                  labelText: 'Cliente',
                                  initialValue: widget.initialTicket.clientName,
                                  onSaved: (String value) {
                                    clientName = value;
                                  },
                                ),
                              ),
                              Expanded(
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
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
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
                              Expanded(
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
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: DatePicker(
                                  labelText: 'Data de Entrada',
                                  initialDate: widget.initialTicket.startDate,
                                  onChanged: (DateTime? value) {
                                    startDate = value;
                                  },
                                ),
                              ),
                              Expanded(
                                child: DatePicker(
                                  labelText: 'Prometido Para',
                                  initialDate:
                                      widget.initialTicket.deliveryDate,
                                  onChanged: (DateTime? value) {
                                    deliveryDate = value;
                                  },
                                ),
                              ),
                              Expanded(
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
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextInput(
                                  labelText: 'Aparelho/Equipamento',
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
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextInput(
                                  labelText: 'Condições de Entrada',
                                  initialValue:
                                      widget.initialTicket.repairCondition,
                                  maxLines: 4,
                                  onSaved: (String value) {
                                    repairCondition = value;
                                  },
                                ),
                              ),
                              Expanded(
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
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextInput(
                                      labelText: 'Serviço',
                                      initialValue:
                                          widget.initialTicket.service,
                                      onSaved: (String value) {
                                        service = value;
                                      },
                                      required: true,
                                    ),
                                    NumberInput(
                                      labelText: 'Mão de Obra (R\$)',
                                      initialValue: priceAsString(
                                        widget.initialTicket.servicePrice,
                                      ),
                                      comma: true,
                                      regex: RegExp(r'^\d*\,?\d{0,2}'),
                                      onSaved: (value) {
                                        servicePrice = value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: PartInput(
                                    ticketId: widget.initialTicket.id,
                                    parts: parts,
                                    onModified: _handleChanged,
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
