import 'package:auto_size_text/auto_size_text.dart';
import 'package:command_it/command_it.dart';
import 'package:duck_router/duck_router.dart';
import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/router.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/viewmodels/audiobook_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/widgets/chapter_list_tile.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/audiobook_list_tile.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/error_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/loading_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/visibility_detector_image.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/chapter_ui_state/chapter_ui_state.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';
import 'package:uuid/uuid.dart';
import 'package:watch_it/watch_it.dart';

class AudiobookScreen extends WatchingStatefulWidget {
  const AudiobookScreen({super.key, required this.id});
  final String id;

  @override
  State<AudiobookScreen> createState() => _AudiobookScreenState();
}

class _AudiobookScreenState extends State<AudiobookScreen> {
  late final AudiobookViewModel viewModel;
  bool _appBarCollapsed = false;
  final uuid = Uuid().v1();
  final ScrollController _mainScrollController = ScrollController();

  Widget _getErrorIndicatorWidget(BuildContext context) {
    return ErrorIndicator(
      title: AppLocalizations.of(context)?.errorLoading ?? "",
      label: AppLocalizations.of(context)?.labelRefresh ?? "",
      onPressed: () {
        viewModel.refreshDataCommand();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel = AudiobookViewModel(
      audiobooksRepository: getIt(),
      id: widget.id,
    );
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    viewModel.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final refreshDataCommandResults = watch(
      viewModel.refreshDataCommand.results,
    ).value;

    final audibookUiStateResult = watch(
      viewModel.audiobookUiStateResultVN,
    ).value;

    final chapterUiStateListResult = watch(
      viewModel.chapterUiStateListResultVN,
    ).value;

    final locale = Localizations.localeOf(context);

    return AnimatedSwitcher(
      duration: Constants.animatedSwitcherDuration,
      child: refreshDataCommandResults.toWidget(
        whileExecuting: (_, _) => LoadingIndicator(),
        onError: (_, _, _) => _getErrorIndicatorWidget(context),
        onData: (result, _) {
          if (result == null) {
            return LoadingIndicator();
          }
          if (result is Error) {
            return _getErrorIndicatorWidget(context);
          } else {
            if (audibookUiStateResult == null ||
                chapterUiStateListResult == null) {
              return LoadingIndicator();
            }
            final AudiobookUiState audiobookUiState;
            switch (audibookUiStateResult) {
              case Ok<AudiobookUiState?>():
                final result = audibookUiStateResult.value;
                if (result == null) {
                  return _getErrorIndicatorWidget(context);
                }
                audiobookUiState = result;
              case Error<AudiobookUiState?>():
                return _getErrorIndicatorWidget(context);
            }

            final audiobookLocalImagePath =
                audiobookUiState.audiobook.localImagePath;

            final List<ChapterUiState> chapterUiStateList;
            switch (chapterUiStateListResult) {
              case Ok<List<ChapterUiState>?>():
                final result = chapterUiStateListResult.value;
                if (result == null) {
                  return _getErrorIndicatorWidget(context);
                }
                chapterUiStateList = result;
              case Error<List<ChapterUiState>?>():
                return _getErrorIndicatorWidget(context);
            }

            return Scaffold(
              body: NotificationListener<ScrollNotification>(
                onNotification: (_) {
                  if (context.mounted) {
                    setState(() {
                      _appBarCollapsed =
                          _mainScrollController.hasClients &&
                          (_mainScrollController.offset >=
                              (Dimens.audiobookScreenInfoHeight));
                    });
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _mainScrollController,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      primary: true,
                      expandedHeight:
                          Dimens.audiobookScreenInfoHeight +
                          kToolbarHeight +
                          Dimens.audiobookScreenChapterLabelHeight,
                      title: AnimatedSwitcher(
                        duration: Constants.animatedSwitcherDuration,
                        child: (_appBarCollapsed)
                            ? Text(
                                audiobookUiState.audiobook.name[locale
                                        .languageCode] ??
                                    "",
                              )
                            : Container(),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: Dimens.paddingVerticalSmall,
                            children: [
                              Container(
                                height: kToolbarHeight,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.appBarLeadingWidth,
                                ),
                                child: AuthorTitle(
                                  author: audiobookUiState.author,
                                  uuid: uuid,
                                  viewModel: viewModel,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: Dimens.paddingVerticalMedium,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimens.paddingHorizontalLarge,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing:
                                          Dimens.audiobookScreenPhotoSpacing,
                                      children: [
                                        VisibilityDetectorImage(
                                          keyString:
                                              "${uuid}_audiobook_screen_image_${audiobookUiState.audiobook.id}",
                                          localImagePath:
                                              audiobookLocalImagePath,
                                          width:
                                              Dimens.audiobookScreenPhotoWidth,
                                          height:
                                              Dimens.audiobookScreenPhotoHeight,
                                          onVisible: () {
                                            viewModel
                                                .startDownloadAudiobookImage(
                                                  audiobookUiState.audiobook.id,
                                                );
                                          },
                                          onHidden: () {
                                            viewModel
                                                .cancelDownloadAudiobookImage(
                                                  audiobookUiState.audiobook.id,
                                                );
                                          },
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 1,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: Dimens
                                                  .audiobookScreenPhotoHeight,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing:
                                                  Dimens.paddingVertical3XS,
                                              children: [
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  flex: 1,
                                                  child: AutoSizeText(
                                                    audiobookUiState
                                                            .audiobook
                                                            .name[locale
                                                            .languageCode] ??
                                                        "",
                                                    style: TextTheme.of(
                                                      context,
                                                    ).headlineSmall,
                                                  ),
                                                ),
                                                Text(
                                                  AppLocalizations.of(
                                                        context,
                                                      )?.labelAudiobookDuration(
                                                        audiobookUiState
                                                            .totalDuration()
                                                            .inHours,
                                                        audiobookUiState
                                                                .totalDuration()
                                                                .inMinutes %
                                                            60,
                                                      ) ??
                                                      "",
                                                  style: TextTheme.of(
                                                    context,
                                                  ).titleSmall,
                                                ),
                                                if (audiobookUiState
                                                        .resumeLocation !=
                                                    null)
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              right: Dimens
                                                                  .paddingHorizontal2XS,
                                                            ),
                                                        child: SizedBox(
                                                          width: Dimens
                                                              .audiobookScreenProgressWidth,
                                                          child: LinearProgressIndicator(
                                                            value:
                                                                (audiobookUiState
                                                                        .totalDuration()
                                                                        .inSeconds -
                                                                    audiobookUiState
                                                                        .leftDuration()
                                                                        .inSeconds) /
                                                                audiobookUiState
                                                                    .totalDuration()
                                                                    .inSeconds,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(
                                                              context,
                                                            )?.labelAudiobookDurationLeft(
                                                              audiobookUiState
                                                                  .leftDuration()
                                                                  .inHours,
                                                              audiobookUiState
                                                                      .leftDuration()
                                                                      .inMinutes %
                                                                  60,
                                                            ) ??
                                                            "",
                                                        style: TextTheme.of(
                                                          context,
                                                        ).titleSmall,
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimens.paddingHorizontalSmall,
                                      ),
                                      child: Row(
                                        spacing: Dimens.chipSpacing,
                                        children: [
                                          audiobookUiState.allDownloaded()
                                              ? ActionChip(
                                                  label: Text(
                                                    AppLocalizations.of(
                                                          context,
                                                        )?.labelRemoveDownload ??
                                                        "",
                                                  ),
                                                  avatar: Icon(Icons.delete),
                                                  onPressed: () {
                                                    viewModel
                                                        .removeDownloadCommand();
                                                  },
                                                )
                                              : ActionChip(
                                                  label: Text(
                                                    AppLocalizations.of(
                                                          context,
                                                        )?.labelDownload ??
                                                        "",
                                                  ),
                                                  avatar: Icon(Icons.download),
                                                  onPressed: () {
                                                    viewModel.downloadCommand();
                                                  },
                                                ),
                                          audiobookUiState.inLibrary
                                              ? ActionChip(
                                                  label: Text(
                                                    AppLocalizations.of(
                                                          context,
                                                        )?.labelRemoveFromLibrary ??
                                                        "",
                                                  ),
                                                  avatar: Icon(
                                                    Icons.remove_circle,
                                                  ),
                                                  onPressed: () {
                                                    viewModel
                                                        .removeFromLibraryCommand();
                                                  },
                                                )
                                              : ActionChip(
                                                  label: Text(
                                                    AppLocalizations.of(
                                                          context,
                                                        )?.labelAddToLibrary ??
                                                        "",
                                                  ),
                                                  avatar: Icon(
                                                    Icons.library_add,
                                                  ),
                                                  onPressed: () {
                                                    viewModel
                                                        .addToLibraryCommand();
                                                  },
                                                ),
                                          ActionChip(
                                            label: Text(
                                              AppLocalizations.of(
                                                    context,
                                                  )?.labelShare ??
                                                  "",
                                            ),
                                            avatar: Icon(Icons.share),
                                          ),
                                          ActionChip(
                                            label: Text(
                                              AppLocalizations.of(
                                                    context,
                                                  )?.labelBookmarks ??
                                                  "",
                                            ),
                                            avatar: Icon(Icons.bookmarks),
                                          ),
                                          ActionChip(
                                            label: Text(
                                              AppLocalizations.of(
                                                    context,
                                                  )?.labelReadBook ??
                                                  "",
                                            ),
                                            avatar: Icon(Icons.menu_book),
                                            onPressed: () {
                                              onReadBook(
                                                context,
                                                audiobookUiState,
                                                true,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(
                          Dimens.audiobookScreenChapterLabelHeight,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimens.paddingVerticalSmall,
                            horizontal: Dimens.paddingHorizontalSmall,
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.labelChapters ?? "",
                            style: TextTheme.of(context).titleLarge,
                          ),
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: chapterUiStateList.length,
                      itemBuilder: (context, index) {
                        return ChapterListTile(
                          chapterUiState: chapterUiStateList[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class AuthorTitle extends StatelessWidget {
  const AuthorTitle({
    super.key,
    required this.author,
    required this.uuid,
    required this.viewModel,
  });

  final Author author;
  final String uuid;
  final AudiobookViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localImagePath = author.localImagePath;
    final authorId = author.id;

    return InkWell(
      onTap: () {
        DuckRouter.of(context).navigate(to: AuthorLocation(authorId));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Dimens.paddingHorizontalXS,
        children: [
          VisibilityDetectorImage(
            keyString: "${uuid}_audiobook_screen_author_${author.id}",
            localImagePath: localImagePath,
            width: Dimens.audiobookScreenAuthorPhotoSize,
            height: Dimens.audiobookScreenAuthorPhotoSize,
            onVisible: () {
              viewModel.startDownloadAuthorImage(author.id);
            },
            onHidden: () {
              viewModel.cancelDownloadAuthorImage(author.id);
            },
          ),
          Flexible(
            child: Text(
              author.name[locale.languageCode] ?? "",
              maxLines: 1,
              style: TextTheme.of(context).bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
