import 'package:flutter/services.dart';

Future<void> lockOrientationPortrait() {
  return SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
