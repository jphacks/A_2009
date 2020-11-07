import 'dart:async';
import 'dart:io';

import 'package:jphacks2020/model/models.dart';
import 'package:jphacks2020/model/scan_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static const dbName = 'slide_history.db';
  static const tableName = 'slide_history';

  Future<Database> get database async {
    return _initDB();
  }

  static Future<String> getDatabaseFilePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, dbName);
    if (Directory(dirname(path)).existsSync()) {
      return path;
    }

    try {
      await Directory(dirname(path)).create(recursive: true);
    } on Exception catch (e) {
      print(e);
    }
    return path;
  }

  Future<Database> _initDB() async {
    final path = await getDatabaseFilePath();
    return openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    return db.execute(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, title TEXT, author TEXT, date TEXT, url TEXT)');
  }

  Future save(Presentation presentation, String url) async {
    final db = await database;

    await db.transaction((t) async {
      await t.insert(
          tableName,
          ScanItem.fromScan(presentation.title, presentation.author,
                  presentation.date, url)
              .toMap());
    });

    await db.close();
  }

  Future deleteScanItem(String url) async {
    final db = await database;
    await db.delete(tableName, where: 'url = ?', whereArgs: <String>[url]);
  }
}
