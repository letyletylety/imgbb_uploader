import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final upFilesProvider =
    StateNotifierProvider<UpFileList, FileList>((ref) => UpFileList());

class UpFileList extends StateNotifier<FileList> {
  UpFileList() : super(const FileList({}));

  bool addFile(XFile file) {
    final newState = {...state.files};
    final result = newState.add(file);
    state = FileList(newState);
    return result;
  }

  bool removeFile(XFile file) {
    final newState = {...state.files};
    final result = newState.remove(file);
    state = FileList(newState);
    return result;
  }

  void addMultiFiles(Iterable<XFile> files) {
    final newState = {...state.files};
    final result = newState.addAll(files);
    state = FileList(newState);
    return result;
  }

  clearFile() {
    state = const FileList({});
  }
}

class FileList extends Equatable {
  final Set<XFile> files;

  const FileList(this.files);

  @override
  List<Object?> get props => [files.length];
}
