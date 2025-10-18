import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';

Future<void> lockOrientationPortrait() {
  return SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

void showSnackbar(
  BuildContext context,
  String message, {
  Duration duration = Constants.defaultSnackbarDuration,
}) {
  ScaffoldMessenger.maybeOf(
    context,
  )?.showSnackBar(SnackBar(content: Text(message), duration: duration));
}
