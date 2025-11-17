// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sikh Audiobooks';

  @override
  String get errorLoading => 'Error loading';

  @override
  String get settings => 'Settings';

  @override
  String get labelNotSelected => 'Not Selected';

  @override
  String get labelLanguage => 'Language';

  @override
  String get labelTheme => 'Theme';

  @override
  String get labelSystem => 'System';

  @override
  String get labelLight => 'Light';

  @override
  String get labelDark => 'Dark';

  @override
  String get labelDiscover => 'Discover';

  @override
  String get labelMyLibrary => 'My Library';

  @override
  String get labelRefresh => 'Refresh';

  @override
  String get labelAuthors => 'Authors';

  @override
  String get labelAbout => 'About';

  @override
  String get labelShare => 'Share';

  @override
  String get labelFilter => 'Filter';

  @override
  String get labelAll => 'All';

  @override
  String get labelDownloaded => 'Downloaded';

  @override
  String get labelSort => 'Sort';

  @override
  String get labelDefault => 'Default';

  @override
  String get labelLastPlayed => 'Last Played';

  @override
  String get labelTitle => 'Title';

  @override
  String get labelAudiobooks => 'Audiobooks';

  @override
  String labelAudiobookDuration(int inHours, int inMinutes) {
    return '${inHours}h ${inMinutes}m';
  }

  @override
  String labelAudiobookDurationLeft(int inHours, int inMinutes) {
    return '${inHours}h ${inMinutes}m left';
  }

  @override
  String get labelViewChapters => 'View Chapters';

  @override
  String get labelDownload => 'Download';

  @override
  String get labelRemoveDownload => 'Remove Download';

  @override
  String get labelAddToLibrary => 'Add to Library';

  @override
  String get labelRemoveFromLibrary => 'Remove from Library';

  @override
  String get labelBookmarks => 'Bookmarks';

  @override
  String get labelReadBook => 'Read Book';

  @override
  String get labelAuthor => 'Author';

  @override
  String get labelNoAudiobooksFound =>
      'No Audiobooks found. Try adjusting filters.';

  @override
  String get labelChapters => 'Chapters';

  @override
  String get messageAddedToLibrary => 'Added to library';

  @override
  String get messageErrorAddingToLibrary => 'Error adding to library';

  @override
  String get messageRemovedFromLibrary => 'Removed from library';

  @override
  String get messageErrorRemovingFromLibrary => 'Error removing from library';

  @override
  String get messageLibraryEmpty => 'Library is empty.';

  @override
  String get messageNoConnection => 'No Internet Connection';
}
