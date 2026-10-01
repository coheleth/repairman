import 'package:flutter/material.dart';
import 'package:repairman/components/number_input.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/models/part.dart';

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
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Material/Peça',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: part!.name,
                  onSaved: (String? value) =>
                      part = part!.copyWith(name: value ?? ""),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
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
  const PartInput({super.key, required this.ticketId, required this.parts});

  @override
  State<PartInput> createState() => _PartInputState();
}

class _PartInputState extends State<PartInput> {
  List<Part> parts = [];

  @override
  void initState() {
    super.initState();
    parts = [...widget.parts];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Materiais/Peças'),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: parts.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(parts[index].name),
              subtitle: Text(
                'R\$${priceAsString(parts[index].price, comma: true)}\nx${parts[index].quantity}',
              ),
              trailing: IconButton(
                onPressed: () {
                  Part targetPart = widget.parts.firstWhere(
                    (part) => part == parts[index],
                    orElse: () => Part(
                      id: -1,
                      ticketId: -1,
                      name: '',
                      quantity: 0,
                      price: 0,
                    ),
                  );
                  widget.parts[widget.parts.indexWhere(
                    (part) => part == targetPart,
                  )] = targetPart.copyWith(
                    markedForRemoval: true,
                  );
                  setState(() {
                    parts.removeAt(index);
                    // parts[index] = parts[index].copyWith(
                    //   markedForRemoval: true,
                    // );
                  });
                },
                icon: Icon(Icons.remove_outlined),
              ),
              onTap: () async {
                final Part? newPart = await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      PartEditor(ticketId: widget.ticketId, part: parts[index]),
                );
                if (newPart != null) {
                  setState(() {
                    parts[index] = newPart;
                    widget.parts[index] = newPart;
                  });
                }
              },
            );
          },
        ),
        TextButton.icon(
          onPressed: () async {
            final Part? newPart = await showDialog(
              context: context,
              builder: (BuildContext context) => PartEditor(
                ticketId: widget.ticketId,
                part: Part(
                  id: -1,
                  ticketId: widget.ticketId,
                  name: "",
                  quantity: 0,
                  price: 0,
                ),
              ),
            );
            if (newPart != null) {
              setState(() {
                parts.add(newPart);
                widget.parts.add(newPart);
              });
            }
          },
          icon: Icon(Icons.add),
          label: Text('Adicionar Material/Peça'),
        ),
      ],
    );
  }
}
