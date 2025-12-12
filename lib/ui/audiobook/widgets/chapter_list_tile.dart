import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:not_static_icons/not_static_icons.dart';
import 'package:sikh_audiobooks_flutter/domain/models/api_duration/api_duration.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/viewmodels/chapter_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/chapter_ui_state/chapter_ui_state.dart';
import 'package:watch_it/watch_it.dart';

class ChapterListTile extends WatchingStatefulWidget {
  const ChapterListTile({super.key, required this.chapterUiState});
  final ChapterUiState chapterUiState;

  @override
  State<ChapterListTile> createState() => _ChapterListTileState();
}

class _ChapterListTileState extends State<ChapterListTile> {
  late ChapterViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ChapterViewModel(
      audiobooksRepository: getIt(),
      id: widget.chapterUiState.chapter.id,
    );
  }

  @override
  void didUpdateWidget(covariant ChapterListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chapterUiState.chapter.id !=
        widget.chapterUiState.chapter.id) {
      viewModel.onDispose();
      viewModel = ChapterViewModel(
        audiobooksRepository: getIt(),
        id: widget.chapterUiState.chapter.id,
      );
    }
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  void showChapterBottomSheet(BuildContext context, bool disconnected) {
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
                  enabled: !disconnected,
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
                enabled: !disconnected,
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

    final internetStatus = watch(viewModel.internetStatusVN).value;
    final disconnected = internetStatus == InternetStatus.disconnected;

    final chapterUnavailable =
        ((widget.chapterUiState.chapter.localAudioPath == null) &&
        disconnected);
    return ListTile(
      horizontalTitleGap: Dimens.paddingHorizontal2XS,
      contentPadding: EdgeInsetsGeometry.symmetric(
        horizontal: Dimens.chapterListItemPaddingHorizontal,
        vertical: Dimens.chapterListItemPaddingVertical,
      ),
      enabled: !chapterUnavailable,
      onTap: () {
        viewModel.playCommand();
        //TODO navigate to play screen
      },
      onLongPress: () => (showChapterBottomSheet(context, disconnected)),
      minLeadingWidth: Dimens.chapterListItemPlayingIconSize,
      leading: (widget.chapterUiState.isPlaying)
          ? AudioLinesIcon(
              size: Dimens.chapterListItemPlayingIconSize,
              infiniteLoop: true,
              enableTouchInteraction: false,
            )
          : SizedBox(width: Dimens.chapterListItemPlayingIconSize),
      title: Text(
        widget.chapterUiState.chapter.name[locale.languageCode] ?? "",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: TextTheme.of(context).bodyMedium?.fontSize),
      ),
      subtitle: (widget.chapterUiState.chapter.localAudioPath != null)
          ? Icon(Icons.download_done)
          : null,
      trailing: Row(
        spacing: Dimens.paddingHorizontal2XS,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.chapterUiState.chapter.duration.toDurationString(),
            style: TextStyle(
              fontSize: TextTheme.of(context).bodyMedium?.fontSize,
            ),
          ),
          if (!chapterUnavailable)
            IconButton(
              iconSize: Dimens.chapterListItemIconSize,
              icon: Icon(Icons.more_vert),
              onPressed: () => (showChapterBottomSheet(context, disconnected)),
            ),
        ],
      ),
    );
  }
}
