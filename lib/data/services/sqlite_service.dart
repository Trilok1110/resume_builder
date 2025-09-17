import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/personal_info.dart';

class SQLiteService {
  static Database? _database;
  static final SQLiteService instance = SQLiteService._init();

  SQLiteService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('resume.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE personal_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE education (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        degree TEXT,
        school TEXT,
        year TEXT,
        position INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE experience (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        job TEXT,
        company TEXT,
        duration TEXT,
        description TEXT,
        position INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE skills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        level TEXT,
        position INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        tech_stack TEXT,
        description TEXT,
        position INTEGER
      )
    ''');
  }

  // PersonalInfo curd
  Future<int> insertPersonalInfo(PersonalInfo info) async {
    final db = await instance.database;
    return await db.insert('personal_info', info.toMap());
  }

  Future<PersonalInfo?> getPersonalInfo() async {
    final db = await instance.database;
    final maps = await db.query('personal_info', limit: 1); //limit means  1 row at a time
    if (maps.isNotEmpty) {
      return PersonalInfo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePersonalInfo(PersonalInfo info) async {
    final db = await instance.database;
    return await db.update(
      'personal_info',
      info.toMap(),
      where: 'id = ?',
      whereArgs: [info.id],
    );
  }

  Future<int> deletePersonalInfo(int id) async {
    final db = await instance.database;
    return await db.delete(
      'personal_info',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD for all lists (common curd)
  Future<List<T>> getList<T>(
      String table, T Function(Map<String, dynamic>) fromMap) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, orderBy: 'position ASC');
    return List.generate(maps.length, (i) => fromMap(maps[i]));
  }

  Future<int> insertItem<T>(String table, Map<String, dynamic> map) async {
    final db = await instance.database;
    return await db.insert(table, map);
  }

  Future<int> updateItem<T>(
      String table, Map<String, dynamic> map, int id) async {
    final db = await instance.database;
    return await db.update(table, map, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteItem(String table, int id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // Reorder helper for reorder list
  Future<void> updatePositions(String table, List<int> ids) async {
    final db = await instance.database;
    for (int i = 0; i < ids.length; i++) {
      await db.update(table, {'position': i},
          where: 'id = ?', whereArgs: [ids[i]]);
    }
  }
}
