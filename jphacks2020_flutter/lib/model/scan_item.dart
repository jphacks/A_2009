class ScanItem {
  ScanItem.fromMap(Map map) {
    text = map[columnText] as String;
  }

  ScanItem.fromQR(this.text);

  String text;

  static const String columnText = 'text';

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{columnText: text};
    return map;
  }
}
