import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:jphacks2020/scan_item.dart';
import 'package:sqflite/sqflite.dart';

import 'history_db.dart';
import 'history_view.dart';

class QrReadView extends StatefulWidget {
  const QrReadView({Key key}) : super(key: key);

  @override
  _QrReadViewState createState() => _QrReadViewState();
}

class _QrReadViewState extends State<QrReadView> {
  String readData = '';

  Future scan() async {
    try {
      final code = await BarcodeScanner.scan();

      setState(() {
        readData = code.rawContent;
        _insertScanItem(code.rawContent);
        _moveToHistoryView(context);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          readData = 'カメラのパーミッションが有効になっていません。';
        });
      } else {
        setState(() => readData = '原因不明のエラー: $e');
      }
    } on FormatException {
      setState(() => readData = '読み取れませんでした (スキャンを開始する前に戻るボタンを使用しました)');
    } on Exception catch (e) {
      setState(() => readData = '不明なエラー: $e');
    }
  }

  Future _moveToHistoryView(BuildContext context) =>
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HistoryView()));

  @override
  void initState() {
    super.initState();
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '読み込めませんでした',
            ),
            Text(
              '$readData',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            ElevatedButton(
              child: const Text('もう一度'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: scan,
            ),
          ],
        ),
      ),
    );
  }

  Future _insertScanItem(String code) async {
    final path = await getDatabaseFilePath(dbName);
    final db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, text TEXT)');
    });

    await db.transaction((t) async {
      final i = await t.insert(tableName, ScanItem.fromQR(code).toMap());
      print(i);
    });

    db.close();
  }
}
