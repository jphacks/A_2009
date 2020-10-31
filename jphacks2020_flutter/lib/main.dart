import 'package:flutter/material.dart';

import 'first_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR scaner And QR Maker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstView(),
    );
  }
}

