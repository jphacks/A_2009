import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jphacks2020/db/history_db.dart';
import 'package:jphacks2020/model/api_client.dart';
import 'package:jphacks2020/model/models.dart';
import 'package:jphacks2020/model/scan_item.dart';
import 'package:jphacks2020/view/second_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class HistoryView extends StatefulWidget {
  @override
  HistoryViewState createState() {
    return HistoryViewState();
  }
}

class HistoryViewState extends State<HistoryView> {
  List<ScanItem> _items = [];
  final _historyMenu = ['名前の変更', '削除'];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future _initDatabase() async {
    final path = await getDatabaseFilePath(dbName);
    final db = await openReadOnlyDatabase(path);

    final List<Map> data = await db.query(tableName, columns: [
      ScanItem.columnTitle,
      ScanItem.columnUrl,
      ScanItem.columnDate,
      ScanItem.columnAuthor
    ]);

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
              return Card(
                  child: InkWell(
                onTap: () {
                  _didTapCard(context, _items[index].url);
                },
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _items[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Colors.black,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (BuildContext context) {
                                return _historyMenu.map((String s) {
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
                            Text(
                              dateFormat.format(_items[index].date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _items[index].author,
                              style: const TextStyle(
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
                ),
              ));
            }));
  }

  Future _didTapCard(BuildContext context, String url) async {
    await ApiClient().getPosts(url).then((response) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      _moveToSecondView(context, Presentation.fromJson(jsonResponse), url);
    });
  }

  Future _moveToSecondView(
          BuildContext context, Presentation presentation, String url) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecondView(
                    presentation: presentation,
                    url: url,
                    isFromQr: false,
                  )));
}

enum PopUpMenuType { edit, delete }

DateFormat dateFormat = DateFormat('yyyy/MM/dd');
