// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:flutter/services.dart';
// import 'package:jphacks2020/model/api_client.dart';
// import 'package:jphacks2020/model/models.dart';
// import 'package:jphacks2020/model/scan_item.dart';
// import 'package:jphacks2020/view/second_view.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../db/history_db.dart';
//
// class QrReadView extends StatefulWidget {
//   const QrReadView({Key key}) : super(key: key);
//
//   @override
//   _QrReadViewState createState() => _QrReadViewState();
// }
//
// class _QrReadViewState extends State<QrReadView> {
//   String readData = '';
//
//   Future _scan() async {
//     try {
//       final code = await BarcodeScanner.scan();
//
//       setState(() {
//         readData = code.rawContent;
//         _insertScanItem(code.rawContent);
//       });
//     } on PlatformException catch (e) {
//       if (e.code == BarcodeScanner.cameraAccessDenied) {
//         setState(() {
//           readData = 'カメラのパーミッションが有効になっていません。';
//         });
//       } else {
//         setState(() => readData = '原因不明のエラー: $e');
//       }
//     } on FormatException {
//       setState(() => readData = '読み取れませんでした (スキャンを開始する前に戻るボタンを使用しました)');
//     } on Exception catch (e) {
//       setState(() => readData = '不明なエラー: $e');
//     }
//   }
//
//   Future _moveToSecondView(
//           BuildContext context, Presentation presentation, String url) =>
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => SecondView(
//                   presentation: presentation, url: url, isFromQr: true)));
//
//   @override
//   void initState() {
//     super.initState();
//     _scan();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
//
//   Future _insertScanItem(String url) async {
//     Presentation presentation;
//
//     await ApiClient().getPosts(url).then((response) {
//       final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
//       presentation = Presentation.fromJson(jsonResponse);
//       _moveToSecondView(context, presentation, url);
//       _save(presentation, url);
//       print(presentation.url);
//     });
//   }
//
//   Future _save(Presentation presentation, String url) async {
//     final path = await getDatabaseFilePath(dbName);
//     final db = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute(
//           // ignore: lines_longer_than_80_chars
//           'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, title TEXT, author TEXT, date TEXT, url TEXT)');
//     });
//
//     await db.transaction((t) async {
//       final i = await t.insert(
//           tableName,
//           ScanItem.fromScan(presentation.title, presentation.author,
//                   presentation.date, url)
//               .toMap());
//       print(i);
//     });
//
//     await db.close();
//   }
// }
