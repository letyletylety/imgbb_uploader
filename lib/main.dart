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
  // const apiKey = String.fromEnvironment('API_KEY');

  runApp(
    const ProviderScope(
      overrides: [
        // apiKeyProvider.overrideWithValue(
        //   apiKey,
        // ),
      ],
      child: App(),
      observers: [],
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)),
      home: const HomePage(),
    );
  }
}
