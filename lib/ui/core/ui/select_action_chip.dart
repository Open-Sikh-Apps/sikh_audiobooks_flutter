import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';

class SelectActionChip<T> extends StatelessWidget {
  SelectActionChip({
    super.key,
    required this.icon,
    required this.title,
    required this.selectionSheetTitle,
    required this.selectedValue,
    required this.options,
    required this.onSubmitted,
  });

  final Icon icon;
  final String title;
  final T selectedValue;
  final String selectionSheetTitle;
  final List<SelectActionChipOption<T>> options;
  final void Function(T) onSubmitted;
  final _log = Logger();

  @override
  Widget build(BuildContext context) {
    String selectionTitle;
    try {
      selectionTitle = options
          .firstWhere((option) => (selectedValue == option.value))
          .title;
    } catch (e) {
      _log.d(
        "selectedValue:$selectedValue\nnot found in options: $options",
        error: e,
      );
      selectionTitle = AppLocalizations.of(context)?.labelNotSelected ?? "";
    }
    return ActionChip(
      label: Text(
        title + Constants.titleSeparaterSelectActionChip + selectionTitle,
      ),
      avatar: icon,
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          showDragHandle: true,
          context: context,
          builder: (context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      Dimens.bottomSheetTitlePadding,
                    ),
                    child: Text(
                      selectionSheetTitle,
                      style: TextTheme.of(context).titleMedium,
                    ),
                  ),
                  Divider(),
                  ...options.map(
                    (option) => ListTile(
                      title: Text(
                        option.title,
                        style: TextTheme.of(context).bodyMedium,
                      ),
                      onTap: () {
                        onSubmitted(option.value);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class SelectActionChipOption<T> {
  SelectActionChipOption({required this.value, required this.title});
  final T value;
  final String title;

  @override
  String toString() {
    return "$title:\t$value";
  }
}
