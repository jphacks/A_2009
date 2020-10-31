import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR scaner And QR Maker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'QR scaner And QR Maker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 読み取り結果を格納するString型の変数readData
  String readData = "";

  /// QR及びバーコードスキャンを行うメソッドscan()
  /// Future:非同期処理を実現する
  Future scan() async {
    try {
      // String型のcodeにBarcodeScanner.scan()の結果を代入
      // await：非同期対応の要素のキーワード
      ScanResult code = await BarcodeScanner.scan();
      // readDataに読み取ったデータを格納する
      setState(() => this.readData = code as String);
    }
    // 例外処理：プラグインが何らかのエラーを出したとき
    on PlatformException catch (e) {
      // エラーコードがBarcodeScanner.CameraAccessDeniedであるときは、
      // このアプリにカメラ機能のパーミッションを許可していない状態であることを示す
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          // readDataにエラー内容を代入
          this.readData = 'カメラのパーミッションが有効になっていません。';
        });
      }
      // その他の場合は不明のエラー
      else {
        setState(() => this.readData = '原因不明のエラー: $e');
      }
    }
    // 意図しない入力、操作を受けたとき
    on FormatException{
      setState(() => this.readData = '読み取れませんでした (スキャンを開始する前に戻るボタンを使用しました)');
    } catch (e) {
      setState(() => this.readData = '不明なエラー: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'QRボタンを押すと読み取りを開始します',
            ),
            Text(
              // 読み取り結果readDataを表示
              '$readData',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      // ボタンを用意する
      floatingActionButton: FloatingActionButton(
        // onPressed:ボタンを押すことでscan()という関数が実行される
        onPressed: scan,
        tooltip: 'QR SCAN',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
