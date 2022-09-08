import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppAboutDialog extends StatelessWidget {
  const AppAboutDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationIcon: Image.asset(
        'assets/images/app_logo.png',
        width: 48,
        height: 48,
        cacheHeight: 256,
        cacheWidth: 256,
      ),
      applicationName: 'imgbb_uploader',
      applicationVersion: '1.0',
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
        Text('에 있는 공식 api를 사용합니다.'),
      ],
      // applicationIcon: ,
    );
  }
}

void launchApiHelp() {
  var uri = Uri.https('api.imgbb.com', '');
  canLaunchUrl(uri).then(
    (value) => launchUrl(uri),
  );
}
