import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:jphacks2020/model/api_client.dart';

import '../model/models.dart';

class SecondView extends StatefulWidget {
  const SecondView({Key key, @required this.presentation, @required this.url})
      : super(key: key);

  final Presentation presentation;
  final String url;

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  final commentController = TextEditingController();
  final minuteController = TextEditingController();
  List<Comment> _comments = <Comment>[];
  int _currentPage = 0;

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
        title: Text(widget.presentation.title),
        actions: <Widget>[
          SizedBox(
            width: 60,
            child: FlatButton(
              child: const Icon(Icons.refresh),
              onPressed: () {
                _reload();
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: (constraints.maxHeight - 50) / 3,
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
                            height: (constraints.maxHeight - 50) * 2 / 3,
                            child: ListView.separated(
                              itemCount: _comments.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                color: Colors.black,
                              ),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  // tileColor: Colors.white,
                                  title: Text(_comments[index].text),
                                  trailing: SizedBox(
                                    width: 70,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.thumb_up),
                                          onPressed: () {
                                            setState(() {
                                              _comments[index].plus += 1;
                                            });
                                            _plus(_comments[index].commentId);
                                          },
                                          splashColor: Colors.blue,
                                        ),
                                        Text(
                                            // ignore: lines_longer_than_80_chars
                                            '${_comments[index].plus.toString()}'),
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
            );
          },
        ),
      ),
    );
  }

  Future _reload() async {
    await ApiClient().getPosts(widget.url).then((response) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        widget.presentation.comments =
            Presentation.fromJson(jsonResponse).comments;
        _comments = widget.presentation.comments
            .where((i) => i.index == _currentPage + 1)
            .toList();
      });
    });
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
    final body = json.encode({'text': '$text', 'number': _currentPage + 1});

    final resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 422) {
      final jsonResponse = json.decode(resp.body) as Map<String, dynamic>;
      final comment = jsonResponse['comment'] as Map<String, dynamic>;
      setState(() {
        widget.presentation.comments.insert(0, Comment.fromJson(comment));
        _comments = widget.presentation.comments
            .where((i) => i.index == _currentPage + 1)
            .toList();
      });
      print('$jsonResponse');
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
                FocusScope.of(context).unfocus();
                commentController.text = '';
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _alertDialog() {
    return AlertDialog(
      title: const Text('感想'),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('もっと知りたい'),
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    _impression('know_more');
                    Navigator.pop(context);
                  },
                  splashColor: Colors.red,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('とても勉強になった'),
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    _impression('good');
                    Navigator.pop(context);
                  },
                  splashColor: Colors.red,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('面白かった'),
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    _impression('interseting');
                    Navigator.pop(context);
                  },
                  splashColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
