import 'package:flutter_test/flutter_test.dart';
import 'package:imgbb_uploader/src/service/fake_imgbb.dart';
import 'package:imgbb_uploader/src/service/imgbb.dart';

void main() {
  test(
    'test mock imgbb',
    () async {
      for (var i = 0; i < 10; i++) {
        await fakePost();
      }
    },
  );

  test('descriptiohn', () async {
    final imgbb = ImageBB(FakeHttpClient());
    // imgbb.handle400(resp);
    var resp = await imgbb.post('apiKey', 'image');

    await imgbb.handle(resp);
  });
}

Future fakePost() async {
  final imgbb = ImageBB(FakeHttpClient());
  final upload =
      await imgbb.upload('this is mock key', 'this is beautiful image');
  // print(upload.toString());
}
