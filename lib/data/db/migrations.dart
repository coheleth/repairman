import 'package:sqflite/sqflite.dart';

void onDatabaseCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS status (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      sort_order INTEGER,
      done INT
    );
    CREATE TABLE IF NOT EXISTS ticket (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      status_id INTEGER REFERENCES status (id),
      start_date INT,
      start_date_readable TEXT,
      delivery_date INT,
      delivery_date_readable TEXT,
      client_name TEXT,
      client_document TEXT,
      client_address TEXT,
      client_contact TEXT,
      location TEXT,
      repair_target TEXT,
      repair_condition TEXT,
      repair_diagnosis TEXT,
      service TEXT,
      service_price REAL,
      obs TEXT
    );
    CREATE TABLE IF NOT EXISTS part (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ticket_id INTEGER REFERENCES ticket (id),
      name TEXT,
      quantity REAL,
      price REAL,
      ticked INTEGER
    );
  ''');
  await db.insert('status', {'name': 'Não Iniciado', 'sort_order': 0});
  await db.insert('status', {'name': 'Aguardando Materiais', 'sort_order': 1});
  await db.insert('status', {'name': 'Em Andamento', 'sort_order': 2});
  await db.insert('status', {'name': 'Finalizado', 'sort_order': 3, 'done': 1});
  await db.insert('status', {'name': 'Entregue', 'sort_order': 4, 'done': 2});
}

void onDatabaseUpgrade(Database db, int oldVersion, int newVersion) async {}
