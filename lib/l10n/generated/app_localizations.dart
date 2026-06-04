import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ja'),
    Locale('vi'),
  ];

  /// Application title
  ///
  /// In vi, this message translates to:
  /// **'StudyLingo'**
  String get appTitle;

  /// Bottom-nav label for the Overview (lessons) tab
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get navLessons;

  /// Bottom-nav label for the Progress tab
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get navProgress;

  /// Bottom-nav label for the Vocabulary tab
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get navVocabulary;

  /// Bottom-nav label for the More (•••) action
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get navMore;

  /// More-menu entry: profile
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get moreProfile;

  /// More-menu entry: pronunciation
  ///
  /// In vi, this message translates to:
  /// **'Phát âm'**
  String get morePronunciation;

  /// More-menu entry: video call
  ///
  /// In vi, this message translates to:
  /// **'Cuộc gọi video'**
  String get moreVideoCall;

  /// More-menu entry: practice quiz
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get morePractice;

  /// Shown on placeholder pages for features not built yet
  ///
  /// In vi, this message translates to:
  /// **'Sắp ra mắt'**
  String get comingSoon;

  /// Settings screen title and the gear-button tooltip
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// Settings category: personal/account
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get settingsPersonal;

  /// Settings category: notifications (study reminders)
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get settingsNotifications;

  /// Settings category: courses
  ///
  /// In vi, this message translates to:
  /// **'Khóa học'**
  String get settingsCourses;

  /// Settings category + screen title: app display language
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ hiển thị'**
  String get settingsLanguage;

  /// Settings category: privacy
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư'**
  String get settingsPrivacy;

  /// Settings action: sign out
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get settingsLogout;

  /// Explanatory text on the display-language screen
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ hiển thị của ứng dụng. Nội dung bài học không bị ảnh hưởng.'**
  String get languageSettingsDescription;

  /// Profile screen title
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profileTitle;

  /// Chip on the profile screen showing the auth provider
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng {provider}'**
  String profileSignedInWith(String provider);

  /// Vocabulary screen title
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get vocabularyTitle;

  /// JLPT filter chip: no level filter
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get vocabularyAllLevels;

  /// Shown when the filtered word list is empty
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ nào cho bộ lọc này.'**
  String get vocabularyEmpty;

  /// Fallback error message on the vocabulary screen
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get vocabularyError;

  /// Chip showing the learning-session language the deck is filtered by
  ///
  /// In vi, this message translates to:
  /// **'Đang học: {language}'**
  String vocabularyStudyingChip(String language);

  /// Display name of the English study language
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get learningLanguageEnglish;

  /// Display name of the Japanese study language
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Nhật'**
  String get learningLanguageJapanese;

  /// Profile stat label: daily streak
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi ngày'**
  String get profileStreakLabel;

  /// Profile stat label: lifetime XP
  ///
  /// In vi, this message translates to:
  /// **'Tổng XP'**
  String get profileTotalXpLabel;

  /// Profile stat label: lessons completed
  ///
  /// In vi, this message translates to:
  /// **'Bài học'**
  String get profileLessonsLabel;
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
      <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
