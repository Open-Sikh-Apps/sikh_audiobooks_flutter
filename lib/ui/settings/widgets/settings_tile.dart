import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';

class SettingsTile<T> extends StatelessWidget {
  SettingsTile({
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
  final List<SettingsTileOption<T>> options;
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

    return ListTile(
      leading: icon,
      title: Text(title, style: TextTheme.of(context).bodyLarge),
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Dimens.paddingHorizontal,
        children: [
          Text(
            selectionTitle,
            style: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: ColorScheme.of(context).secondary),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
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
                      leading: option.icon,
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

class SettingsTileOption<T> {
  SettingsTileOption({required this.value, required this.title, this.icon});
  final T value;
  final String title;
  final Icon? icon;

  @override
  String toString() {
    return "$title:\t$value\nIcon:$icon";
  }
}
