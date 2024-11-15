import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CategoryDatabaseHelper {
  static final CategoryDatabaseHelper _instance = CategoryDatabaseHelper._internal();
  factory CategoryDatabaseHelper() => _instance;

  static Database? _database;

  CategoryDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'categories.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Categories (
            id INTEGER PRIMARY KEY,
            category TEXT,
            title TEXT,
            isFav TEXT,
            cdata TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    await db.insert('Categories', category,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final db = await database;
    return await db.query('Categories');
  }

  Future<void> clearCategories() async {
    final db = await database;
    await db.delete('Categories');
  }
}
