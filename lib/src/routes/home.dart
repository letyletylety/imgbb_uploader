import 'dart:developer';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imgbb_uploader/src/component/xfile_grid.dart';
import 'package:imgbb_uploader/src/provider/upfile_list.dart';

import '../component/platform_error.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Set<XFile> xfiles = {};

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      const animationDuration = Duration(
        milliseconds: 250,
      );

      return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final xfiles = ref.watch(upFilesProvider);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Hello'),
            ),
            body: Center(
              child: Column(
                children: [
                  Expanded(
                    child: xfiles.isEmpty
                        ? const FileSelectButton(
                            size: 200,
                            fontSize: 24,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Expanded(
                                  child: XFileGrid(
                                      // key: ValueKey(xfiles.length),
                                      // xfiles: xfiles,
                                      ),
                                ),
                                Stack(
                                  children: [
                                    const FileSelectButton(
                                      size: 100,
                                      fontSize: 12,
                                    ),
                                    // fileSelectButton(100),
                                    IconButton(
                                      splashColor: Colors.blue,
                                      onPressed: () {
                                        ref
                                            .read(upFilesProvider.notifier)
                                            .clearFile();
                                        // .update((state) => {});
                                        // .state
                                        // .clear();
                                        // setState(() {
                                        //   xfiles.clear();
                                        // });
                                      },
                                      icon: const Icon(Icons.clear),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _onUploadButtonPressed,
                        child: const Text('upload!'),
                      ),
                    ),
                  )
                ],
              ),
              // child: DragTargetWidget(),
            ),
          );
        },
      );
    } else {
      return const PlatformErrorPage();
    }
  }

  // Widget fileSelectButton(
  //   double size, {
  //   double fontSize = 24,
  // }) {
  //   if (size == 100) {
  //     fontSize = 12;
  //   }

  //   return Center(
  //     child: ElevatedButton(
  //       child: Text(
  //         '파일 선택',
  //         style: TextStyle(fontSize: fontSize),
  //       ),
  //       onPressed: _onFileSelectButtonPressed,
  //       style: ElevatedButton.styleFrom(
  //         fixedSize: Size(size, size),
  //         shape: const CircleBorder(),
  //       ),
  //     ),
  //   );
  // }

  _onUploadButtonPressed() {}
}

class FileSelectButton extends StatelessWidget {
  const FileSelectButton({
    Key? key,
    this.fontSize = 24,
    this.size = 200,
  }) : super(key: key);

  final double fontSize;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return ElevatedButton(
            child: child,
            onPressed: () => _onFileSelectButtonPressed(ref),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(size, size),
              shape: const CircleBorder(),
            ),
          );
        },
        child: Text(
          '파일 선택',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }

  _onFileSelectButtonPressed(WidgetRef ref) async {
    // final xFileController = ref.read(xFilesProvider.notifier);

    final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png']);

    await openFile(acceptedTypeGroups: [typeGroup]).then(
      (value) {
        if (value != null) {
          bool result = ref.read(upFilesProvider.notifier).addFile(value);
          if (result) {
            log('add file');
          } else {
            log('?');
          }

          // state.add(value);
        }

        /// : if null ?
      },
    );
  }
}
