import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  /// constructor is private, so that it will become singleton means there will be only one obj of this class (why should we have multiple objs of db in our application)
  DBHelper._();

  // to call this function, we have to create instance of DBHelper but we've made it's constructor private, so just make this function static
  // now whenever we do like this:
  // DBHelper db = DBHelper.getInstance();
  // same static function will be called and it will always return the same static obj, so there will be only one obj in our application
  /*
  static DBHelper getInstance() {
    return DBHelper._();
  }
  */
  // or
  static final DBHelper getInstance = DBHelper._();

  static const notesTable = "notes";
  static const columnNotesId = "id";
  static const columnNotesTitle = "title";
  static const columnNotesDescription = "description";

  Database? myDb;

  // now db open (path -> if exists then open else create)

  Future<Database> getDb() async {
    myDb ??= await openDb();
    return myDb!;
  }

  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, 'notesAppDb.db');

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        // create tables here
        db.execute(
          'CREATE TABLE $notesTable ($columnNotesId INTEGER PRIMARY KEY AUTOINCREMENT, $columnNotesTitle TEXT, $columnNotesDescription TEXT)',
        );
      },
      version: 1,
    );
  }

  // all queries

  Future<bool> addNote({
    required String title,
    required String description,
  }) async {
    final db = await getDb();

    int rowsAffected = await db.insert(notesTable, {
      columnNotesTitle: title,
      columnNotesDescription: description,
    });

    return rowsAffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await getDb();

    final List<Map<String, dynamic>> allRowsData = await db.query(notesTable);

    return allRowsData;
  }

  Future<bool> updateNote({
    required int id,
    String? title,
    String? description,
  }) async {
    final db = await getDb();

    final Map<String, Object> values = {};

    if (title != null) {
      values[columnNotesTitle] = title;
    }
    if (description != null) {
      values[columnNotesDescription] = description;
    }

    int rowsAffected = await db.update(
      notesTable,
      values,
      where: '$columnNotesId = ?',
      whereArgs: [id],
    );

    return rowsAffected > 0;
  }

  Future<bool> deleteNote({required int id}) async {
    final db = await getDb();

    int rowsAffected = await db.delete(
      notesTable,
      where: '$columnNotesId = ?',
      whereArgs: [id],
    );

    return rowsAffected > 0;
  }
}
