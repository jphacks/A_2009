import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class SecondView extends StatefulWidget {
  const SecondView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  bool _isLoading = false, _isInit = true;
  PDFDocument _document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            //return first view
          },
        ),
        title: const Text('JPHacks2020'),
        actions: <Widget>[
          SizedBox(
            width: 60,
            child: FlatButton(
              child: const Icon(Icons.thumb_up),
              onPressed: () {
                _loadFromAssets();
              },
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                  child: _isInit
                      ? const Text('please load PDF')
                      : _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : PDFViewer(document: _document)),
            )
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future _loadFromAssets() async {
    setState(() {
      _isInit = false;
      _isLoading = true;
    });

    final document = await PDFDocument.fromAsset('assets/sample.pdf');
    setState(() {
      _document = document;
      _isLoading = false;
    });
  }
}
