import 'dart:developer';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imgbb_uploader/src/provider/upfile_list.dart';
import 'package:logger/logger.dart';

// final selectedFileProvider = StateProvider<XFile>((ref) {
//   return XFile('');
// });

class ImageCard extends HookConsumerWidget {
  const ImageCard({
    Key? key,
    required this.data,
    // required this.fileName,
    required this.xfile,
  }) : super(key: key);

  final Uint8List data;
  // final String fileName;
  final XFile xfile;

  @override
  Widget build(BuildContext context, ref) {
    final fileName = xfile.name;

    final isHover = useState(false);
    final isShowInfo = useState(false);

    const animationDuration = Duration(milliseconds: 250);

    return GestureDetector(
      onTap: () => isShowInfo.value = !isShowInfo.value,
      child: MouseRegion(
        // onEnter: (e) {
        //   isHover.value = true;
        // },
        onExit: (e) {
          isHover.value = false;
        },
        onHover: (e) {
          isHover.value = true;
        },
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CardContent(
                isShowInfo: isShowInfo,
                animationDuration: animationDuration,
                data: data,
                fileName: fileName,
              ),
              // if (isHover.value)
              ClearButton(
                animationDuration: animationDuration,
                isHover: isHover,
                removeCallback: () {
                  l('clear');
                  final result =
                      ref.read(upFilesProvider.notifier).removeFile(xfile);
                  l(result);
                },
              ),
              // if (isHover.value)
              // InfoButton(
              //   animationDuration: animationDuration,
              //   isHover: isHover,
              //   showInfoCallback: () {
              //     l('showInfo');
              //     isHover.value = !isHover.value;
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}

void l(dynamic s, [Level? level]) {
  Logger(
      level: level,
      printer: PrettyPrinter(
        methodCount: 0,
      )).d(s);
}

class InfoButton extends StatelessWidget {
  const InfoButton({
    Key? key,
    required this.animationDuration,
    required this.isHover,
    required this.showInfoCallback,
  }) : super(key: key);

  final Duration animationDuration;
  final ValueNotifier<bool> isHover;
  final Function() showInfoCallback;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedOpacity(
        curve: Curves.easeIn,
        duration: animationDuration,
        opacity: isHover.value ? 1 : 0,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Center(
            child: MaterialButton(
              color: const Color.fromARGB(255, 0, 76, 139),
              onPressed: () {
                log('message');
              },
              child: const Icon(
                Icons.info_outline,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClearButton extends StatelessWidget {
  const ClearButton({
    Key? key,
    required this.animationDuration,
    required this.isHover,
    required this.removeCallback,
  }) : super(key: key);

  final Duration animationDuration;
  final ValueNotifier<bool> isHover;
  final Function() removeCallback;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: AnimatedOpacity(
        curve: Curves.easeIn,
        duration: animationDuration,
        opacity: isHover.value ? 1 : 0,
        child: SizedBox(
          width: 30,
          height: 30,
          child: MaterialButton(
            color: Colors.lightBlue[900],
            // shape: const CircleBorder(),
            onPressed: removeCallback,
            // () {
            //   ref.read(upFilesProvider.notifier).remove();
            //   // log('message');
            // },
            child: const Center(
              child: Icon(
                Icons.clear,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({
    Key? key,
    required this.isShowInfo,
    required this.animationDuration,
    required this.data,
    required this.fileName,
  }) : super(key: key);

  final ValueNotifier<bool> isShowInfo;
  final Duration animationDuration;
  final Uint8List data;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.zero,
      child: AnimatedCrossFade(
        crossFadeState: isShowInfo.value
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: animationDuration,
        firstCurve: Curves.easeIn,
        firstChild: Image.memory(
          data,
          cacheHeight: 150,
          cacheWidth: 150,
        ),
        secondChild: Center(
          child: Text(
            fileName,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
