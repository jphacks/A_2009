import 'package:http/http.dart' as http;

class ApiClient extends http.BaseClient {
  factory ApiClient() => _instance ??= ApiClient._internal();

  ApiClient._internal();

  static ApiClient _instance;

  final _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['User-Agent'] = 'Sample Flutter App.';
    print('----- API REQUEST ------');
    print(request.toString());
    if (request is http.Request && request.body.isNotEmpty) {
      print(request.body);
    }

    return _inner.send(request);
  }

  /// APIコール
  Future<http.Response> getPosts(String url) async {
    // APIサーバアクセス
    // const url = 'https://jsonplaceholder.typicode.com/posts';
    return get(url);
  }
}



// class SampleService extends http.BaseClient {
//   static SampleService _instance;
//
//   final _inner = http.Client();
//
//   factory SampleService() => _instance ??= SampleService._internal();
//
//   SampleService._internal();
//
//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) async {
//     request.headers['User-Agent'] = 'Sample Flutter App.';
//     print('----- API REQUEST ------');
//     print(request.toString());
//     if (request is http.Request && request.body.length > 0) {
//       print(request.body);
//     }
//
//     return _inner.send(request);
//   }
//
//   /// APIコール
//   Future<http.Response> getPosts() async {
//       // APIサーバアクセス
//       final url = 'https://jsonplaceholder.typicode.com/posts';
//       return get(url);
//   }
// }
//
// class Post {
//   Post(this.userId, this.id, this.title, this.body);
//
//   // Named constructor
//   Post.fromJson(Map<String, dynamic> json) {
//     userId = json['userId'] as int;
//     id = json['id'] as int;
//     title = json['title'] as String;
//     body = json['body'] as String;
//   }
//
//   int userId;
//   int id;
//   String title;
//   String body;
// }
