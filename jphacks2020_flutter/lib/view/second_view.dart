import 'dart:async';
import 'dart:convert'; //httpレスポンスをJSON形式に変換用
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../model/models.dart';

class SecondView extends StatefulWidget {
  const SecondView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  bool _isLoading = false, _isInit = true;
  final StreamController<String> _pageCountController =
      StreamController<String>();

  final commentController = TextEditingController();
  final minuteController = TextEditingController();
  Presentation _presentation;
  List<Comment> _readcomment;
  int _nowpage = 0;

  @override
  void initState() {
    _loadFromAssets();
    _getLocalTestJSONData();
    super.initState();
  }

  Future<String> _loadAVaultAsset() async {
    return rootBundle.loadString('json/api_name.json');
  }

  Future _getLocalTestJSONData() async {
    final jsonString = await _loadAVaultAsset();
    setState(() {
      final jsonResponse = json.decode(jsonString) as Map<String, dynamic>;
      _presentation = Presentation.fromJson(jsonResponse);
      _readcomment = _presentation.comments.where((i) => i.index == 0).toList();
    });
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
              child: const Icon(Icons.favorite),
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
              child: Container(
                color: Colors.white,
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
                                            onPageChanged:
                                                (int current, int total) {
                                              _pageCountController
                                                  .add('${current + 1} '
                                                      '- $total');
                                              _readcomment.clear();
                                              _readcomment = _presentation
                                                  .comments
                                                  .where(
                                                      (i) => i.index == current)
                                                  .toList();
                                              print(current);
                                              setState(() {
                                                _nowpage = current;
                                              });
                                            }).cachedFromUrl(
                                            _presentation.url,
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
                                itemCount: _readcomment == null
                                    ? 0
                                    : _readcomment.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                const Divider(
                                  color: Colors.black,
                                ),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    tileColor: Colors.white,
                                    title: Text(_readcomment[index].text),
                                    trailing: Container(
                                      width: constraints.maxWidth / 3,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: FlatButton(
                                              child: const Icon(Icons.thumb_up),
                                              onPressed: () {
                                                //感想に+1がつく
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              // ignore: lines_longer_than_80_chars
                                                '${_readcomment[index].plus.toString()}'),
                                          ),
                                        ],
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future _plus() async {
    final slideId = _presentation.slideId;
    final url =
        'https://52e9bd550f9f.ngrok.io/api/materials/T0JuaLaHVNLhnLkP/comments/hogehoge/plus';

    final resp = await http.post(url);
    if (resp.statusCode != 422) {
      final respBody = resp.body;
      print('$respBody');
    } else {
      final statusCode = resp.statusCode;
      print('Failed to post $statusCode');
    }
  }

  Future _impression(String impression) async {
    final slideId = _presentation.slideId;
    final url =
        'https://52e9bd550f9f.ngrok.io/api/materials/T0JuaLaHVNLhnLkP/impressions';

    final headers = <String, String>{'content-type': 'application/json'};
    final body = json.encode({'value': '$impression'});
    final resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 422) {
      final respBody = resp.body;
      print('$respBody');
    } else {
      final statusCode = resp.statusCode;
      print('Failed to post $statusCode');
    }
  }

  Future _commentSend(String text) async {
    final slideId = _presentation.slideId;
    final url =
        'https://52e9bd550f9f.ngrok.io/api/materials/T0JuaLaHVNLhnLkP/comments';
    final headers = <String, String>{'content-type': 'application/json'};
    final body = json.encode({'text': '$text', 'number': 3});

    print('body: $body');

    final resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 422) {
      final respBody = resp.body;
      print('Failed to post $respBody');
    } else {
      final statusCode = resp.statusCode;
      print('Failed to post $statusCode');
    }
  }

  Future _loadFromAssets() async {
    setState(() {
      _isInit = false;
      _isLoading = true;
    });

    await fromAsset('assets/sample.pdf', 'sample.pdf').then((f) {
      setState(() {
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
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: commentController,
          decoration: InputDecoration(
            hintText: 'コメントや質問を入力してね',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _commentSend(commentController.text);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _alertDialog() {
    return AlertDialog(
      title: const Text('全体を通しての感想を教えてね'),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('もっと知りたい'),
                FlatButton(
                  child: const Icon(Icons.favorite),
                  onPressed: () {
                    _impression('know_more');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('とても勉強になった'),
                FlatButton(
                  child: const Icon(Icons.favorite),
                  onPressed: () {
                    _impression('good');
                    Navigator.pop(context);
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
                    _impression('interseting');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}