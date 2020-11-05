import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class SecondView extends StatefulWidget {
  const SecondView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  bool _isLoading = false, _isInit = true;
  String _document;
  final items = List<String>.generate(5, (i) => 'comment $i');
  final StreamController<String> _pageCountController =
      StreamController<String>();

  final commentController = TextEditingController();
  final minuteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('JPHacks2020'),
        actions: <Widget>[
          SizedBox(
            width: 60,
            child: FlatButton(
              child: const Icon(Icons.refresh),
              onPressed: () {
                _loadFromAssets();
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: FlatButton(
              child: const Icon(Icons.thumb_up),
              onPressed: () {
                //全体の感想を入力できる枠が出てくる
                showDialog<AlertDialog>(
                  context: context,
                  builder: (context) {
                    return _alertDialog();
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: (constraints.maxHeight - 50) / 2,
                            child: Center(
                              child: _isInit
                                  ? const Text('please load PDF')
                                  : _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : PDF(
                                              swipeHorizontal: true,
                                              onPageChanged: (int current,
                                                      int total) =>
                                                  _pageCountController.add(
                                                      '${current + 1} '
                                                          '- $total'))
                                          .cachedFromUrl(
                                          'https://a-2009-jphacks--2020-s3.s3-ap-northeast-1.amazonaws.com/uploads/material/1__tNY0w0GRlbfLvg58__url/JPHACKS__Vele.pdf',
                                          placeholder: (progress) => Center(
                                              child: Text('$progress %')),
                                          errorWidget: (dynamic error) =>
                                              Center(
                                                  child:
                                                      Text(error.toString())),
                                        ),
                            ),
                          ),
                          SizedBox(
                            height: (constraints.maxHeight - 50) / 2,
                            child: ListView.separated(
                              itemCount: items.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                color: Colors.black,
                              ),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  tileColor: Colors.white,
                                  title: Text(items[index]),
                                  trailing: Container(
                                    child: FlatButton(
                                      child: const Icon(Icons.thumb_up),
                                      onPressed: () {
                                        //感想に+1がつく
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _textWidget(),
                ],
              ),
            );
          },
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

    await fromAsset('assets/sample.pdf', 'sample.pdf').then((f) {
      setState(() {
        _document = f.path;
        _isLoading = false;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    final completer = Completer<File>();

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');
      final data = await rootBundle.load(asset);
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } on Exception catch (e) {
      throw Exception('$e');
    }

    return completer.future;
  }

  Widget _textWidget() {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: commentController,
      decoration: InputDecoration(
        hintText: 'コメントや質問を入力してね',
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            print(commentController.text);
          },
        ),
      ),
    );
  }

  Widget _alertDialog() {
    return AlertDialog(
      title: const Text('全体を通しての感想を教えてね'),
      content: SizedBox(
        height: 240,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('もっと聞きたい'),
                FlatButton(
                  child: const Icon(Icons.favorite),
                  onPressed: () {
                    //感想をサーバーに送る
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('とても参考になった'),
                FlatButton(
                  child: const Icon(Icons.favorite),
                  onPressed: () {
                    //感想をサーバーに送る
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('面白かった'),
                FlatButton(
                  child: const Icon(Icons.favorite),
                  onPressed: () {
                    //感想をサーバーに送る
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('愛している'),
                FlatButton(
                  child: const Icon(Icons.favorite),
                  onPressed: () {
                    //感想をサーバーに送る
                  },
                ),
              ],
            ),
            TextField(
              controller: minuteController,
              decoration: InputDecoration(
                hintText: 'コメントや質問を入力してね',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    print(minuteController.text);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
