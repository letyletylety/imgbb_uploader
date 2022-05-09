import 'package:flutter/material.dart';

class PlatformErrorPage extends StatelessWidget {
  const PlatformErrorPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not MacOS'),
      ),
      body: const Center(
          // child: DragTargetWidget(),
          ),
    );
  }
}
