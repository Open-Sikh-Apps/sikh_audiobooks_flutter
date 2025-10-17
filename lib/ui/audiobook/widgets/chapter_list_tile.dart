import 'package:flutter/material.dart';
import 'package:not_static_icons/not_static_icons.dart';
import 'package:sikh_audiobooks_flutter/domain/models/api_duration/api_duration.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/viewmodels/chapter_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/chapter_ui_state/chapter_ui_state.dart';

class ChapterListTile extends StatefulWidget {
  const ChapterListTile({super.key, required this.chapterUiState});
  final ChapterUiState chapterUiState;

  @override
  State<ChapterListTile> createState() => _ChapterListTileState();
}

class _ChapterListTileState extends State<ChapterListTile> {
  late final ChapterViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ChapterViewModel(
      audiobooksRepository: getIt(),
      id: widget.chapterUiState.chapter.id,
    );
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  void showChapterBottomSheet(BuildContext context) {
    final locale = Localizations.localeOf(context);
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.bottomSheetTitlePadding),
                child: Text(
                  widget.chapterUiState.chapter.name[locale.languageCode] ?? "",
                  style: TextTheme.of(context).titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(),
              if (widget.chapterUiState.chapter.localAudioPath != null)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text(
                    AppLocalizations.of(context)?.labelRemoveDownload ?? "",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.removeDownloadCommand();
                  },
                )
              else
                ListTile(
                  leading: Icon(Icons.download),
                  title: Text(
                    AppLocalizations.of(context)?.labelDownload ?? "",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.downloadCommand();
                  },
                ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text(AppLocalizations.of(context)?.labelShare ?? ""),
                onTap: () {
                  Navigator.pop(context);
                  // onShare();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Material(
      child: InkWell(
        onTap: () {
          viewModel.playCommand();
          //TODO navigate to play screen
        },
        onLongPress: () => (showChapterBottomSheet(context)),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: Dimens.chapterListItemPaddingHorizontal,
            vertical: Dimens.chapterListItemPaddingVertical,
          ),
          child: Row(
            spacing: Dimens.paddingHorizontal2XS,
            children: [
              if (widget.chapterUiState.isPlaying)
                AudioLinesIcon(
                  size: Dimens.chapterListItemPlayingIconSize,
                  infiniteLoop: true,
                  enableTouchInteraction: false,
                )
              else
                SizedBox(width: Dimens.chapterListItemPlayingIconSize),
              Expanded(
                child: Column(
                  spacing: Dimens.paddingVertical2XS,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chapterUiState.chapter.name[locale.languageCode] ??
                          "",
                      style: TextTheme.of(context).bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.chapterUiState.chapter.localAudioPath != null)
                      Icon(Icons.download_done),
                  ],
                ),
              ),
              Row(
                spacing: Dimens.paddingHorizontal2XS,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.chapterUiState.chapter.duration.toDurationString(),
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  IconButton(
                    iconSize: Dimens.chapterListItemIconSize,
                    icon: Icon(Icons.more_vert),
                    onPressed: () => (showChapterBottomSheet(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
