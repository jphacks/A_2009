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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scanner History'),
        ),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(children: [
                    ListTile(
                      title: Text(
                        'title',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Positioned(right: 0, child: _menuButton(context, index))
                  ]),
                  Row(
                    children: [
                      Text(
                        '{_items[index].text}',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '{testtest}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ));
            }));
  }

  Widget _menuButton(BuildContext context, int index) =>
      PopupMenuButton<PopUpMenuType>(
        onSelected: (PopUpMenuType type) {
          switch (type) {
            case PopUpMenuType.edit:
              _moveToFileEditView(context, bloc, proj);
              break;

            case PopUpMenuType.delete:
              bloc.delete(proj);
              cancelNotification(proj);
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenuType>>[
          const PopupMenuItem<PopUpMenuType>(
            value: PopUpMenuType.edit,
            child: Text('編集'),
          ),
          const PopupMenuItem<PopUpMenuType>(
            value: PopUpMenuType.delete,
            child: Text('削除'),
          ),
        ],
        icon: const Icon(Icons.more_vert),
      );
}

enum PopUpMenuType { edit, delete }

class _TimerDialog extends StatefulWidget {
  @override
  State createState() => _TimerDialogState();
}

class _TimerDialogState extends State<_TimerDialog> {
  final dateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final actions = <Widget>[
      FlatButton(
        child: Text(localizations.cancelButtonLabel),
        onPressed: () => Navigator.pop(context),
      ),
      FlatButton(
        child: Text(localizations.okButtonLabel),
        onPressed: () {
          final seconds = int.tryParse(dateTextController.text);
          Navigator.pop<Duration>(context, Duration(seconds: seconds));
        },
      ),
    ];
    final dialog = AlertDialog(
      title: const Text('Set Timer'),
      content: TextField(
        controller: dateTextController,
        decoration: const InputDecoration(
          hintText: 'sec',
        ),
        autofocus: true,
        keyboardType: TextInputType.number,
      ),
      actions: actions,
    );

    return dialog;
  }

  @override
  void dispose() {
    dateTextController.dispose();
    super.dispose();
  }
}
