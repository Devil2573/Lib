import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'library.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        author TEXT,
        title TEXT,
        number INTEGER,
        genre TEXT,
        ageLimit INTEGER,
        availableCopies INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE readers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lastName TEXT,
        firstName TEXT,
        patronymic TEXT,
        age INTEGER,
        fine INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE borrowedBook(
        readerId INTEGER,
        bookId INTEGER,
        dueDate TEXT,
        FOREIGN KEY(readerId) REFERENCES readers(id),
        FOREIGN KEY(bookId) REFERENCES books(id)
      )
    ''');
  }
}
