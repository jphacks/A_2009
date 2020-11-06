import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jphacks2020/db/history_db.dart';
import 'package:jphacks2020/model/scan_item.dart';
import 'package:sqflite/sqflite.dart';

class HistoryView extends StatefulWidget {
  @override
  HistoryViewState createState() {
    return HistoryViewState();
  }
}

class HistoryViewState extends State<HistoryView> {
  List<ScanItem> _items = [];
  final items2 = List<String>.generate(5, (i) => 'Item $i');
  final _historymenu = ['名前の変更', '削除'];

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
            itemCount: items2.length,
            itemBuilder: (context, index) {
              return Card(
                  child: Container(
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'title${index}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.black,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (BuildContext context) {
                              return _historymenu.map((String s) {
                                return PopupMenuItem(
                                  child: Text(s),
                                  value: s,
                                );
                              }).toList();
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         const Text(
                            '11/03',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            '佐藤 舜',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
            }));
  }
}

enum PopUpMenuType { edit, delete }
