import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:repairman/data/models/part.dart';

@immutable
class Ticket {
  final int id;
  final int statusId;
  final String service;
  final double? servicePrice;
  final DateTime? startDate;
  final DateTime? deliveryDate;
  final String? clientName;
  final String? clientDocument;
  final String? clientAddress;
  final String? clientContact;
  final String? repairTarget;
  final String? repairCondition;
  final String? repairDiagnosis;
  final String? statusName;
  final List<Part>? parts;

  const Ticket({
    required this.id,
    required this.statusId,
    required this.service,
    this.servicePrice,
    this.startDate,
    this.deliveryDate,
    this.clientName,
    this.clientDocument,
    this.clientAddress,
    this.clientContact,
    this.repairTarget,
    this.repairCondition,
    this.repairDiagnosis,
    this.statusName,
    this.parts,
  });

  factory Ticket.fromMap(Map<String, dynamic> map) => Ticket(
    id: map['id'],
    statusId: map['status_id'],
    service: map['service'],
    servicePrice: map['service_price'],
    startDate: map['start_date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['start_date'] * 1000)
        : null,
    deliveryDate: map['delivery_date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['delivery_date'] * 1000)
        : null,
    clientName: map['client_name'],
    clientDocument: map['client_document'],
    clientAddress: map['client_address'],
    clientContact: map['client_contact'],
    repairTarget: map['repair_target'],
    repairCondition: map['repair_condition'],
    repairDiagnosis: map['repair_diagnosis'],
    statusName: map['status_name'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'status_id': statusId,
    'service': service,
    'service_price': servicePrice,
    'start_date': startDate != null
        ? startDate!.millisecondsSinceEpoch ~/ 1000
        : null,
    'delivery_date': deliveryDate != null
        ? deliveryDate!.millisecondsSinceEpoch ~/ 1000
        : null,
    'client_name': clientName,
    'client_document': clientDocument,
    'client_address': clientAddress,
    'client_contact': clientContact,
    'repair_target': repairTarget,
    'repair_condition': repairCondition,
    'repair_diagnosis': repairDiagnosis,
  };

  Ticket copyWith({
    int? id,
    int? statusId,
    String? service,
    double? servicePrice,
    DateTime? startDate,
    DateTime? deliveryDate,
    String? clientName,
    String? clientDocument,
    String? clientAddress,
    String? clientContact,
    String? repairTarget,
    String? repairCondition,
    String? repairDiagnosis,
    String? statusName,
    List<Part>? parts,
  }) => Ticket(
    id: id ?? this.id,
    statusId: statusId ?? this.statusId,
    service: service ?? this.service,
    servicePrice: servicePrice ?? this.servicePrice,
    startDate: startDate ?? this.startDate,
    deliveryDate: deliveryDate ?? this.deliveryDate,
    clientName: clientName ?? this.clientName,
    clientDocument: clientDocument ?? this.clientDocument,
    clientAddress: clientAddress ?? this.clientAddress,
    clientContact: clientContact ?? this.clientContact,
    repairTarget: repairTarget ?? this.repairTarget,
    repairCondition: repairCondition ?? this.repairCondition,
    repairDiagnosis: repairDiagnosis ?? this.repairDiagnosis,
    statusName: statusName ?? this.statusName,
    parts: parts ?? this.parts,
  );

  static bool isEqual(Ticket ticketA, Ticket ticketB) =>
      (DeepCollectionEquality().equals(
        {...ticketA.toMap(), 'parts': ticketA.parts},
        {...ticketB.toMap(), 'parts': ticketB.parts},
      ));
}
