import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/audiobook_list_tile.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/error_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/loading_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/select_action_chip.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';
import 'package:sikh_audiobooks_flutter/ui/library/viewmodels/library_view_model.dart';
import 'package:sikh_audiobooks_flutter/utils/enums.dart';
import 'package:sikh_audiobooks_flutter/utils/locale.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';
import 'package:uuid/uuid.dart';
import 'package:watch_it/watch_it.dart';

class LibraryScreen extends WatchingStatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final LibraryViewModel viewModel;
  final _log = Logger();
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

  Widget _getDataWidget(
    AudiobookLanguage audiobookLanguage,
    AudiobookFilter audiobookFilter,
    AudiobookLibrarySort audiobookLibrarySort,
    Result<List<AudiobookUiState>>? filteredAudiobookUiStatesResult,
    Result<List<AudiobookUiState>>? allAudiobookUiStatesResult,
  ) {
    if (filteredAudiobookUiStatesResult == null ||
        allAudiobookUiStatesResult == null) {
      return LoadingIndicator();
    }
    if (filteredAudiobookUiStatesResult is Error ||
        allAudiobookUiStatesResult is Error) {
      return _getErrorIndicatorWidget(context);
    }
    final filteredAudiobooks =
        (filteredAudiobookUiStatesResult as Ok<List<AudiobookUiState>>).value;
    final allAudiobooks =
        (allAudiobookUiStatesResult as Ok<List<AudiobookUiState>>).value;
    return Scaffold(
      body: CustomScrollView(
        controller: _mainScrollController,
        slivers: [
          SliverAppBar(
            primary: true,
            pinned: true,
            leadingWidth: 0.0,
            titleSpacing: 0.0,
            title: SingleChildScrollView(
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
                        scrollToTop();
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
                              AppLocalizations.of(context)?.labelDownloaded ??
                              "",
                        ),
                      ],
                      onSubmitted: (audiobookFilter) {
                        viewModel.setAudiobookFilter(audiobookFilter);
                        scrollToTop();
                      },
                    ),
                    SelectActionChip<AudiobookLibrarySort>(
                      icon: Icon(Icons.sort),
                      title: AppLocalizations.of(context)?.labelSort ?? "",
                      selectionSheetTitle:
                          AppLocalizations.of(context)?.labelSort ?? "",
                      selectedValue: audiobookLibrarySort,
                      options: [
                        SelectActionChipOption(
                          value: AudiobookLibrarySort.lastPlayed,
                          title:
                              AppLocalizations.of(context)?.labelLastPlayed ??
                              "",
                        ),
                        SelectActionChipOption(
                          value: AudiobookLibrarySort.title,
                          title: AppLocalizations.of(context)?.labelTitle ?? "",
                        ),
                      ],
                      onSubmitted: (authorSort) {
                        viewModel.setAudiobookAuthorSort(authorSort);
                        scrollToTop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (allAudiobooks.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    Dimens.emptyIndicationIconTitlePadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.library_books_outlined),
                      Text(
                        AppLocalizations.of(context)?.messageLibraryEmpty ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (filteredAudiobooks.isEmpty)
            SliverToBoxAdapter(
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
                        AppLocalizations.of(context)?.labelNoAudiobooksFound ??
                            "",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverList.builder(
              itemCount: filteredAudiobooks.length,
              itemBuilder: (context, index) {
                final audiobookUiState = filteredAudiobooks[index];
                return AudiobookListTile(
                  showAuthor: true,
                  audiobookUiState: audiobookUiState,
                  keyString:
                      "${uuid}_author_audiobook_${audiobookUiState.audiobook.id}",
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel = LibraryViewModel(audiobooksRepository: getIt());
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  void scrollToTop() {
    _mainScrollController.animateTo(
      0,
      duration: Constants.autoScrollDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    viewModel.notifyCurrentLocale(locale);

    final refreshDataCommandResults = watch(
      viewModel.refreshDataCommand.results,
    ).value;

    final audiobookLanguage = watch(viewModel.audiobookLanguageVN).value;
    final audiobookFilter = watch(viewModel.audiobookFilterVN).value;
    final audiobookLibrarySort = watch(viewModel.audiobookLibrarySortVN).value;

    final filteredAudiobookUiStatesResult = watch(
      viewModel.filteredAudiobookUiStatesResultVL,
    ).value;

    final allAudiobookUiStatesResult = watch(
      viewModel.allAudiobookUiStatesResultVN,
    ).value;

    final internetStatus = watch(viewModel.internetStatusVN).value;
    final disconnected = internetStatus == InternetStatus.disconnected;

    return AnimatedSwitcher(
      duration: Constants.animatedSwitcherDuration,
      child: refreshDataCommandResults.toWidget(
        whileExecuting: (_, _) => LoadingIndicator(),
        onError: (_, _, _) {
          if (disconnected) {
            return _getDataWidget(
              audiobookLanguage,
              audiobookFilter,
              audiobookLibrarySort,
              filteredAudiobookUiStatesResult,
              allAudiobookUiStatesResult,
            );
          } else {
            return _getErrorIndicatorWidget(context);
          }
        },
        onData: (result, _) {
          if (result == null) {
            return LoadingIndicator();
          }
          if (result is Error) {
            if (disconnected) {
              return _getDataWidget(
                audiobookLanguage,
                audiobookFilter,
                audiobookLibrarySort,
                filteredAudiobookUiStatesResult,
                allAudiobookUiStatesResult,
              );
            } else {
              return _getErrorIndicatorWidget(context);
            }
          } else {
            return _getDataWidget(
              audiobookLanguage,
              audiobookFilter,
              audiobookLibrarySort,
              filteredAudiobookUiStatesResult,
              allAudiobookUiStatesResult,
            );
          }
        },
      ),
    );
  }
}
