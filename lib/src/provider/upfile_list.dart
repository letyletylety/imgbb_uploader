import 'package:file_selector/file_selector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final upFilesProvider =
    StateNotifierProvider<UpFileList, Set<XFile>>((ref) => UpFileList());

class UpFileList extends StateNotifier<Set<XFile>> {
  UpFileList() : super({});

  bool addFile(XFile file) {
    final result = state.add(file);
    state = {...state};
    return result;
  }

  bool removeFile(XFile file) {
    final result = state.remove(file);

    state = {...state};
    // if (state.contains(file)) {
    // }
    return result;
  }

  clearFile() {
    state = {};
  }
}
