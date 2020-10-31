import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:jphacks2020/scan_item.dart';
import 'package:sqflite/sqflite.dart';

import 'history_db.dart';

class QrReadView extends StatefulWidget {
  const QrReadView({Key key}) : super(key: key);

  @override
  _QrReadViewState createState() => _QrReadViewState();
}

class _QrReadViewState extends State<QrReadView> {
  // 読み取り結果を格納するString型の変数readData
  String readData = '';

  /// QR及びバーコードスキャンを行うメソッドscan()
  /// Future:非同期処理を実現する
  Future scan() async {
    try {
      // String型のcodeにBarcodeScanner.scan()の結果を代入
      // await：非同期対応の要素のキーワード
      final code = await BarcodeScanner.scan();

      // readDataに読み取ったデータを格納する
      setState(() {
        readData = code.rawContent;
        _insertScanItem(readData);
      });
    }
    // 例外処理：プラグインが何らかのエラーを出したとき
    on PlatformException catch (e) {
      // エラーコードがBarcodeScanner.CameraAccessDeniedであるときは、
      // このアプリにカメラ機能のパーミッションを許可していない状態であることを示す
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          // readDataにエラー内容を代入
          readData = 'カメラのパーミッションが有効になっていません。';
        });
      }
      // その他の場合は不明のエラー
      else {
        setState(() => readData = '原因不明のエラー: $e');
      }
    }
    // 意図しない入力、操作を受けたとき
    on FormatException {
      setState(() => readData = '読み取れませんでした (スキャンを開始する前に戻るボタンを使用しました)');
    } on Exception catch (e) {
      setState(() => readData = '不明なエラー: $e');
    }
  }

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
              // 読み取り結果readDataを表示
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
    final path = await getDatabaseFilePath('scan_history.db');
    final db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE scan_history (id INTEGER PRIMARY KEY, text TEXT)');
    });

    await db.transaction((t) async {
      final i =
          await t.insert('scan_history', ScanItem.fromQR(code).toMap());
      print(i);
    });

    db.close();
  }
}
