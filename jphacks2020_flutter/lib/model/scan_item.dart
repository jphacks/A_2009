class ScanItem {
  ScanItem.fromMap(Map map) {
    id = map[columnId] as int;
    text = map[columnText] as String;
  }

  ScanItem.fromQR(this.text);

  int id;
  String text;

  static const String columnId = 'id';
  static const String columnText = 'text';


  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{columnText: text};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
