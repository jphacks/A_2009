import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

String dbName = 'slide_history.db';
String tableName = 'slide_history';

// return the path
Future<String> getDatabaseFilePath(String dbName) async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  print(documentsDirectory);

  final path = join(documentsDirectory.path, dbName);
  if (new Directory(dirname(path)).existsSync()) {
    return path;
  }

  try {
    await new Directory(dirname(path)).create(recursive: true);
  } on Exception catch (e) {
    print(e);
  }
  return path;
}