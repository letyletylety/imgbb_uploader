import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

/// fake httpClient
class FakeHttpClient implements http.Client {
  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var rand = Random.secure().nextInt(10);

    if (rand == 1) {
      /// 10 % error
      var exampleJson =
          File('lib/src/service/example_error_resp.json').readAsStringSync();
      final http.Response exampleErrorResp = http.Response(exampleJson, 400);

      var future = Future.delayed(
          const Duration(milliseconds: 250), () => exampleErrorResp);
      return future;
    } else { 
      /// 90% right way
      var exampleJson =
          File('lib/src/service/example_resp.json').readAsStringSync();

      final http.Response exampleResp = http.Response(exampleJson, 200);

      var future =
          Future.delayed(const Duration(milliseconds: 250), () => exampleResp);
      return future;
    }
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
