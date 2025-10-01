import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VisibilityDetectorImage extends StatelessWidget {
  const VisibilityDetectorImage({
    super.key,
    required this.keyString,
    this.localImagePath,
    required this.width,
    required this.height,
    required this.onVisible,
    required this.onHidden,
  });
  final String keyString;
  final String? localImagePath;
  final double width;
  final double height;
  final void Function() onVisible;
  final void Function() onHidden;

  @override
  Widget build(BuildContext context) {
    final currentLocalImagePath = localImagePath;

    return VisibilityDetector(
      key: Key(keyString),
      child: AnimatedSwitcher(
        duration: Constants.animatedSwitcherDuration,
        child: (currentLocalImagePath == null)
            ? Skeletonizer.zone(
                child: Bone(width: width, height: height),
              )
            : Image.file(
                File(currentLocalImagePath),
                width: width,
                height: height,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Placeholder(fallbackHeight: height, fallbackWidth: width),
              ),
      ),
      onVisibilityChanged: (visibilityInfo) {
        if (localImagePath == null) {
          if (visibilityInfo.visibleFraction > 0) {
            onVisible();
          } else {
            onHidden();
          }
        }
      },
    );
  }
}
