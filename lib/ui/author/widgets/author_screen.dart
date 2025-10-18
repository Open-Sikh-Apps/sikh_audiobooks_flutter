import 'package:auto_size_text/auto_size_text.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/ui/author/viewmodels/author_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/audiobook_list_tile.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/error_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/loading_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/select_action_chip.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/visibility_detector_image.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';
import 'package:sikh_audiobooks_flutter/utils/enums.dart';
import 'package:sikh_audiobooks_flutter/utils/locale.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:watch_it/watch_it.dart';

class AuthorScreen extends WatchingStatefulWidget {
  const AuthorScreen({super.key, required this.id});
  final String id;

  @override
  State<AuthorScreen> createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  late AuthorViewModel viewModel;
  final _log = Logger();
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
    viewModel = AuthorViewModel(audiobooksRepository: getIt(), id: widget.id);
  }

  @override
  void didUpdateWidget(covariant AuthorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      viewModel.onDispose();
      viewModel = AuthorViewModel(audiobooksRepository: getIt(), id: widget.id);
    }
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    viewModel.onDispose();
    super.dispose();
  }

  void scrollToTopCollapsed() {
    if (_mainScrollController.offset > Dimens.authorScreenInfoHeight) {
      _mainScrollController.animateTo(
        Dimens.authorScreenInfoHeight,
        duration: Constants.autoScrollDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    viewModel.notifyCurrentLocale(locale);

    final refreshDataCommandResults = watch(
      viewModel.refreshDataCommand.results,
    ).value;

    final authorResult = watch(viewModel.authorResultVN).value;
    final audiobookLanguage = watch(viewModel.audiobookLanguageVN).value;
    final audiobookFilter = watch(viewModel.audiobookFilterVN).value;
    final audiobookAuthorSort = watch(viewModel.audiobookAuthorSortVN).value;

    final filteredAudiobookUiStatesResult = watch(
      viewModel.filteredAudiobookUiStatesResultVL,
    ).value;

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
            if (authorResult == null ||
                filteredAudiobookUiStatesResult == null) {
              return LoadingIndicator();
            }
            if (authorResult is Error ||
                filteredAudiobookUiStatesResult is Error) {
              return _getErrorIndicatorWidget(context);
            }
            final author = (authorResult as Ok<Author?>).value;
            if (author == null) {
              return _getErrorIndicatorWidget(context);
            }
            final localImagePath = author.localImagePath;
            final aboutUrl = author.aboutUrl[locale.languageCode];
            final aboutUri = aboutUrl == null ? null : Uri.parse(aboutUrl);

            final filteredAudiobooks =
                (filteredAudiobookUiStatesResult as Ok<List<AudiobookUiState>>)
                    .value;

            return Scaffold(
              body: NotificationListener<ScrollNotification>(
                onNotification: (_) {
                  if (context.mounted) {
                    setState(() {
                      _appBarCollapsed =
                          _mainScrollController.hasClients &&
                          (_mainScrollController.offset >=
                              (Dimens.authorScreenInfoHeight));
                    });
                  }

                  return false;
                },
                child: CustomScrollView(
                  controller: _mainScrollController,
                  slivers: [
                    SliverAppBar(
                      primary: true,
                      expandedHeight:
                          Dimens.authorScreenInfoHeight +
                          kToolbarHeight +
                          Dimens.authorScreenFilterBarHeight,
                      title: AnimatedSwitcher(
                        duration: Constants.animatedSwitcherDuration,
                        child: (_appBarCollapsed)
                            ? Text(author.name[locale.languageCode] ?? "")
                            : Container(),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: Padding(
                          padding: EdgeInsets.only(
                            left: Dimens.paddingHorizontalLarge,
                            right: Dimens.paddingHorizontalLarge,
                            top:
                                kToolbarHeight +
                                MediaQuery.of(context).padding.top,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: Dimens.paddingVerticalMedium,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: Dimens.authorScreenPhotoSpacing,
                                children: [
                                  VisibilityDetectorImage(
                                    keyString:
                                        "${uuid}_author_image_${author.id}",
                                    localImagePath: localImagePath,
                                    width: Dimens.authorScreenPhotoSize,
                                    height: Dimens.authorScreenPhotoSize,
                                    onVisible: () {
                                      viewModel.startDownloadAuthorImage(
                                        author.id,
                                      );
                                    },
                                    onHidden: () {
                                      viewModel.cancelDownloadAuthorImage(
                                        author.id,
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      author.name[locale.languageCode] ?? "",
                                      style: TextTheme.of(
                                        context,
                                      ).headlineSmall,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: Dimens.chipSpacing,
                                  children: [
                                    ActionChip(
                                      label: Text(
                                        AppLocalizations.of(
                                              context,
                                            )?.labelAbout ??
                                            "",
                                      ),
                                      avatar: Icon(Icons.info),
                                      onPressed: aboutUri == null
                                          ? null
                                          : () async {
                                              if (!await launchUrl(aboutUri)) {
                                                _log.d(
                                                  'Could not launch $aboutUri',
                                                );
                                              }
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      pinned: true,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(
                          Dimens.authorScreenFilterBarHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimens.paddingVerticalSmall,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: Dimens.paddingVerticalSmall,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.paddingHorizontalSmall,
                                ),
                                child: Text(
                                  AppLocalizations.of(
                                        context,
                                      )?.labelAudiobooks ??
                                      "",
                                  style: TextTheme.of(context).titleLarge,
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.paddingHorizontalSmall,
                                  ),
                                  child: Row(
                                    spacing: Dimens.chipSpacing,
                                    children: [
                                      SelectActionChip<AudiobookLanguage>(
                                        icon: Icon(Icons.language),
                                        title:
                                            AppLocalizations.of(
                                              context,
                                            )?.labelLanguage ??
                                            "",
                                        selectionSheetTitle:
                                            AppLocalizations.of(
                                              context,
                                            )?.labelLanguage ??
                                            "",
                                        selectedValue: audiobookLanguage,
                                        options: [
                                          SelectActionChipOption(
                                            value: AudiobookLanguage.all,
                                            title:
                                                AppLocalizations.of(
                                                  context,
                                                )?.labelAll ??
                                                "",
                                          ),
                                          ...AppLocalizations.supportedLocales
                                              .map(
                                                (
                                                  locale,
                                                ) => SelectActionChipOption(
                                                  value: AudiobookLanguage
                                                      .values
                                                      .firstWhere(
                                                        (a) =>
                                                            (a.name ==
                                                            locale
                                                                .languageCode),
                                                      ),
                                                  title: locale.fullName(),
                                                ),
                                              ),
                                        ],
                                        onSubmitted: (audiobookLanguage) {
                                          viewModel.setAudiobookLanguageFilter(
                                            audiobookLanguage,
                                          );
                                          scrollToTopCollapsed();
                                        },
                                      ),
                                      SelectActionChip<AudiobookFilter>(
                                        icon: Icon(Icons.filter_list),
                                        title:
                                            AppLocalizations.of(
                                              context,
                                            )?.labelFilter ??
                                            "",
                                        selectionSheetTitle:
                                            AppLocalizations.of(
                                              context,
                                            )?.labelFilter ??
                                            "",
                                        selectedValue: audiobookFilter,
                                        options: [
                                          SelectActionChipOption(
                                            value: AudiobookFilter.all,
                                            title:
                                                AppLocalizations.of(
                                                  context,
                                                )?.labelAll ??
                                                "",
                                          ),
                                          SelectActionChipOption(
                                            value: AudiobookFilter.downloaded,
                                            title:
                                                AppLocalizations.of(
                                                  context,
                                                )?.labelDownloaded ??
                                                "",
                                          ),
                                        ],
                                        onSubmitted: (audiobookFilter) {
                                          viewModel.setAudiobookFilter(
                                            audiobookFilter,
                                          );
                                          scrollToTopCollapsed();
                                        },
                                      ),
                                      SelectActionChip<AudiobookAuthorSort>(
                                        icon: Icon(Icons.sort),
                                        title:
                                            AppLocalizations.of(
                                              context,
                                            )?.labelSort ??
                                            "",
                                        selectionSheetTitle:
                                            AppLocalizations.of(
                                              context,
                                            )?.labelSort ??
                                            "",
                                        selectedValue: audiobookAuthorSort,
                                        options: [
                                          SelectActionChipOption(
                                            value: AudiobookAuthorSort
                                                .authorDefault,
                                            title:
                                                AppLocalizations.of(
                                                  context,
                                                )?.labelDefault ??
                                                "",
                                          ),
                                          SelectActionChipOption(
                                            value:
                                                AudiobookAuthorSort.lastPlayed,
                                            title:
                                                AppLocalizations.of(
                                                  context,
                                                )?.labelLastPlayed ??
                                                "",
                                          ),
                                          SelectActionChipOption(
                                            value: AudiobookAuthorSort.title,
                                            title:
                                                AppLocalizations.of(
                                                  context,
                                                )?.labelTitle ??
                                                "",
                                          ),
                                        ],
                                        onSubmitted: (authorSort) {
                                          viewModel.setAudiobookAuthorSort(
                                            authorSort,
                                          );
                                          scrollToTopCollapsed();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    filteredAudiobooks.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  Dimens.emptyIndicationIconTitlePadding,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search_off),
                                    Text(
                                      AppLocalizations.of(
                                            context,
                                          )?.labelNoAudiobooksFound ??
                                          "",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SliverList.builder(
                            itemCount: filteredAudiobooks.length,
                            itemBuilder: (context, index) {
                              final audiobookUiState =
                                  filteredAudiobooks[index];
                              return AudiobookListTile(
                                showAuthor: false,
                                audiobookUiState: audiobookUiState,
                                keyString:
                                    "${uuid}_author_audiobook_${audiobookUiState.audiobook.id}",
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
