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
  final items = List<String>.generate(5, (i) => "comment $i");

  final myContoller = TextEditingController();

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
              child: Icon(Icons.thumb_up),
              onPressed: () {
                //全体の感想を入力できる枠が出てくる
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: TextField(
                        controller: myContoller,
                        decoration: InputDecoration(
                          hintText: "コメントや質問を入力してね",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              print(myContoller.text);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(height: 400,
              child: Center(
                  child: _isInit
                      ? const Text('please load PDF')
                      : _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PDFViewer(document: _document)),
            ),
            Container(
              child: TextField(
                controller: myContoller,
                decoration: InputDecoration(
                    hintText: "コメントや質問を入力してね",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        print(myContoller.text);
                      },
                    ),
                ),
              ),
            ),
            Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black,),
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(items[index]),
                      trailing: FlatButton(
                        child: Icon(Icons.thumb_up),
                        onPressed: () {
                          //感想に+1がつく
                        },
                      ),
                    );
                  },
                ),
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
