import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imgbb_uploader/src/component/image_card.dart';
import 'package:logger/logger.dart';

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

  Future<http.Response> upload(
    String apiKey,
    String image, [
    int? expiration,
    String? name,
  ]) async {
    l('post');
    final http.BaseResponse resp =
        await postMP(apiKey, image, expiration, name);

    final streamed = (resp as http.StreamedResponse);

    var response = await http.Response.fromStream(streamed);
    l(response.body);

    return response;

    // await handle(response);
    // if (resp.statusCode == 200) {
    //   l('uploaded!');

    //   return true;
    // } else {
    //   l(resp.statusCode, Level.error);
    // }
    // l('handle');
  }

  Future handle(http.Response resp) async {
    switch (resp.statusCode) {
      case 200:
        bool isSuccess = await handle200(resp);
        break;
      case 400:
        await handle400(resp);
        break;
      default:
    }
  }

  /// post multipart
  Future<http.BaseResponse> postMP(
    String apiKey,
    // XFile file,
    String image, [
    int? expiration,
    String? name,
  ]) async {
    Map<String, String> queryParameters = {
      'key': apiKey,
      // 'image': image,
    };
    // handle expiration
    if (expiration != null) {
      if (expiration >= 60 && expiration <= 15552000) {
        queryParameters.addAll({'expiration': expiration.toString()});
      } else {
        log('expiration is not in range [60, 15552000]');
      }
    }

    // handle name
    if (name != null) {
      queryParameters.addAll({'name': name});
    }

    /// make request Url
    var reqUrl = Uri.https(
      'api.imgbb.com',
      '/1/upload',
      queryParameters,
    );

    // final request = http.MultipartRequest('POST', reqUrl);
    // request.
    // request.files.add(value)
    final request = http.MultipartRequest('POST', reqUrl)
      ..fields['image'] = image;
    final resp = await httpClient.send(request);

    l(resp.statusCode);
    l(resp.reasonPhrase);

    // final http.Response resp = await httpClient.post(
    //   reqUrl,
    //   body: image,
    //   headers: <String, String>{
    //     'Content-Type': 'multipart/form-data',
    //   },
    // );
    return resp;
  }

  @Deprecated('')
  Future<http.Response> post(
    String apiKey,
    String image, [
    int? expiration,
    String? name,
  ]) async {
    Map<String, String> queryParameters = {
      'key': apiKey,
      'image': image,
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

    // final request = http.MultipartRequest('POST', reqUrl);
    // request.files.add(value)

    final http.Response resp = await httpClient.post(
      reqUrl,
      body: image,
      headers: <String, String>{
        'Content-Type': 'multipart/form-data',
      },
    );
    return resp;
  }

  Future handle400(http.Response resp) async {
    var data = await jsonDecode(resp.body);
    var error = data['error'];
    // var errorObj = await json.decode(error);
    var errorMsg = error['message'];

    Logger().e(errorMsg);
  }

  /// return whether success or not
  Future<bool> handle200(http.Response response) async {
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
