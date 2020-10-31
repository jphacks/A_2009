import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jphacks2020/history_db.dart';
import 'package:jphacks2020/scan_item.dart';
import 'package:sqflite/sqflite.dart';

class HistoryView extends StatefulWidget {
  @override
  HistoryViewState createState() {
    return HistoryViewState();
  }
}

class HistoryViewState extends State<HistoryView> {
  List<ScanItem> _items = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future _initDatabase() async {
    final path = await getDatabaseFilePath(dbName);
    final db = await openReadOnlyDatabase(path);

    final List<Map> data = await db.query(tableName, columns: ['text']);

    final items = <ScanItem>[];

    for (final e in data) {
      items.add(ScanItem.fromMap(e));
    }
    setState(() {
      _items = items;
    });

    await db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scanner History'),
        ),
        body: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text('${_items[index].text}'));
            }));
  }
}