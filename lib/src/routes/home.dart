import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imgbb_uploader/main.dart';
import 'package:imgbb_uploader/src/component/xfile_grid.dart';
import 'package:imgbb_uploader/src/provider/upfile_list.dart';

import '../component/platform_error.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Set<XFile> xfiles = {};

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
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
                                      onPressed: () async {
                                        final bool result =
                                            await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text('전부 지울까요?'),
                                                    actionsAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop<bool>(
                                                              context, true);
                                                        },
                                                        child: Text('네'),
                                                      )
                                                    ],
                                                  ),
                                                ) ??
                                                false;

                                        if (result == true) {
                                          ref
                                              .read(upFilesProvider.notifier)
                                              .clearFile();
                                        }
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
                        onPressed: () {
                          _onUploadButtonPressed(ref);
                        },
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

  _onUploadButtonPressed(WidgetRef ref) async {
    const apiKey = String.fromEnvironment('API_KEY');

    if (apiKey == "") {
      throw Exception('apiKey is missing');
    }

    Set<XFile> upfiles = ref.watch(upFilesProvider);

    for (var file in upfiles) {
      // TODO : 이미지 byte 를 한번만 저장하는게 좋음. 이미지를 보여주기 위한 데이터를 활용할 것
      // WARNING: 임시 코드
      final imageByte = await file.readAsBytes();
      String base64encodedImage = base64Encode(imageByte);

      await ref.read(imgbbProvider).upload(
            apiKey,
            // imageByte.toString(),
            base64encodedImage,
          );
    }
  }
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
