import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/data/models/status.dart';
import 'package:repairman/data/models/part.dart';

@immutable
class Ticket {
  final int id;
  final int statusId;
  final DateTime? startDate;
  final DateTime? deliveryDate;
  final String? clientName;
  final String? clientDocument;
  final String? clientAddress;
  final String? clientContact;
  final String? location;
  final String? repairTarget;
  final String? repairCondition;
  final String? repairDiagnosis;
  final String? obs;
  final String? service;
  final double? servicePrice;
  final int? priority;

  final String? idReadable;
  final String? statusName;
  final Done done;
  final List<Part>? parts;

  const Ticket({
    required this.id,
    required this.statusId,
    this.startDate,
    this.deliveryDate,
    this.clientName,
    this.clientDocument,
    this.clientAddress,
    this.clientContact,
    this.location,
    this.repairTarget,
    this.repairCondition,
    this.repairDiagnosis,
    this.obs,
    this.service,
    this.servicePrice,
    this.priority,
    this.idReadable,
    this.statusName,
    this.parts,
    this.done = Done.inProgress,
  });

  factory Ticket.empty() => Ticket(id: -1, statusId: 0, service: '');

  factory Ticket.fromMap(Map<String, dynamic> map) => Ticket(
    id: map['id'],
    idReadable: map['id_readable'],
    statusId: map['status_id'],
    startDate: map['start_date'] != null
        ? unixTimeStampToDate(map['start_date'])
        : null,
    deliveryDate: map['delivery_date'] != null
        ? unixTimeStampToDate(map['delivery_date'])
        : null,
    clientName: map['client_name'],
    clientDocument: map['client_document'],
    clientAddress: map['client_address'],
    clientContact: map['client_contact'],
    location: map['location'],
    repairTarget: map['repair_target'],
    repairCondition: map['repair_condition'],
    repairDiagnosis: map['repair_diagnosis'],
    obs: map['obs'],
    service: map['service'],
    servicePrice: map['service_price'],
    priority: map['priority'],
    statusName: map['status_name'] ?? '',
    done: switch (map['done']) {
      1 => Done.done,
      2 => Done.doneAll,
      _ => Done.inProgress,
    },
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'id_readable': ticketIdAsString(id),
    'status_id': statusId,
    'start_date': startDate != null ? dateToUnixTimeStamp(startDate!) : null,
    'start_date_readable': dateAsString(startDate),
    'delivery_date': deliveryDate != null
        ? dateToUnixTimeStamp(deliveryDate!)
        : null,
    'delivery_date_readable': dateAsString(deliveryDate),
    'client_name': clientName,
    'client_document': clientDocument,
    'client_address': clientAddress,
    'client_contact': clientContact,
    'location': location,
    'repair_target': repairTarget,
    'repair_condition': repairCondition,
    'repair_diagnosis': repairDiagnosis,
    'obs': obs,
    'service': service,
    'service_price': servicePrice,
    'priority': priority,
  };

  Ticket copyWith({
    int? id,
    int? statusId,
    DateTime? startDate,
    DateTime? deliveryDate,
    String? clientName,
    String? clientDocument,
    String? clientAddress,
    String? clientContact,
    String? location,
    String? repairTarget,
    String? repairCondition,
    String? repairDiagnosis,
    String? obs,
    String? service,
    double? servicePrice,
    int? priority,
    String? statusName,
    Done? done,
    List<Part>? parts,
  }) => Ticket(
    id: id ?? this.id,
    statusId: statusId ?? this.statusId,
    startDate: startDate ?? this.startDate,
    deliveryDate: deliveryDate ?? this.deliveryDate,
    clientName: clientName ?? this.clientName,
    clientDocument: clientDocument ?? this.clientDocument,
    clientAddress: clientAddress ?? this.clientAddress,
    clientContact: clientContact ?? this.clientContact,
    location: location ?? this.location,
    repairTarget: repairTarget ?? this.repairTarget,
    repairCondition: repairCondition ?? this.repairCondition,
    repairDiagnosis: repairDiagnosis ?? this.repairDiagnosis,
    obs: obs ?? this.obs,
    service: service ?? this.service,
    servicePrice: servicePrice ?? this.servicePrice,
    priority: priority ?? this.priority,
    statusName: statusName ?? this.statusName,
    done: done ?? this.done,
    idReadable: ticketIdAsString(id ?? this.id),
    parts: parts ?? this.parts,
  );

  static bool isEqual(Ticket ticketA, Ticket ticketB) =>
      (DeepCollectionEquality().equals(
        {...ticketA.toMap(), 'parts': ticketA.parts},
        {...ticketB.toMap(), 'parts': ticketB.parts},
      ));
}
