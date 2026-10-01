import 'package:flutter/foundation.dart';

@immutable
class Part {
  final int id;
  final int ticketId;
  final String name;
  final double quantity;
  final double price;
  final bool markedForRemoval;

  const Part({
    required this.id,
    required this.ticketId,
    required this.name,
    required this.quantity,
    required this.price,
    this.markedForRemoval = false,
  });

  factory Part.fromMap(Map<String, dynamic> map) => Part(
    id: map['id'],
    ticketId: map['ticket_id'],
    name: map['name'],
    quantity: map['quantity'],
    price: map['price'],
  );

  Part copyWith({
    int? id,
    int? ticketId,
    String? name,
    double? quantity,
    double? price,
    bool? markedForRemoval,
  }) => Part(
    id: id ?? this.id,
    ticketId: ticketId ?? this.ticketId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    markedForRemoval: markedForRemoval ?? this.markedForRemoval,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'ticket_id': ticketId,
    'name': name,
    'quantity': quantity,
    'price': price,
  };
}
