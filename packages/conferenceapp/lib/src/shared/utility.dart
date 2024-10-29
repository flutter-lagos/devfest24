import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

Future<void> launchWebUrl(String path) async {
  final uri = Uri.parse(path);

  if (!await launchUrl(uri)) {
    log('Failed to launch url');
  }
}
