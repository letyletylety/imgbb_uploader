import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imgbb_uploader/src/service/imgbb.dart';

import 'package:http/http.dart' as http;

import 'src/routes/home.dart';

final imgbbProvider = Provider<ImageBB>((ref) {
  http.Client httpClient = http.Client();
  var imageBB = ImageBB(httpClient);
  return imageBB;
});

void main() {
  runApp(const ProviderScope(child: App()));
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
