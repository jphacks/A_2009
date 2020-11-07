import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jphacks2020/db/history_db.dart';
import 'package:jphacks2020/model/api_client.dart';
import 'package:jphacks2020/model/models.dart';
import 'package:jphacks2020/model/scan_item.dart';
import 'package:jphacks2020/view/second_view.dart';
import 'package:sqflite/sqflite.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
      ),
      body: HistoryList(),
    );
  }
}

class HistoryList extends StatefulWidget {
  @override
  HistoryListState createState() {
    return HistoryListState();
  }
}

class HistoryListState extends State<HistoryList> {
  List<ScanItem> _items = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future _initDatabase() async {
    final path = await DBProvider.getDatabaseFilePath();
    final db = await openReadOnlyDatabase(path);

    final List<Map> data = await db
        .query(DBProvider.tableName, groupBy: ScanItem.columnUrl, columns: [
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
    return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
            child: Card(
                child: InkWell(
              onTap: () {
                _didTapCard(context, _items[index].url);
              },
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                                fontSize: 32,
                                color: Colors.black,
                              ),
                            ),
                            _menuButton(_items[index].url)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateFormat.format(_items[index].date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _items[index].author,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
          );
        });
  }

  Future _didTapCard(BuildContext context, String url) async {
    _showProgressDialog();
    await ApiClient().getPosts(url).then((response) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      Navigator.of(context).pop();
      _moveToSecondView(context, Presentation.fromJson(jsonResponse), url);
    });
  }

  void _showProgressDialog() {
    showGeneralDialog<Widget>(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future _moveToSecondView(
          BuildContext context, Presentation presentation, String url) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SecondView(presentation: presentation, url: url)));

  Widget _menuButton(String url) => PopupMenuButton<PopUpMenuType>(
        onSelected: (PopUpMenuType type) {
          switch (type) {
            case PopUpMenuType.delete:
              DBProvider.db
                  .deleteScanItem(url)
                  .then((dynamic value) => setState(_initDatabase));
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenuType>>[
          const PopupMenuItem<PopUpMenuType>(
            value: PopUpMenuType.delete,
            child: Text('削除'),
          ),
        ],
        icon: const Icon(Icons.more_vert),
      );
}

enum PopUpMenuType { delete }
