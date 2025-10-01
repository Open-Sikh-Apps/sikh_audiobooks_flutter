// https://blog.stackademic.com/how-to-increase-the-height-of-listtile-in-flutter-e430dc577113

// Custom list tile definition
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook/audiobook.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook_resume_location/audiobook_resume_location.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/visibility_detector_image.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AudiobookListTile extends StatelessWidget {
  final AudiobookUiState audiobookUiState;
  final String keyString;
  final bool showAuthor;
  final void Function() onVisible;
  final void Function() onHidden;
  final void Function() onPlay;
  final void Function() onPause;
  final void Function() onDownload;
  final void Function() onRemoveDownload;
  final void Function() onAddToLibrary;
  final void Function() onRemoveFromLibrary;
  final void Function() onShare;
  final void Function() onOpenBookmarks;

  // Constructor for the custom list tile
  AudiobookListTile({
    super.key,
    required this.audiobookUiState,
    required this.onVisible,
    required this.onHidden,
    required this.keyString,
    required this.showAuthor,
    required this.onPlay,
    required this.onPause,
    required this.onDownload,
    required this.onRemoveDownload,
    required this.onAddToLibrary,
    required this.onRemoveFromLibrary,
    required this.onShare,
    required this.onOpenBookmarks,
  }) {
    resumeLocation = audiobookUiState.resumeLocation;
    audiobookLocalImagePath = audiobookUiState.audiobook.localImagePath;
  }

  late final AudiobookResumeLocation? resumeLocation;
  late final String? audiobookLocalImagePath;
  final _log = Logger();

  void showAudiobookBottomSheet(BuildContext context) {
    final locale = Localizations.localeOf(context);

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
                padding: const EdgeInsets.all(Dimens.bottomSheetTitlePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  spacing: Dimens.paddingVertical2XS,
                  children: [
                    Text(
                      audiobookUiState.audiobook.name[locale.languageCode] ??
                          "",
                      style: TextTheme.of(context).titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (showAuthor)
                      Text(
                        audiobookUiState.author.name[locale.languageCode] ?? "",
                        style: TextTheme.of(context).titleSmall,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text(
                  AppLocalizations.of(context)?.labelViewChapters ?? "",
                ),
                onTap: () {
                  Navigator.pop(context);
                  // onViewChapters();
                },
              ),
              if (audiobookUiState.allDownloaded())
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text(
                    AppLocalizations.of(context)?.labelRemoveDownload ?? "",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onRemoveDownload();
                  },
                )
              else
                ListTile(
                  leading: Icon(Icons.download),
                  title: Text(
                    AppLocalizations.of(context)?.labelViewChapters ?? "",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDownload();
                  },
                ),
              if (audiobookUiState.inLibrary)
                ListTile(
                  leading: Icon(Icons.remove_circle),
                  title: Text(
                    AppLocalizations.of(context)?.labelRemoveFromLibrary ?? "",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onRemoveFromLibrary();
                  },
                )
              else
                ListTile(
                  leading: Icon(Icons.library_add),
                  title: Text(
                    AppLocalizations.of(context)?.labelAddToLibrary ?? "",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onAddToLibrary();
                  },
                ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text(AppLocalizations.of(context)?.labelShare ?? ""),
                onTap: () {
                  Navigator.pop(context);
                  onShare();
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmarks),
                title: Text(AppLocalizations.of(context)?.labelBookmarks ?? ""),
                onTap: () {
                  Navigator.pop(context);
                  onOpenBookmarks();
                },
              ),
              ListTile(
                leading: Icon(Icons.menu_book),
                title: Text(AppLocalizations.of(context)?.labelReadBook ?? ""),
                onTap: () {
                  Navigator.pop(context);
                  onReadBook(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.bottomSheetTitlePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  spacing: Dimens.paddingVertical2XS,
                  children: [
                    Text(
                      audiobookUiState.audiobook.name[locale.languageCode] ??
                          "",
                      style: TextTheme.of(context).titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (showAuthor)
                      Text(
                        audiobookUiState.author.name[locale.languageCode] ?? "",
                        style: TextTheme.of(context).titleSmall,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              Divider(),
              ListView(
                //TODO continue here to accomodate scrolling inside showModalBottomSheet
                shrinkWrap: true,
                children: [
                  ...audiobookUiState.chapters.map(
                    (c) => (ListTile(
                      title: Text(c.name[locale.languageCode] ?? ""),
                      onTap: () async {
                        final chapterUrl = c.pdfUrl;
                        final chapterUri = chapterUrl == null
                            ? null
                            : Uri.parse(chapterUrl);
                        if (chapterUri != null) {
                          if (!await launchUrl(chapterUri)) {
                            _log.d('Could not launch $chapterUri');
                          }
                        }
                      },
                    )),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void onReadBook(BuildContext context) async {
    switch (audiobookUiState.audiobook.pdfUrlType) {
      case PdfUrlType.book:
        final bookUrl = audiobookUiState.audiobook.pdfUrl;
        final bookUri = bookUrl == null ? null : Uri.parse(bookUrl);
        if (bookUri != null) {
          if (!await launchUrl(bookUri)) {
            _log.d('Could not launch $bookUri');
          }
        }
      case PdfUrlType.chapter:
        showChapterBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Material(
      child: InkWell(
        // Tappable area with event handlers
        // onTap: onTap, // Tap event handler
        onLongPress: () => (showAudiobookBottomSheet(context)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.audiobookListItemPaddingHorizontal,
            vertical: Dimens.audiobookListItemPaddingVertical,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: Dimens.paddingHorizontalXS,
                ),
                child: VisibilityDetectorImage(
                  keyString: keyString,
                  localImagePath: audiobookLocalImagePath,
                  width: Dimens.audiobookListPhotoWidth,
                  height: Dimens.audiobookListPhotoHeight,
                  onVisible: onVisible,
                  onHidden: onHidden,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text left
                  children: [
                    Text(
                      audiobookUiState.audiobook.name[locale.languageCode] ??
                          "",
                      style: TextTheme.of(context).bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimens.paddingVertical2XS),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (resumeLocation != null)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  right: Dimens.paddingHorizontal2XS,
                                ),
                                child: SizedBox(
                                  width: Dimens.audiobookListItemProgressWidth,
                                  child: LinearProgressIndicator(
                                    value:
                                        audiobookUiState
                                            .leftDuration()
                                            .inSeconds /
                                        audiobookUiState
                                            .totalDuration()
                                            .inSeconds,
                                  ),
                                ),
                              )
                            : Container(),
                        Text(
                          ((resumeLocation != null)
                                  ? AppLocalizations.of(
                                      context,
                                    )?.labelAudiobookDurationLeft(
                                      audiobookUiState.leftDuration().inHours,
                                      audiobookUiState
                                              .leftDuration()
                                              .inMinutes %
                                          60,
                                    )
                                  : AppLocalizations.of(
                                      context,
                                    )?.labelAudiobookDuration(
                                      audiobookUiState.totalDuration().inHours,
                                      audiobookUiState
                                              .totalDuration()
                                              .inMinutes %
                                          60,
                                    )) ??
                              "",
                        ),
                      ],
                    ),
                    if (audiobookUiState.allDownloaded()) ...[
                      SizedBox(height: Dimens.paddingVertical2XS),
                      Icon(Icons.download_done),
                    ] else
                      Container(),
                  ],
                ),
              ),
              Row(
                spacing: Dimens.paddingHorizontal2XS,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: Dimens.audiobookListItemIconSize,
                    icon: Icon(
                      audiobookUiState.isPlaying
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: Dimens.audiobookListItemIconSize,
                    icon: Icon(Icons.more_vert),
                    onPressed: () => (showAudiobookBottomSheet(context)),
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
