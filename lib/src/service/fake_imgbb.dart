import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// fake httpClient
class FakeHttpClient implements http.Client {
  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final params = url.queryParameters;

    if ((params['key'] ?? "").isNotEmpty) {
      /// 90% right way
      var exampleJson =
          File('lib/src/service/example_resp.json').readAsStringSync();

      final http.Response exampleResp = http.Response(exampleJson, 200);

      var future =
          Future.delayed(const Duration(milliseconds: 250), () => exampleResp);
      return future;
    } else {
      /// 10 % error
      var exampleJson =
          File('lib/src/service/example_error_resp.json').readAsStringSync();
      final http.Response exampleErrorResp = http.Response(exampleJson, 400);

      var future = Future.delayed(
          const Duration(milliseconds: 250), () => exampleErrorResp);
      return future;
    }
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
