import 'package:http/http.dart' as http;

class ApiClient extends http.BaseClient {
  factory ApiClient() => _instance ??= ApiClient._internal();

  ApiClient._internal();

  static ApiClient _instance;

  final _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['User-Agent'] = 'Sample Flutter App.';
    if (request is http.Request && request.body.isNotEmpty) {
      print(request.body);
    }

    return _inner.send(request);
  }

  /// APIコール
  Future<http.Response> getPosts(String url) async {
    return get(url);
  }
}
