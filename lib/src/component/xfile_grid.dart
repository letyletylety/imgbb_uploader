import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class XFileGrid extends StatelessWidget {
  const XFileGrid({Key? key, required this.xfiles}) : super(key: key);

  final List<XFile> xfiles;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [],
    );
  }
}
