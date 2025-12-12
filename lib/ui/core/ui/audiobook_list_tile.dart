// https://blog.stackademic.com/how-to-increase-the-height-of-listtile-in-flutter-e430dc577113

import 'package:command_it/command_it.dart';
import 'package:duck_router/duck_router.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook/audiobook.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook_resume_location/audiobook_resume_location.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/router.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/viewmodels/audiobook_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/visibility_detector_image.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';
import 'package:sikh_audiobooks_flutter/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';

class AudiobookListTile extends WatchingStatefulWidget {
  final AudiobookUiState audiobookUiState;
  final String keyString;
  final bool showAuthor;

  // Constructor for the custom list tile
  AudiobookListTile({
    super.key,
    required this.audiobookUiState,
    required this.keyString,
    required this.showAuthor,
  }) {
    resumeLocation = audiobookUiState.resumeLocation;
    audiobookLocalImagePath = audiobookUiState.audiobook.localImagePath;
  }

  late final AudiobookResumeLocation? resumeLocation;
  late final String? audiobookLocalImagePath;

  @override
  State<AudiobookListTile> createState() => _AudiobookListTileState();
}

class _AudiobookListTileState extends State<AudiobookListTile> {
  late AudiobookViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AudiobookViewModel(
      audiobooksRepository: getIt(),
      id: widget.audiobookUiState.audiobook.id,
    );
  }

  @override
  void didUpdateWidget(covariant AudiobookListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audiobookUiState.audiobook.id !=
        widget.audiobookUiState.audiobook.id) {
      viewModel.onDispose();
      viewModel = AudiobookViewModel(
        audiobooksRepository: getIt(),
        id: widget.audiobookUiState.audiobook.id,
      );
    }
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  void _showAudiobookBottomSheet(bool disconnected) {
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
                      widget.audiobookUiState.audiobook.name[locale
                              .languageCode] ??
                          "",
                      style: TextTheme.of(context).titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (widget.showAuthor)
                      Text(
                        widget.audiobookUiState.author.name[locale
                                .languageCode] ??
                            "",
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
                  DuckRouter.of(context).navigate(
                    to: AudiobookLocation(widget.audiobookUiState.audiobook.id),
                  );
                },
              ),
              if (widget.audiobookUiState.allDownloaded())
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
                    viewModel.downloadCommand(this.context);
                  },
                ),
              if (widget.audiobookUiState.inLibrary)
                ListTile(
                  leading: Icon(Icons.remove_circle),
                  title: Text(
                    AppLocalizations.of(context)?.labelRemoveFromLibrary ?? "",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.removeFromLibraryCommand();
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
                    viewModel.addToLibraryCommand();
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
              ListTile(
                leading: Icon(Icons.bookmarks),
                title: Text(AppLocalizations.of(context)?.labelBookmarks ?? ""),
                onTap: () {
                  Navigator.pop(context);
                  // onOpenBookmarks();
                },
              ),
              ListTile(
                enabled: !disconnected,
                leading: Icon(Icons.menu_book),
                title: Text(AppLocalizations.of(context)?.labelReadBook ?? ""),
                onTap: () {
                  Navigator.pop(context);
                  onReadBook(
                    context,
                    widget.audiobookUiState,
                    widget.showAuthor,
                  );
                },
              ),
              if (widget.showAuthor)
                ListTile(
                  leading: Icon(Icons.account_box),
                  title: Text(AppLocalizations.of(context)?.labelAuthor ?? ""),
                  onTap: () {
                    Navigator.pop(context);
                    DuckRouter.of(context).navigate(
                      to: AuthorLocation(widget.audiobookUiState.author.id),
                    );
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
    registerHandler(
      target: viewModel.addToLibraryCommand.results,
      handler: (context, CommandResult<void, Result<void>?> value, _) {
        final resultError = value.error;
        final resultData = value.data;

        final errorMessage =
            AppLocalizations.of(context)?.messageErrorAddingToLibrary ?? "";

        final successMessage =
            AppLocalizations.of(context)?.messageAddedToLibrary ?? "";

        if (resultError != null) {
          showSnackbar(context, errorMessage);
          return;
        }
        if (resultData != null) {
          switch (resultData) {
            case Ok<void>():
              showSnackbar(context, successMessage);
            case Error<void>():
              showSnackbar(context, errorMessage);
          }
          return;
        }
      },
    );

    registerHandler(
      target: viewModel.removeFromLibraryCommand.results,
      handler: (context, CommandResult<void, Result<void>?> value, _) {
        final resultError = value.error;
        final resultData = value.data;

        final errorMessage =
            AppLocalizations.of(context)?.messageErrorRemovingFromLibrary ?? "";

        final successMessage =
            AppLocalizations.of(context)?.messageRemovedFromLibrary ?? "";

        if (resultError != null) {
          showSnackbar(context, errorMessage);
          return;
        }
        if (resultData != null) {
          switch (resultData) {
            case Ok<void>():
              showSnackbar(context, successMessage);
            case Error<void>():
              showSnackbar(context, errorMessage);
          }
          return;
        }
      },
    );

    final locale = Localizations.localeOf(context);

    final internetStatus = watch(viewModel.internetStatusVN).value;
    final disconnected = internetStatus == InternetStatus.disconnected;

    return Material(
      child: InkWell(
        // Tappable area with event handlers
        onTap: () {
          DuckRouter.of(context).navigate(
            to: AudiobookLocation(widget.audiobookUiState.audiobook.id),
          );
        },
        onLongPress: () => (_showAudiobookBottomSheet(disconnected)),
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
                  disconnected: disconnected,
                  keyString: widget.keyString,
                  localImagePath: widget.audiobookLocalImagePath,
                  width: Dimens.audiobookListPhotoWidth,
                  height: Dimens.audiobookListPhotoHeight,
                  onVisible: () {
                    viewModel.startDownloadAudiobookImage(
                      widget.audiobookUiState.audiobook.id,
                    );
                  },
                  onHidden: () {
                    viewModel.cancelDownloadAudiobookImage(
                      widget.audiobookUiState.audiobook.id,
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  spacing: Dimens.paddingVertical2XS,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text left
                  children: [
                    Text(
                      widget.audiobookUiState.audiobook.name[locale
                              .languageCode] ??
                          "",
                      style: TextTheme.of(context).bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.showAuthor)
                      Text(
                        widget.audiobookUiState.author.name[locale
                                .languageCode] ??
                            "",
                        style: TextTheme.of(context).bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (widget.resumeLocation != null)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  right: Dimens.paddingHorizontal2XS,
                                ),
                                child: SizedBox(
                                  width: Dimens.audiobookListItemProgressWidth,
                                  child: LinearProgressIndicator(
                                    value:
                                        (widget.audiobookUiState
                                                .totalDuration()
                                                .inSeconds -
                                            widget.audiobookUiState
                                                .leftDuration()
                                                .inSeconds) /
                                        widget.audiobookUiState
                                            .totalDuration()
                                            .inSeconds,
                                  ),
                                ),
                              )
                            : Container(),
                        Text(
                          ((widget.resumeLocation != null)
                                  ? AppLocalizations.of(
                                      context,
                                    )?.labelAudiobookDurationLeft(
                                      widget.audiobookUiState
                                          .leftDuration()
                                          .inHours,
                                      widget.audiobookUiState
                                              .leftDuration()
                                              .inMinutes %
                                          60,
                                    )
                                  : AppLocalizations.of(
                                      context,
                                    )?.labelAudiobookDuration(
                                      widget.audiobookUiState
                                          .totalDuration()
                                          .inHours,
                                      widget.audiobookUiState
                                              .totalDuration()
                                              .inMinutes %
                                          60,
                                    )) ??
                              "",
                        ),
                      ],
                    ),
                    if (widget.audiobookUiState.allDownloaded())
                      Icon(Icons.download_done),
                  ],
                ),
              ),
              Row(
                spacing: Dimens.paddingHorizontal2XS,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!(widget.audiobookUiState.noneDownloaded() &&
                      disconnected))
                    IconButton(
                      iconSize: Dimens.audiobookListItemIconSize,
                      icon: Icon(
                        widget.audiobookUiState.isPlaying
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                      ),
                      onPressed: () {
                        if (widget.audiobookUiState.isPlaying) {
                          viewModel.pauseCommand();
                        } else {
                          viewModel.playCommand();
                        }
                      },
                    ),
                  IconButton(
                    iconSize: Dimens.audiobookListItemIconSize,
                    icon: Icon(Icons.more_vert),
                    onPressed: () => (_showAudiobookBottomSheet(disconnected)),
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

void showChapterBottomSheet(
  BuildContext context,
  AudiobookUiState audiobookUiState,
  bool showAuthor,
) {
  final log = Logger();
  final locale = Localizations.localeOf(context);
  final screenHeight = MediaQuery.sizeOf(context).height;

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
                    audiobookUiState.audiobook.name[locale.languageCode] ?? "",
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
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight / 1.8),
              child: ListView(
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
                            log.d('Could not launch $chapterUri');
                          }
                        }
                      },
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void onReadBook(
  BuildContext context,
  AudiobookUiState audiobookUiState,
  bool showAuthor,
) async {
  final log = Logger();
  switch (audiobookUiState.audiobook.pdfUrlType) {
    case PdfUrlType.book:
      final bookUrl = audiobookUiState.audiobook.pdfUrl;
      final bookUri = bookUrl == null ? null : Uri.parse(bookUrl);
      if (bookUri != null) {
        if (!await launchUrl(bookUri)) {
          log.d('Could not launch $bookUri');
        }
      }
    case PdfUrlType.chapter:
      showChapterBottomSheet(context, audiobookUiState, showAuthor);
  }
}
