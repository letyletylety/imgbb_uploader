import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

/// imagebb api
/// key (required)
/// The API key.
/// image (required)
/// A binary file, base64 data, or a URL for an image. (up to 32 MB)
/// name (optional)
/// The name of the file, this is automatically detected if uploading a file with a POST and multipart / form-data
/// expiration (optional)
/// Enable this if you want to force uploads to be auto deleted after certain time (in seconds 60-15552000)
class ImageBB {
  const ImageBB(this.httpClient);

  // request using  this client
  final http.Client httpClient;

  final apiUrl = "https://api.imgbb.com/1/upload";

// API v1 calls can be done using the POST or GET request methods but since GET request are limited by the maximum allowed length of an URL you should prefer the POST request method.

  Future upload(
    String apiKey,
    String image, [
    int? expiration,
    String? name,
  ]) async {
    final http.Response resp = await _post(apiKey, image, expiration, name);

    switch (resp.statusCode) {
      case 200:
        bool isSuccess = await _convert(resp);
        break;
      case 400:
        handle400(resp);
        break;
      default:
    }

    // if (resp.statusCode == 200) {
    //   return isSuccess;
    // } else {}
  }

  Future<http.Response> _post(
    String apiKey,
    String image, [
    int? expiration,
    String? name,
  ]) async {
    Map<String, String> queryParameters = {
      'key': apiKey,
      // 'image': image,
    };
    if (expiration != null) {
      if (expiration >= 60 && expiration <= 15552000) {
        queryParameters.addAll({'expiration': expiration.toString()});
      } else {
        log('expiration is not in range [60, 15552000]');
      }
    }

    if (name != null) {
      queryParameters.addAll({'name': name});
    }

    var reqUrl = Uri.https(
      'api.imgbb.com',
      '/1/upload',
      queryParameters,
    );

    final http.Response resp = await httpClient.post(
      reqUrl,
      body: image,
      headers: <String, String>{
        'Content-Type': 'multipart/form-data',
      },
    );
    return resp;
  }

  Future handle400(resp) async {}

  /// return whether success or not
  Future<bool> _convert(http.Response response) async {
    final body = response.body;
    final data = await jsonDecode(body);

    final status = data['status'] as int;
    final success = data['success'] as bool;

    if (success == true && status == 200) {
      return true;
    }
    return false;
  }
}
