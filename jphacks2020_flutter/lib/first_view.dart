import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jphacks2020/qr_read_view.dart';

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('カメラで追加'),
              onPressed: () {
                _moveToQrReadView(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('履歴'),
              onPressed: () {
                // _getImageFromDevice(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _moveToQrReadView(BuildContext context) => Navigator.push(context,
      MaterialPageRoute<void>(builder: (context) => const QrReadView()));
}
