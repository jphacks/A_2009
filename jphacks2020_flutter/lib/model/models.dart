import 'package:uuid/uuid.dart';

class Comment {
  Comment(this.commentId, this.text, this.index, this.plus);

  Comment.newComment({String newText}) {
    commentId = Uuid().v4();
    text = newText;
  }

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['uuid'] as String;
    text = json['text'] as String;
    index = json['number'] as int;
    plus = json['count'] as int;
  }

  // static const String columnUuid = 'uuid';
  // static const String columnCount = 'count';
  // static const String columnText = 'text';
  // static const String columnIndex = 'number';

  String commentId;
  String text;
  int index;
  int plus;
}

class Presentation {
  Presentation(this.slideId, this.comments, this.url, this.title, this.date,
      this.author);

  Presentation.fromJson(Map<String, dynamic> json) {
    slideId = json['material']['uuid'] as String;

    for (final comment in json['comments'].cast<Map<String, dynamic>>()
        as List<Map<String, dynamic>>) {
      comments.add(Comment.fromJson(comment));
    }
    url = json['material']['url'] as String;
    title = json['material']['title'] as String;
    date = DateTime.now();
    author = json['material']['author'] as String;
  }

  // static const String columnUuid = 'uuid';
  // static const String columnUrl = 'url';
  // static const String columnTitle = 'title';
  // static const String columnAuthor = 'author';
  // static const String columnComments = 'comments';

  String slideId;
  List<Comment> comments = <Comment>[];
  String url;
  String title;
  DateTime date;
  String author;
}

// getLocalTestJSONData();

// Presentation _presentation;
// final _comments = <Comment>[];

// Future<String> _loadAVaultAsset() async {
//   return rootBundle.loadString('json/api_name.json');
// }
//
// Future getLocalTestJSONData() async {
//   final jsonString = await _loadAVaultAsset();
//   setState(() {
//     final dynamic jsonResponse = json.decode(jsonString);
//     for (final comment in jsonResponse['comments']) {
//       _comments.add(Comment.fromJson(comment));
//     }
//
//     _presentation = Presentation(
//         jsonResponse['material']['uuid'] as String,
//         _comments,
//         jsonResponse['material']['title'] as String,
//         DateTime.now(),
//         jsonResponse['material']['author'] as String);
//   });
// }
