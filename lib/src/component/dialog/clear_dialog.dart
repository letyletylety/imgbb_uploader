import 'package:flutter/material.dart';

class ClearDialog extends StatelessWidget {
  const ClearDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('전부 지울까요?'),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop<bool>(context, true);
          },
          child: const Text('네'),
        )
      ],
    );
  }
}
