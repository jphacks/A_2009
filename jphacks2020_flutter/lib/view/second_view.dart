import 'dart:async';
import 'dart:convert'; //httpレスポンスをJSON形式に変換用

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;

import '../model/models.dart';

class SecondView extends StatefulWidget {
  const SecondView({Key key, this.presentation}) : super(key: key);

  final Presentation presentation;

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  final commentController = TextEditingController();
  final minuteController = TextEditingController();
  List<Comment> _comments;
  int _currentPage;
  @override
  void initState() {
    super.initState();
    _comments =
        widget.presentation.comments.where((i) => i.index == 1).toList();
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
                // _loadFromAssets();
                //TODO
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
                                child: PDF(
                                    swipeHorizontal: true,
                                    onPageChanged: (int current, int total) {
                                      _comments.clear();
                                      _comments = widget.presentation.comments
                                          .where((i) => i.index == current + 1)
                                          .toList();
                                      setState(() {
                                        _currentPage = current;
                                      });
                                    }).cachedFromUrl(
                                  widget.presentation.url,
                                  placeholder: (progress) =>
                                      Center(child: Text('$progress %')),
                                  errorWidget: (dynamic error) =>
                                      Center(child: Text(error.toString())),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (constraints.maxHeight - 50) / 2,
                              child: ListView.separated(
                                itemCount:
                                    _comments == null ? 0 : _comments.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                  color: Colors.black,
                                ),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    tileColor: Colors.white,
                                    title: Text(_comments[index].text),
                                    trailing: SizedBox(
                                      width: constraints.maxWidth / 3,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: FlatButton(
                                              child: const Icon(Icons.thumb_up),
                                              onPressed: () {
                                                _plus(
                                                    _comments[index].commentId);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            child: Text(
                                                // ignore: lines_longer_than_80_chars
                                                '${_comments[index].plus.toString()}'),
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

  Future _plus(String uuid) async {
    final slideId = widget.presentation.slideId;
    final url = '$ngrokUrl/api/materials/$slideId/comments/$uuid/plus';

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
    final slideId = widget.presentation.slideId;
    final url = '$ngrokUrl/api/materials/$slideId/impressions';

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
    final slideId = widget.presentation.slideId;
    final url = '$ngrokUrl/api/materials/$slideId/comments';
    final headers = <String, String>{'content-type': 'application/json'};
    final body = json.encode({'text': '$text', 'number': _currentPage});

    print('body: $body');

    final resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 422) {
      final jsonResponse = json.decode(resp.body) as Map<String, dynamic>;
      setState(() {
        _comments.add(Comment.fromJson(jsonResponse));
      });
      print('Failed to post $jsonResponse');
    } else {
      final statusCode = resp.statusCode;
      print('Failed to post $statusCode');
    }
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