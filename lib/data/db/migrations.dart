import 'package:sqflite/sqflite.dart';

void onDatabaseCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS status (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      sort_order INTEGER
    );
    CREATE TABLE IF NOT EXISTS ticket (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      status_id INTEGER REFERENCES status (id),
      service TEXT,
      service_price REAL,
      client_name TEXT,
      client_document TEXT,
      client_address TEXT,
      client_contact TEXT,
      repair_target TEXT,
      repair_condition TEXT,
      repair_diagnosis TEXT,
      start_date INT,
      delivery_date INT
    );
    CREATE TABLE IF NOT EXISTS part (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ticket_id INTEGER REFERENCES ticket (id),
      name TEXT,
      quantity REAL,
      price REAL
    );
  ''');
  await db.insert('status', {'name': 'Não Iniciado', 'sort_order': 0});
  await db.insert('status', {'name': 'Em Andamento', 'sort_order': 1});
  await db.insert('status', {'name': 'Finalizado', 'sort_order': 2});
  await db.insert('status', {'name': 'Entregue', 'sort_order': 3});
}

void onDatabaseUpdate(Database db, int oldVersion, int newVersion) async {}
