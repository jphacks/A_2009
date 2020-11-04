// import 'dart:convert';

// import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';

class Comment {
  Comment(this.commentId, this.text, this.index, this.plus);

  Comment.newComment({String newText}) {
    commentId = Uuid().v4();
    text = newText;
  }

  String commentId;
  String text;
  int index;
  int plus;
}

class Presentation {
  Presentation(
      this.slideId, this.comments, this.title, this.date, this.author);

  String slideId;
  List<Comment> comments;
  String title;
  String date;
  String author;
}


// List<dynamic> _data;
//
// Future<String> _loadAVaultAsset() async {
//   return rootBundle.loadString('json/api_name.json');
// }
//
// Future getLocalTestJSONData() async {
//   final jsonString = await _loadAVaultAsset();
//   setState(() {
//     final dynamic jsonResponse = json.decode(jsonString);
//     print('### getLocalTestJSONData:$jsonResponse');
//     _data = jsonResponse['categorydata'] as List<dynamic>;
//   });
// }