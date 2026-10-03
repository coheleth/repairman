import 'package:flutter/foundation.dart';

enum Done { inProgress, done, doneAll }

@immutable
class Status {
  final int id;
  final String name;
  final int sortOrder;
  final Done done;

  const Status({
    required this.id,
    required this.name,
    this.done = Done.inProgress,
    this.sortOrder = 0,
  });

  factory Status.fromMap(Map<String, dynamic> map) => Status(
    id: map["id"],
    name: map['name'],
    sortOrder: map['sort_order'],
    done: switch (map['done']) {
      1 => Done.done,
      2 => Done.doneAll,
      _ => Done.inProgress,
    },
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'sort_order': sortOrder,
    'done': switch (done) {
      Done.inProgress => 0,
      Done.done => 1,
      Done.doneAll => 2,
    },
  };
}
