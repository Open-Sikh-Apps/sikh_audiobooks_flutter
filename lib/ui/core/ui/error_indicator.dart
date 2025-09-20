// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    super.key,
    required this.title,
    required this.label,
    required this.onPressed,
  });

  final String title;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: Padding(
            padding: EdgeInsets.all(Dimens.errorIndicationIconTitlePadding),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.error),
                  const SizedBox(width: Dimens.paddingVertical),
                  Text(title, style: TextTheme.of(context).bodyLarge),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: Dimens.paddingVertical),
        FilledButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              ColorScheme.of(context).error,
            ),
            foregroundColor: WidgetStatePropertyAll(
              ColorScheme.of(context).onError,
            ),
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
