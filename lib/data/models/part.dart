import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class Part {
  final int id;
  final int ticketId;
  final String name;
  final double quantity;
  final double price;
  final bool ticked;
  final bool markedForRemoval;

  const Part({
    required this.id,
    required this.ticketId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.ticked,
    this.markedForRemoval = false,
  });

  factory Part.fromMap(Map<String, dynamic> map) => Part(
    id: map['id'],
    ticketId: map['ticket_id'],
    name: map['name'],
    quantity: map['quantity'],
    price: map['price'],
    ticked: map['ticked'] > 0,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'ticket_id': ticketId,
    'name': name,
    'quantity': quantity,
    'price': price,
    'ticked': ticked ? 1 : 0,
  };

  Part copyWith({
    int? id,
    int? ticketId,
    String? name,
    double? quantity,
    double? price,
    bool? ticked,
    bool? markedForRemoval,
  }) => Part(
    id: id ?? this.id,
    ticketId: ticketId ?? this.ticketId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    ticked: ticked ?? this.ticked,
    markedForRemoval: markedForRemoval ?? this.markedForRemoval,
  );

  static bool isEqual(Part partA, Part partB) =>
      (DeepCollectionEquality().equals(partA.toMap(), partB.toMap()));
}
