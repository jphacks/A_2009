import 'package:uuid/uuid.dart';

class Comment {
  Comment(this.commentId, this.text, this.index, this.plus);

  Comment.newComment({String newText}) {
    commentId = Uuid().v4();
    text = newText;
  }

  static const String columnUuid = 'uuid';
  static const String columnCount = 'count';
  static const String columnText = 'text';
  static const String columnIndex = 'number';

  String commentId;
  String text;
  int index;
  int plus;
}

class Presentation {
  Presentation(this.slideId, this.comments, this.url, this.title, this.date,
      this.author);

  static const String columnUuid = 'uuid';
  static const String columnUrl = 'url';
  static const String columnTitle = 'title';
  static const String columnAuthor = 'author';
  static const String columnComments = 'comments';

  String slideId;
  List<Comment> comments;
  String url;
  String title;
  DateTime date;
  String author;
}

// getLocalTestJSONData();

// Presentation _presentation;
// final _comments = <Comment>[];
//
// Future<String> _loadAVaultAsset() async {
//   return rootBundle.loadString('json/api_name.json');
// }
//
// Future getLocalTestJSONData() async {
//   final jsonString = await _loadAVaultAsset();
//   setState(() {
//     final dynamic jsonResponse = json.decode(jsonString);
//     for (final comment in jsonResponse['comments']) {
//       _comments.add(Comment(
//           comment['uuid'] as String,
//           comment['text'] as String,
//           comment['number'] as int,
//           comment['count'] as int));
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
