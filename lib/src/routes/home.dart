import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:imgbb_uploader/main.dart';
import 'package:imgbb_uploader/src/component/dialog/dialog.dart';
import 'package:imgbb_uploader/src/component/xfile_grid.dart';
import 'package:imgbb_uploader/src/provider/api_key.dart';
import 'package:imgbb_uploader/src/provider/upfile_list.dart';

import '../component/platform_error.dart';

// final homeKeyProvider = Provider<GlobalKey>((ref) => GlobalKey());

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Set<XFile> xfiles = {};

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS || Platform.isWindows) {
      return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final xfiles = ref.watch(upFilesProvider);
          // final keyy = ref.watch(homeKeyProvider);

          return Scaffold(
            // key: keyy,
            appBar: AppBar(
              title: const Text('Imgbb uploader'),
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AppAboutDialog(),
                    );
                  },
                  icon: const Icon(Icons.info),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const SettingsDialog(),
                    );
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
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
                                      tooltip: '모두 지우기',
                                      // splashColor: Colors.blue,
                                      onPressed: () async {
                                        final bool result =
                                            await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) =>
                                                      const ClearDialog(),
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
                                      icon: const Icon(Icons.clear_all),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                  ),
                  if (xfiles.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _onUploadButtonPressed(context, ref);
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

  _onUploadButtonPressed(BuildContext context, WidgetRef ref) async {
    // const apiKey = String.fromEnvironment('API_KEY');
    final apiKey = ref.watch(apiKeyProvider);

    if (apiKey == "") {
      showDialog<bool>(
          context: context,
          builder: (context) => const SettingsDialog()).then((value) {
        if (value == true) {
          return _onUploadButtonPressed(context, ref);
        }
      });
      return;
    }

    Set<XFile> upfiles = ref.watch(upFilesProvider);

    for (var file in upfiles) {
      // TODO : 이미지 byte 를 한번만 저장하는게 좋음. 이미지를 보여주기 위한 데이터를 활용할 것
      // WARNING: 임시 코드
      final imageByte = await file.readAsBytes();
      String base64encodedImage = base64Encode(imageByte);

      http.Response resp = await ref.read(imgbbProvider).upload(
            apiKey,
            // imageByte.toString(),n
            base64encodedImage,
          );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(resp.body),
        ),
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
          '파일 추가',
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
