import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:imgbb_uploader/src/component/xfile_grid.dart';

import '../component/platform_error.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<XFile> xfiles = [];

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      const animationDuration = Duration(
        milliseconds: 250,
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text('Hello'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: animationDuration,
                  child: Builder(builder: (context) {
                    if (xfiles.isEmpty) {
                      return fileSelectButton();
                    } else {
                      return Column(
                        children: [
                          Expanded(
                            child: XFileGrid(
                              key: ValueKey(xfiles.length),
                              xfiles: xfiles,
                            ),
                          ),
                          fileSelectButton()
                        ],
                      );
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _onUploadButtonPressed,
                  child: Text('upload!'),
                ),
              )
            ],
          ),
          // child: DragTargetWidget(),
        ),
      );
    } else {
      return const PlatformErrorPage();
    }
  }

  Widget fileSelectButton() {
    return Center(
      child: ElevatedButton(
        child: const Text(
          '파일 선택',
          style: TextStyle(fontSize: 24),
        ),
        onPressed: _onFileSelectButtonPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 200),
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  _onFileSelectButtonPressed() async {
    final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png']);

    await openFile(acceptedTypeGroups: [typeGroup]).then(
      (value) => setState(() {
        if (value != null) xfiles.add(value);

        /// TODO : if null ?
      }),
    );
  }

  _onUploadButtonPressed() {}
}
