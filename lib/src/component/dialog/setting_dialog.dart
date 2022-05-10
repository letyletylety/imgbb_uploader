import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imgbb_uploader/src/provider/api_key.dart';

import 'app_about_dialog.dart';

class SettingsDialog extends HookConsumerWidget {
  const SettingsDialog({Key? key, this.title = 'API KEY 설정'}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String apiKey = ref.watch(apiKeyProvider);
    final apiKeyInput = useTextEditingController();

    return AlertDialog(
      title: Stack(
        children: [
          Text(title),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Image.asset('assets/images/key_help_image.png'),
                        ),
                        const Divider(),
                        Wrap(
                          // mainAxisSize: MainAxisSize.min,
                          // runSpacing: 1.0,
                          // spacing: 1.0,
                          children: const [
                            InkWell(
                              onTap: launchApiHelp,
                              child: Text(
                                'https://api.imgbb.com/',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Text('에서 api 키를 확인하세요.'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
            ),
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(
                child: Text('현재 키'),
                width: 50,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Center(child: Text(apiKey)),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                child: Text('새 키'),
                width: 50,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                    autofocus: true,
                    controller: apiKeyInput,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              ref
                  .read(apiKeyProvider.notifier)
                  .changeApiKey(apiKeyInput.text)
                  .then((value) => Navigator.pop(context, true));
            },
            child: const Text('확인')),
      ],
    );
  }
}
