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
