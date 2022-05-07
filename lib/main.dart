import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/src/client.dart';
import 'package:imgbb_uploader/src/service/imgbb.dart';

import 'package:http/http.dart' as http;

import 'src/routes/home.dart';

final ImgbbProvider = Provider<ImageBB>((ref) {
  http.Client httpClient = http.Client();
  var imageBB = ImageBB(httpClient);
  return imageBB;
});

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
