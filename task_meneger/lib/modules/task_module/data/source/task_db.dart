import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskDb {
  TaskDb._privateConstructor();
  static final TaskDb instance = TaskDb._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'task_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            title TEXT NOT NULL,
            description TEXT DEFAULT '',
            isCompleted INTEGER NOT NULL DEFAULT 0,
            deadline TEXT NOT NULL,
            realisationDate TEXT DEFAULT ''
          )
        ''');
      },
    );
  }

  Future<int> insertTask(Map<String,Object?> task) async {
    final db = await database;
    return await db.insert('tasks', task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String,Object?>>> getTasks() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('tasks');
    return maps;
  }

  Future<void> updateTask(Map<String,Object?> task) async {
    final db = await database;
    await db.update('tasks', task,
        where: 'id = ?', whereArgs: [task['id']]);
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}