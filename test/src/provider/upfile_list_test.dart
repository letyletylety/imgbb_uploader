import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imgbb_uploader/src/provider/upfile_list.dart';

void main() {
  test('upFileprovider  test', () {
    final container = ProviderContainer(overrides: []);
    addTearDown(container.dispose);

    final files = container.read(upFilesProvider);
    expect(files.files.length, 0);

    container.read(upFilesProvider.notifier).addFile(XFile('./123123'));

    final files2 = container.read(upFilesProvider);
    expect(files2.files.length, 1);
  });
}
