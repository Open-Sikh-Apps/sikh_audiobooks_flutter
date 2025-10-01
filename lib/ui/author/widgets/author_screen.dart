import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
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
import 'package:visibility_detector/visibility_detector.dart';
import 'package:watch_it/watch_it.dart';

class AuthorScreen extends WatchingStatefulWidget {
  const AuthorScreen({super.key, required this.viewModel});
  final AuthorViewModel viewModel;

  @override
  State<AuthorScreen> createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  final _log = Logger();
  bool _showAppbarTitle = false;
  bool _screenVisible = true;
  final uuid = Uuid().v1();

  Widget _getErrorIndicatorWidget(BuildContext context) {
    return ErrorIndicator(
      title: AppLocalizations.of(context)?.errorLoading ?? "",
      label: AppLocalizations.of(context)?.labelRefresh ?? "",
      onPressed: () {
        widget.viewModel.refreshDataCommand();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.viewModel.notifyCurrentLocale(Localizations.localeOf(context));

    final refreshDataCommandResults = watch(
      widget.viewModel.refreshDataCommand.results,
    ).value;

    final authorResult = watch(widget.viewModel.authorResultVN).value;
    final audiobookLanguage = watch(widget.viewModel.audiobookLanguageVN).value;
    final audiobookFilter = watch(widget.viewModel.audiobookFilterVN).value;
    final audiobookAuthorSort = watch(
      widget.viewModel.audiobookAuthorSortVN,
    ).value;

    final filteredAudiobookUiStatesResult = watch(
      widget.viewModel.filteredAudiobookUiStatesResultVN,
    ).value;

    final locale = Localizations.localeOf(context);

    return VisibilityDetector(
      key: Key("${uuid}_author_screen"),
      onVisibilityChanged: (VisibilityInfo info) {
        if (context.mounted) {
          setState(() {
            if (info.visibleFraction > 0) {
              _screenVisible = true;
            } else {
              _screenVisible = false;
            }
          });
        }
      },
      child: AnimatedSwitcher(
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
                  (filteredAudiobookUiStatesResult
                          as Ok<List<AudiobookUiState>>)
                      .value;

              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: AnimatedSwitcher(
                        duration: Constants.animatedSwitcherDuration,
                        child: (_showAppbarTitle && _screenVisible)
                            ? Text(author.name[locale.languageCode] ?? "")
                            : Container(),
                      ),
                      scrolledUnderElevation: 0.0,
                      pinned: true,
                      backgroundColor: ColorScheme.of(context).surface,
                    ),

                    SliverToBoxAdapter(
                      child: VisibilityDetector(
                        key: Key("${uuid}_author_header_${author.id}"),
                        onVisibilityChanged: (VisibilityInfo info) {
                          if (context.mounted) {
                            setState(() {
                              if (info.visibleFraction > 0.8) {
                                _showAppbarTitle = false;
                              } else {
                                _showAppbarTitle = true;
                              }
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.paddingHorizontalLarge,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: Dimens.paddingVerticalMedium,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      widget.viewModel.startDownloadAuthorImage(
                                        author.id,
                                      );
                                    },
                                    onHidden: () {
                                      widget.viewModel
                                          .cancelDownloadAuthorImage(author.id);
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      author.name[locale.languageCode] ?? "",
                                      style: TextTheme.of(
                                        context,
                                      ).headlineSmall,
                                      softWrap: true,
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
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: FilterBarDelegate(
                        audiobookLanguage: audiobookLanguage,
                        audiobookAuthorSort: audiobookAuthorSort,
                        audiobookFilter: audiobookFilter,
                        viewModel: widget.viewModel,
                      ),
                    ),
                    SliverList.builder(
                      itemCount: filteredAudiobooks.length,
                      itemBuilder: (context, index) {
                        final audiobookUiState = filteredAudiobooks[index];
                        return AudiobookListTile(
                          showAuthor: false,
                          audiobookUiState: audiobookUiState,
                          // onTap: () {},
                          onVisible: () {
                            widget.viewModel.startDownloadAudiobookImage(
                              audiobookUiState.audiobook.id,
                            );
                          },
                          onHidden: () {
                            widget.viewModel.cancelDownloadAudiobookImage(
                              audiobookUiState.audiobook.id,
                            );
                          },
                          keyString:
                              "${uuid}_author_audiobook_${audiobookUiState.audiobook.id}",
                          onPlay: () {},
                          onPause: () {},
                          // onViewChapters: () {},
                          onDownload: () {},
                          onRemoveDownload: () {},
                          onAddToLibrary: () {},
                          onRemoveFromLibrary: () {},
                          onShare: () {},
                          onOpenBookmarks: () {},
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class FilterBarDelegate extends SliverPersistentHeaderDelegate {
  FilterBarDelegate({
    required this.audiobookLanguage,
    required this.audiobookFilter,
    required this.audiobookAuthorSort,
    required this.viewModel,
  });

  final AudiobookLanguage audiobookLanguage;
  final AudiobookFilter audiobookFilter;
  final AudiobookAuthorSort audiobookAuthorSort;
  final AuthorViewModel viewModel;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: ColorScheme.of(context).surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.paddingVerticalSmall,
          horizontal: Dimens.paddingHorizontalSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Dimens.paddingVerticalSmall,
          children: [
            Text(
              AppLocalizations.of(context)?.labelAudiobooks ?? "",
              style: TextTheme.of(context).titleLarge,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: Dimens.chipSpacing,
                children: [
                  SelectActionChip<AudiobookLanguage>(
                    icon: Icon(Icons.language),
                    title: AppLocalizations.of(context)?.labelLanguage ?? "",
                    selectionSheetTitle:
                        AppLocalizations.of(context)?.labelLanguage ?? "",
                    selectedValue: audiobookLanguage,
                    options: [
                      SelectActionChipOption(
                        value: AudiobookLanguage.all,
                        title: AppLocalizations.of(context)?.labelAll ?? "",
                      ),
                      ...AppLocalizations.supportedLocales.map(
                        (locale) => SelectActionChipOption(
                          value: AudiobookLanguage.values.firstWhere(
                            (a) => (a.name == locale.languageCode),
                          ),
                          title: locale.fullName(),
                        ),
                      ),
                    ],
                    onSubmitted: (audiobookLanguage) {
                      viewModel.setAudiobookLanguageFilter(audiobookLanguage);
                    },
                  ),
                  SelectActionChip<AudiobookFilter>(
                    icon: Icon(Icons.filter_list),
                    title: AppLocalizations.of(context)?.labelFilter ?? "",
                    selectionSheetTitle:
                        AppLocalizations.of(context)?.labelFilter ?? "",
                    selectedValue: audiobookFilter,
                    options: [
                      SelectActionChipOption(
                        value: AudiobookFilter.all,
                        title: AppLocalizations.of(context)?.labelAll ?? "",
                      ),
                      SelectActionChipOption(
                        value: AudiobookFilter.downloaded,
                        title:
                            AppLocalizations.of(context)?.labelDownloaded ?? "",
                      ),
                    ],
                    onSubmitted: (audiobookFilter) {
                      viewModel.setAudiobookFilter(audiobookFilter);
                    },
                  ),
                  SelectActionChip<AudiobookAuthorSort>(
                    icon: Icon(Icons.sort),
                    title: AppLocalizations.of(context)?.labelSort ?? "",
                    selectionSheetTitle:
                        AppLocalizations.of(context)?.labelSort ?? "",
                    selectedValue: audiobookAuthorSort,
                    options: [
                      SelectActionChipOption(
                        value: AudiobookAuthorSort.authorDefault,
                        title: AppLocalizations.of(context)?.labelDefault ?? "",
                      ),
                      SelectActionChipOption(
                        value: AudiobookAuthorSort.lastPlayed,
                        title:
                            AppLocalizations.of(context)?.labelLastPlayed ?? "",
                      ),
                      SelectActionChipOption(
                        value: AudiobookAuthorSort.title,
                        title: AppLocalizations.of(context)?.labelTitle ?? "",
                      ),
                    ],
                    onSubmitted: (authorSort) {
                      viewModel.setAudiobookAuthorSort(authorSort);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 116.0;

  @override
  double get minExtent => 116.0;

  @override
  bool shouldRebuild(FilterBarDelegate oldDelegate) {
    if (oldDelegate.audiobookLanguage != audiobookLanguage ||
        oldDelegate.audiobookFilter != audiobookFilter ||
        oldDelegate.audiobookAuthorSort != audiobookAuthorSort) {
      return true;
    }
    return false;
  }
}
