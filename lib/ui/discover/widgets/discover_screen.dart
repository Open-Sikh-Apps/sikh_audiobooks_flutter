import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/router.gr.dart';
import 'package:sikh_audiobooks_flutter/ui/author/viewmodels/author_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/error_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/loading_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/visibility_detector_image.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/viewmodels/discover_view_model.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';
import 'package:watch_it/watch_it.dart';

@RoutePage()
class DiscoverScreen extends WatchingWidget {
  const DiscoverScreen({super.key, required this.viewModel});
  final DiscoverViewModel viewModel;

  Widget _getErrorIndicatorWidget(BuildContext context) {
    return ErrorIndicator(
      title: AppLocalizations.of(context)?.errorLoading ?? "",
      label: AppLocalizations.of(context)?.labelRefresh ?? "",
      onPressed: () {
        viewModel.refreshDiscoverDataCommand();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final refreshDiscoverDataCommandResults = watch(
      viewModel.refreshDiscoverDataCommand.results,
    ).value;

    final AsyncSnapshot<List<Author>> allAuthorsSnapshot = watchStream(
      null,
      target: viewModel.allAuthorsStream,
      initialValue: [],
    );

    return AnimatedSwitcher(
      duration: Constants.animatedSwitcherDuration,
      child: refreshDiscoverDataCommandResults.toWidget(
        whileExecuting: (_, _) => LoadingIndicator(),
        onError: (_, _, _) => _getErrorIndicatorWidget(context),
        onData: (result, _) {
          if (result == null) {
            return LoadingIndicator();
          }
          if (result is Error) {
            return _getErrorIndicatorWidget(context);
          } else {
            if (allAuthorsSnapshot.hasError) {
              return _getErrorIndicatorWidget(context);
            } else if (allAuthorsSnapshot.data == null ||
                allAuthorsSnapshot.data == []) {
              return LoadingIndicator();
            } else {
              return Scaffold(
                body: SafeArea(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.of(context).paddingScreenHorizontal,
                      vertical: Dimens.of(context).paddingScreenVertical,
                    ),
                    children: [
                      Text(
                        AppLocalizations.of(context)?.labelAuthors ?? "",
                        style: TextTheme.of(context).headlineLarge,
                      ),
                      SizedBox(height: Dimens.paddingVertical),
                      AuthorGrid(
                        allAuthors: allAuthorsSnapshot.data ?? [],
                        viewModel: viewModel,
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class AuthorGrid extends StatelessWidget {
  const AuthorGrid({
    super.key,
    required this.allAuthors,
    required this.viewModel,
  });
  final DiscoverViewModel viewModel;
  final List<Author> allAuthors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: Dimens.betweenAuthorItemsSpacing,
        runSpacing: Dimens.betweenAuthorItemsSpacing,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          ...allAuthors.map(
            (author) => AuthorItem(author: author, viewModel: viewModel),
          ),
        ],
      ),
    );
  }
}

class AuthorItem extends StatelessWidget {
  AuthorItem({super.key, required this.author, required this.viewModel});
  final DiscoverViewModel viewModel;
  final Author author;
  final _log = Logger();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localImagePath = author.localImagePath;

    return InkWell(
      onTap: () {
        // context.push(Routes.authorWithId(author.id));
        final authorViewModel = AuthorViewModel(
          audiobooksRepository: getIt(),
          id: author.id,
        );
        // context.pushRoute(AuthorRoute(viewModel: authorViewModel));
        _log.d(
          "context.pushRoute\nAuthorRoute(viewModel: authorViewModel)\nauthorViewModel:$authorViewModel",
        );
        context.pushRoute(
          AuthorRoute(viewModel: authorViewModel),
          onFailure: (failure) {
            _log.d("navigation failure$failure");
          },
        );
      },
      child: SizedBox(
        width: Dimens.authorPhotoSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: Dimens.authorItemInsideSpacing,
          children: [
            VisibilityDetectorImage(
              keyString: author.id,
              localImagePath: localImagePath,
              width: Dimens.authorPhotoSize,
              height: Dimens.authorPhotoSize,
              onVisible: () {
                unawaited(viewModel.startDownloadAuthorImage(author.id));
              },
              onHidden: () {
                unawaited(viewModel.cancelDownloadAuthorImage(author.id));
              },
            ),
            Text(
              author.name[locale.languageCode] ?? "",
              style: TextTheme.of(context).titleSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
