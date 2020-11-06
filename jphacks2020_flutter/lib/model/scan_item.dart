class ScanItem {
  ScanItem.fromMap(Map map) {
    title = map[columnTitle] as String;
    author = map[columnAuthor] as String;
    date = DateTime.parse(map[columnDate] as String).toLocal();
    url = map[columnUrl] as String;
  }

  ScanItem.fromScan(this.title, this.author, this.date, this.url);

  String title;
  String author;
  DateTime date;
  String url;

  static const String columnTitle = 'title';
  static const String columnAuthor = 'author';
  static const String columnDate = 'date';
  static const String columnUrl = 'url';

  Map<String, String> toMap() => {
        columnTitle: title,
        columnAuthor: author,
        columnDate: date.toUtc().toIso8601String(),
        columnUrl: url
      };
}
