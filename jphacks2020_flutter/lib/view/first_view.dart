import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jphacks2020/model/api_client.dart';
import 'package:jphacks2020/model/models.dart';
import 'package:jphacks2020/view/second_view.dart';

import '../db/history_db.dart';
import 'history_view.dart';

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/images/logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 100),
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'QRリーダー',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  _scan(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 100),
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  '履歴',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  _moveToHistoryView(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _scan(BuildContext context) async {
    _showProgressDialog(context);
    try {
      final code = await BarcodeScanner.scan();

      if (code.rawContent.isNotEmpty) {
        await _getItem(context, code.rawContent);
      } else {
        Navigator.of(context).pop();
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        print('カメラのパーミッションが有効になっていません。');
      } else {
        print('error');
      }
    } on FormatException {
      print('読み取れませんでした (スキャンを開始する前に戻るボタンを使用しました)');
    } on Exception catch (e) {
      print('$e');
    }
  }

  Future _getItem(BuildContext context, String url) async {
    Presentation presentation;

    await ApiClient().getPosts(url).then((response) {
      print(response);
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      presentation = Presentation.fromJson(jsonResponse);
      Navigator.of(context).pop();
      _moveToSecondView(context, presentation, url);
      DBProvider.db.save(presentation, url);
      print(presentation.url);
    });
  }

  void _showProgressDialog(BuildContext context) {
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

  Future _moveToHistoryView(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => HistoryView()));
}
