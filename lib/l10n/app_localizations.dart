import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pa'),
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Sikh Audiobooks'**
  String get appTitle;

  /// Error Loading data
  ///
  /// In en, this message translates to:
  /// **'Error loading'**
  String get errorLoading;

  /// Settings Title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for no option selected
  ///
  /// In en, this message translates to:
  /// **'Not Selected'**
  String get labelNotSelected;

  /// Label for Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get labelLanguage;

  /// Label for Theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get labelTheme;

  /// Label for System
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get labelSystem;

  /// Label for Light Theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get labelLight;

  /// Label for Dark Theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get labelDark;

  /// Label for Discover
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get labelDiscover;

  /// Label for My Library
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get labelMyLibrary;

  /// Label for Refresh
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get labelRefresh;

  /// Label for Authors
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get labelAuthors;

  /// Label for About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get labelAbout;

  /// Label for Share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get labelShare;

  /// Label for Filter
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get labelFilter;

  /// Label for All
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get labelAll;

  /// Label for Downloaded
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get labelDownloaded;

  /// Label for Sort
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get labelSort;

  /// Label for Default
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get labelDefault;

  /// Label for Last Played
  ///
  /// In en, this message translates to:
  /// **'Last Played'**
  String get labelLastPlayed;

  /// Label for Title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get labelTitle;

  /// Label for Audiobooks
  ///
  /// In en, this message translates to:
  /// **'Audiobooks'**
  String get labelAudiobooks;

  /// Label for Audibook Duration
  ///
  /// In en, this message translates to:
  /// **'{inHours}h {inMinutes}m'**
  String labelAudiobookDuration(int inHours, int inMinutes);

  /// Label for Audibook Duration Left
  ///
  /// In en, this message translates to:
  /// **'{inHours}h {inMinutes}m left'**
  String labelAudiobookDurationLeft(int inHours, int inMinutes);

  /// Label for View Chapters
  ///
  /// In en, this message translates to:
  /// **'View Chapters'**
  String get labelViewChapters;

  /// Label for Download
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get labelDownload;

  /// Label for Remove Download
  ///
  /// In en, this message translates to:
  /// **'Remove Download'**
  String get labelRemoveDownload;

  /// Label for Add to Library
  ///
  /// In en, this message translates to:
  /// **'Add to Library'**
  String get labelAddToLibrary;

  /// Label for Remove from Library
  ///
  /// In en, this message translates to:
  /// **'Remove from Library'**
  String get labelRemoveFromLibrary;

  /// Label for Bookmarks
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get labelBookmarks;

  /// Label for Read Book
  ///
  /// In en, this message translates to:
  /// **'Read Book'**
  String get labelReadBook;

  /// Label for Author
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get labelAuthor;

  /// Label for no audiboooks found.
  ///
  /// In en, this message translates to:
  /// **'No Audiobooks found. Try adjusting filters.'**
  String get labelNoAudiobooksFound;

  /// Label for Chapters
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get labelChapters;

  /// Message Added To Library
  ///
  /// In en, this message translates to:
  /// **'Added to library'**
  String get messageAddedToLibrary;

  /// Message Error Adding To Libary
  ///
  /// In en, this message translates to:
  /// **'Error adding to library'**
  String get messageErrorAddingToLibrary;

  /// Message Removed From Library
  ///
  /// In en, this message translates to:
  /// **'Removed from library'**
  String get messageRemovedFromLibrary;

  /// Message Error Removing From Library
  ///
  /// In en, this message translates to:
  /// **'Error removing from library'**
  String get messageErrorRemovingFromLibrary;

  /// Message Library Empty
  ///
  /// In en, this message translates to:
  /// **'Library is empty.'**
  String get messageLibraryEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pa':
      return AppLocalizationsPa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
