import 'dart:developer';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imgbb_uploader/src/component/image_card.dart';
import 'package:imgbb_uploader/src/provider/upfile_list.dart';

class XFileGrid extends StatelessWidget {
  const XFileGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final xfiles = ref.watch(upFilesProvider);

        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(
            child: Wrap(
              children: xfiles
                  .map(
                    // (e) => Text(e.path),
                    (e) => FileImage(
                      xfile: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class FileImage extends StatefulWidget {
  const FileImage({Key? key, required this.xfile}) : super(key: key);

  final XFile xfile;

  @override
  State<FileImage> createState() => _FileImageState();
}

class _FileImageState extends State<FileImage> {
  late Future<Uint8List> readAsBytesFuture;

  @override
  void initState() {
    super.initState();
    readAsBytesFuture = widget.xfile.readAsBytes();
    log('file image ${widget.xfile.name}');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // decoration: BoxDecoration(border: Border.all()),
      width: 150,
      height: 150,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
              future: readAsBytesFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      Uint8List data = snapshot.data as Uint8List;
                      return ImageCard(
                        xfile: widget.xfile,
                        // fileName: widget.xfile.name,
                        data: data,
                      );
                    }
                    if (snapshot.hasError) {
                      return Stack(
                        children: const [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ],
                      );
                    }
                    break;
                }
                return Container();
              }),
          // Text(
          //   widget.xfile.name,
          //   softWrap: true,
          // ),
        ],
      ),
    );
  }
}
