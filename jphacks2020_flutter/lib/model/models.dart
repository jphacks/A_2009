import 'package:intl/intl.dart';

class Comment {
  Comment(this.commentId, this.text, this.index, this.plus);

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['uuid'] as String;
    text = json['text'] as String;
    index = json['number'] as int;
    plus = json['count'] as int;
  }

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

  String slideId;
  List<Comment> comments = <Comment>[];
  String url;
  String title;
  DateTime date;
  String author;
}

const ngrokUrl = 'https://52e9bd550f9f.ngrok.io';
DateFormat dateFormat = DateFormat('yyyy/MM/dd');
