import 'package:flutter/foundation.dart';

@immutable
class Status {
  final int id;
  final String name;
  final int sortOrder;

  const Status({required this.id, required this.name, this.sortOrder = 0});

  factory Status.fromMap(Map<String, dynamic> map) =>
      Status(id: map["id"], name: map['name'], sortOrder: map['sort_order']);

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'sort_order': sortOrder,
  };
}
