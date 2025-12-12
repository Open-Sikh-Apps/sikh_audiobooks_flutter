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
    required this.disconnected,
  });
  final String keyString;
  final String? localImagePath;
  final double width;
  final double height;
  final void Function() onVisible;
  final void Function() onHidden;
  final bool disconnected;

  @override
  Widget build(BuildContext context) {
    final currentLocalImagePath = localImagePath;
    final currentDisconnected = disconnected;

    return (currentDisconnected && (currentLocalImagePath == null))
        ? Container(
            width: width,
            height: height,
            color: ColorScheme.of(context).secondary,
            alignment: AlignmentGeometry.center,
            child: Icon(
              Icons.broken_image,
              color: ColorScheme.of(context).onSecondary,
            ),
          )
        : VisibilityDetector(
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
                      errorBuilder: (context, error, stackTrace) => Placeholder(
                        fallbackHeight: height,
                        fallbackWidth: width,
                      ),
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
