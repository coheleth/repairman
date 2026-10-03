import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/widgets.dart';
import 'package:repairman/data/db/migrations.dart';
import 'package:repairman/data/models/status.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/data/models/part.dart';
import 'package:repairman/data/state/ticket_sort.dart';

class DBController {
  DBController._();
  static final DBController _dbController = DBController._();
  factory DBController() => _dbController;

  static final databaseFile = "repairman.db";
  static final databaseFolder = "repairman";

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database as Database;
    _database = await initDB();
    return _database as Database;
  }

  Future<Database> initDB() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    WidgetsFlutterBinding.ensureInitialized();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseFolder, databaseFile);
    return openDatabase(
      path,
      version: 1,
      onCreate: onDatabaseCreate,
      onUpgrade: onDatabaseUpgrade,
    );
  }

  Future<List<Status>> getAllStatus() async {
    final db = await database;

    final res = await db.query('status', orderBy: 'sort_order ASC');

    List<Status> list = res.isNotEmpty
        ? res.map((status) => Status.fromMap(status)).toList()
        : [];

    return list;
  }

  Future<Status?> getStatusById(int id) async {
    final db = await database;
    final res = await db.query('status', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      final status = Status.fromMap(res.first);
      return status;
    }
    return null;
  }

  Future<Status?> getFirstStatus() async {
    final db = await database;
    final res = await db.query('status', orderBy: 'sort_order ASC');
    if (res.isNotEmpty) {
      final status = Status.fromMap(res.first);
      return status;
    }
    return null;
  }

  Future<String> getStatusName(int id) async {
    final db = await database;
    final res = await db.query(
      'status',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      return res.first['name'] as String;
    }
    return "";
  }

  // Ticket

  Future<Ticket> getTicketById(int id) async {
    final db = await database;
    final res = await db.query('ticket', where: 'id = ?', whereArgs: [id]);
    var ticket = Ticket.fromMap(res.first);
    final status = await getStatusById(ticket.statusId);
    final statusName = status?.name ?? '';
    final done = status?.done;
    final parts = await getPartsByTicketId(ticket.id);
    ticket = ticket.copyWith(statusName: statusName, done: done, parts: parts);
    return ticket;
  }

  Future<List<Ticket>> getTicketsByStatusId(
    int statusId, {
    TicketSortMode sortMode = TicketSortMode.startDate,
    TicketSortDirection sortDirection = TicketSortDirection.descending,
  }) async {
    final db = await database;
    String orderBy;
    switch (sortMode) {
      case TicketSortMode.startDate:
        orderBy = 'start_date';
      case TicketSortMode.deliveryDate:
        orderBy = 'delivery_date';
      case TicketSortMode.client:
        orderBy = 'LOWER(client_name)';
      case TicketSortMode.service:
        orderBy = 'LOWER(service)';
      case TicketSortMode.status:
        orderBy = 'start_date';
    }

    String orderDirection = 'DESC';
    if (sortDirection == TicketSortDirection.ascending) {
      orderDirection = 'ASC';
    }

    final res = await db.query(
      'ticket',
      where: 'status_id = ?',
      whereArgs: [statusId],
      orderBy: '$orderBy $orderDirection NULLS LAST',
    );
    List<Ticket> list = res.isNotEmpty
        ? res.map((ticket) => Ticket.fromMap(ticket)).toList()
        : [];
    return list;
  }

  Future<List<Ticket>> getAllTickets({
    TicketSortMode sortMode = TicketSortMode.startDate,
    TicketSortDirection sortDirection = TicketSortDirection.descending,
    int statusFilter = -1,
  }) async {
    final db = await database;

    String sql = '''
      SELECT ticket.*, status.name as status_name FROM ticket
      LEFT JOIN status ON ticket.status_id = status.id
    ''';
    List<dynamic> args = [];

    if (statusFilter > 0) {
      sql += 'WHERE status_id = ? ';
      args.add(statusFilter);
    }

    String orderBy;
    switch (sortMode) {
      case TicketSortMode.startDate:
        orderBy = 'start_date';
      case TicketSortMode.deliveryDate:
        orderBy = 'delivery_date';
      case TicketSortMode.client:
        orderBy = 'LOWER(client_name)';
      case TicketSortMode.service:
        orderBy = 'LOWER(service)';
      case TicketSortMode.status:
        orderBy = 'status.sort_order';
    }

    String orderDirection = 'DESC';
    if (sortDirection == TicketSortDirection.ascending) {
      orderDirection = 'ASC';
    }
    sql += 'ORDER BY $orderBy $orderDirection NULLS LAST ';

    final res = await db.rawQuery(sql, args);

    List<Ticket> list = res.isNotEmpty
        ? res.map((ticket) => Ticket.fromMap(ticket)).toList()
        : [];
    return list;
  }

  Future<List<Ticket>> searchTickets(String query) async {
    final db = await database;
    final like = '%$query%';

    final res = await db.query(
      'ticket',
      where: '''
        service LIKE ?
        OR client_name LIKE ?
        OR repair_target LIKE ?
        OR location LIKE ?
        OR start_date_readable LIKE ?
        OR delivery_date_readable LIKE ?
        ''',
      whereArgs: List.filled(6, like),
      orderBy:
          '''
        service LIKE '$like' DESC,
        repair_target LIKE '$like' DESC,
        service LIKE '$like' DESC,
        location LIKE '$like' DESC,
        start_date_readable LIKE '$like' DESC,
        delivery_date_readable LIKE '$like' DESC,
        service DESC
        ''',
    );

    List<Ticket> list = res.isNotEmpty
        ? res.map((ticket) => Ticket.fromMap(ticket)).toList()
        : [];
    return list;
  }

  Future<int> createTicket(Ticket ticket) async {
    final db = await database;
    final map = ticket.toMap();
    map.remove('id');
    return await db.insert('ticket', map);
  }

  Future<int> updateTicket(Ticket ticket) async {
    final db = await database;
    return await db.update(
      'ticket',
      ticket.toMap(),
      where: 'id = ?',
      whereArgs: [ticket.id],
    );
  }

  Future<int> deleteTicketById(int id) async {
    final db = await database;
    db.delete('part', where: 'ticket_id = ?', whereArgs: [id]);
    return await db.delete('ticket', where: 'id = ?', whereArgs: [id]);
  }

  // Part

  Future<List<Part>> getPartsByTicketId(int ticketId) async {
    final db = await database;
    final res = await db.query(
      'part',
      where: 'ticket_id = ?',
      whereArgs: [ticketId],
    );
    List<Part> list = res.isNotEmpty
        ? res.map((component) => Part.fromMap(component)).toList()
        : [];
    return list;
  }

  Future<int> createPart(Part part) async {
    final db = await database;
    final map = part.toMap();
    map.remove('id');
    final id = await db.insert('part', map);
    return id;
  }

  Future<int> updatePart(Part part) async {
    final db = await database;
    return await db.update(
      'part',
      part.toMap(),
      where: 'id = ?',
      whereArgs: [part.id],
    );
  }

  Future<int> deletePartById(int id) async {
    final db = await database;
    return await db.delete('part', where: 'id = ?', whereArgs: [id]);
  }
}
