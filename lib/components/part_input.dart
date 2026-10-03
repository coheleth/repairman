import 'package:flutter/material.dart';
import 'package:repairman/components/text_input.dart';
import 'package:repairman/messaging.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/models/part.dart';
import 'package:repairman/components/number_input.dart';

class PartEditor extends StatefulWidget {
  final int ticketId;
  final Part? part;
  const PartEditor({super.key, required this.ticketId, this.part});

  @override
  State<PartEditor> createState() => _PartEditorState();
}

class _PartEditorState extends State<PartEditor> {
  Part? part;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (widget.part != null) {
      part = widget.part!;
    } else {
      part = Part(
        id: -1,
        ticketId: widget.ticketId,
        name: "",
        quantity: 1,
        price: 0,
        ticked: false,
      );
    }
    return Dialog(
      constraints: BoxConstraints(maxWidth: 300),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: TextInput(
                  labelText: 'Material/Peça',
                  onSaved: (String? value) =>
                      part = part!.copyWith(name: value ?? ""),
                  required: true,
                  initialValue: part!.name,
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: NumberInput(
                      labelText: 'Qtd.',
                      initialValue: quantityAsString(part!.quantity) ?? "0",
                      comma: true,
                      regex: RegExp(r'^\d*\,?\d*'),
                      onSaved: (value) =>
                          part = part!.copyWith(quantity: value),
                    ),
                  ),
                  Expanded(
                    child: NumberInput(
                      labelText: 'Preço (R\$)',
                      initialValue: priceAsString(part!.price) ?? "0,00",
                      comma: true,
                      regex: RegExp(r'^\d*\,?\d{0,2}'),
                      onSaved: (value) => part = part!.copyWith(price: value),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.pop(context, part);
                        }
                      },
                      child: Text('Adicionar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PartInput extends StatefulWidget {
  final int ticketId;
  final List<Part> parts;
  final Function(List<Part> parts)? onModified;
  const PartInput({
    super.key,
    required this.ticketId,
    required this.parts,
    this.onModified,
  });

  @override
  State<PartInput> createState() => _PartInputState();
}

class _PartInputState extends State<PartInput> {
  List<Part> parts = [];
  final padding = EdgeInsets.symmetric(horizontal: 6);

  Part emptyPart() => Part(
    id: -1,
    ticketId: widget.ticketId,
    name: "",
    quantity: 0,
    price: 0,
    ticked: false,
  );

  @override
  void initState() {
    super.initState();
    parts = [...widget.parts];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Materiais'),
          Table(
            columnWidths: {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
              2: IntrinsicColumnWidth(),
              3: IntrinsicColumnWidth(),
              4: IntrinsicColumnWidth(),
              5: IntrinsicColumnWidth(),
            },
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Container(),
                  TableCell(
                    verticalAlignment:
                        TableCellVerticalAlignment.intrinsicHeight,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          'Item',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment:
                        TableCellVerticalAlignment.intrinsicHeight,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          'Preço',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment:
                        TableCellVerticalAlignment.intrinsicHeight,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          'Qtd.',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  Container(),
                  Container(),
                ],
              ),
              ...List<TableRow>.generate(
                parts.length,
                (index) => TableRow(
                  decoration: BoxDecoration(
                    color: index % 2 == 1
                        ? Theme.of(context).colorScheme.surfaceContainer
                        : null,
                  ),
                  children: [
                    Padding(
                      padding: padding,
                      child: Checkbox(
                        value: parts[index].ticked,
                        onChanged: (value) {
                          setState(() {
                            parts[index] = parts[index].copyWith(ticked: value);
                            widget.parts[index] = widget.parts[index].copyWith(
                              ticked: value,
                            );
                          });

                          widget.onModified?.call(parts);
                        },
                      ),
                    ),
                    Padding(padding: padding, child: Text(parts[index].name)),
                    Padding(
                      padding: padding,
                      child: Text(
                        'R\$${priceAsString(parts[index].price, comma: true)}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: padding,
                      child: Text(
                        '${parts[index].quantity}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Part? newPart = await showDialog(
                          context: context,
                          builder: (BuildContext context) => PartEditor(
                            ticketId: widget.ticketId,
                            part: parts[index],
                          ),
                        );
                        if (newPart != null) {
                          setState(() {
                            parts[index] = newPart;
                            widget.parts[index] = newPart;
                          });

                          widget.onModified?.call(parts);
                        }
                      },

                      icon: Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        Part targetPart = widget.parts.firstWhere(
                          (part) => Part.isEqual(part, parts[index]),
                          orElse: () => emptyPart(),
                        );
                        final int finalIndex = widget.parts.indexWhere(
                          (part) => Part.isEqual(part, targetPart),
                        );
                        widget.parts[finalIndex] = targetPart.copyWith(
                          markedForRemoval: true,
                        );
                        setState(() {
                          parts.removeAt(index);
                        });

                        widget.onModified?.call(parts);

                        MessagingController().sendSnackBar(
                          SnackBar(
                            content: Text(
                              'Material "${targetPart.name}" Removido',
                            ),
                            persist: false,
                            action: SnackBarAction(
                              label: 'Desfazer',
                              onPressed: () {
                                final finalPart = targetPart.copyWith(
                                  markedForRemoval: false,
                                );
                                widget.parts[finalIndex] = finalPart;
                                setState(() {
                                  parts.insert(index, finalPart);
                                });

                                widget.onModified?.call(parts);
                              },
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.delete_forever_outlined),
                    ),
                  ],
                ),
              ),
              TableRow(
                children: [
                  Container(height: 36),
                  Padding(padding: padding, child: const Text('Total')),
                  Padding(
                    padding: padding,
                    child: Text(
                      'R\$${priceAsString(totalPartsPrice(parts), comma: true) ?? "-"}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () async {
              final Part? newPart = await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    PartEditor(ticketId: widget.ticketId, part: emptyPart()),
              );
              if (newPart != null) {
                setState(() {
                  parts.add(newPart);
                  widget.parts.add(newPart);
                });

                widget.onModified?.call(parts);
              }
            },
            icon: Icon(Icons.add),
            label: Text('Adicionar Material'),
          ),
        ],
      ),
    );
  }
}
