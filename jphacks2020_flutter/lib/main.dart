import 'package:flutter/material.dart';
import 'View/first_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstView(),
    );
  }
}
