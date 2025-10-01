import 'package:command_it/command_it.dart';
import 'package:duck_router/duck_router.dart';
import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/routing/router.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/error_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/loading_indicator.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui/visibility_detector_image.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/viewmodels/discover_view_model.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';
import 'package:uuid/uuid.dart';
import 'package:watch_it/watch_it.dart';

class DiscoverScreen extends WatchingWidget {
  const DiscoverScreen({super.key, required this.viewModel});
  final DiscoverViewModel viewModel;

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
  Widget build(BuildContext context) {
    final refreshDataCommandResults = watch(
      viewModel.refreshDataCommand.results,
    ).value;

    final allAuthorsResult = watch(viewModel.allAuthorsResultVN).value;

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
            if (allAuthorsResult == null) {
              return LoadingIndicator();
            } else {
              switch (allAuthorsResult) {
                case Ok<List<Author>>():
                  return Scaffold(
                    body: SafeArea(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await viewModel.refreshDataCommand
                              .executeWithFuture();
                        },
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.of(
                              context,
                            ).paddingScreenHorizontal,
                            vertical: Dimens.of(context).paddingScreenVertical,
                          ),
                          children: [
                            Text(
                              AppLocalizations.of(context)?.labelAuthors ?? "",
                              style: TextTheme.of(context).headlineLarge,
                            ),
                            SizedBox(height: Dimens.paddingVertical),
                            AuthorGrid(
                              allAuthors: allAuthorsResult.value,
                              viewModel: viewModel,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                case Error<List<Author>>():
                  return _getErrorIndicatorWidget(context);
              }
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
  final String uuid = Uuid().v1();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localImagePath = author.localImagePath;
    final authorId = author.id;

    return InkWell(
      onTap: () {
        DuckRouter.of(context).navigate(to: AuthorLocation(authorId));
      },
      child: SizedBox(
        width: Dimens.authorGridPhotoSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: Dimens.authorItemInsideSpacing,
          children: [
            VisibilityDetectorImage(
              keyString: "${uuid}_discover_${author.id}",
              localImagePath: localImagePath,
              width: Dimens.authorGridPhotoSize,
              height: Dimens.authorGridPhotoSize,
              onVisible: () {
                viewModel.startDownloadAuthorImage(author.id);
              },
              onHidden: () {
                viewModel.cancelDownloadAuthorImage(author.id);
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
