import 'package:flutter/material.dart';

class PlatformErrorPage extends StatelessWidget {
  const PlatformErrorPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not MacOS'),
      ),
      body: Center(
          // child: DragTargetWidget(),
          ),
    );
  }
}
