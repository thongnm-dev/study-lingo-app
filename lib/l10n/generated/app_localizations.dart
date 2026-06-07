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

  /// Settings section header grouping language + theme tiles
  ///
  /// In vi, this message translates to:
  /// **'Giao diện & ngôn ngữ'**
  String get settingsSectionAppearanceLanguage;

  /// Settings section header grouping privacy/terms/rate tiles
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get settingsSectionOther;

  /// Language row label inside the settings list (the dedicated screen still uses settingsLanguage as its title)
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get settingsLanguageRow;

  /// Dark-mode switch label
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get settingsDarkMode;

  /// Dark-mode switch helper text
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng giao diện tối'**
  String get settingsDarkModeSubtitle;

  /// Tile that opens the reminders screen
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt thông báo'**
  String get settingsNotificationSettings;

  /// Subtitle for the notification-settings tile
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở học tập hằng ngày'**
  String get settingsNotificationSettingsSubtitle;

  /// Email-summary switch label
  ///
  /// In vi, this message translates to:
  /// **'Email tổng kết'**
  String get settingsEmailSummary;

  /// Email-summary switch helper text
  ///
  /// In vi, this message translates to:
  /// **'Nhận email tổng kết tiến độ học'**
  String get settingsEmailSummarySubtitle;

  /// Tile that opens the privacy-policy page
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get settingsPrivacyPolicy;

  /// Tile that opens the terms-of-service page
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản dịch vụ'**
  String get settingsTermsOfService;

  /// Tile that prompts the user to rate the app
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá ứng dụng'**
  String get settingsRateApp;

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

  /// Verified badge on the profile header card
  ///
  /// In vi, this message translates to:
  /// **'Đã xác minh'**
  String get profileVerified;

  /// Profile section title: account options
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get profileSectionAccount;

  /// Profile section title: other options (help, privacy)
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get profileSectionOther;

  /// Profile option: edit profile
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get profileEditProfile;

  /// Subtitle for the edit-profile option
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin cá nhân của bạn'**
  String get profileEditProfileSubtitle;

  /// Profile option: change password
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get profileChangePassword;

  /// Subtitle for the change-password option
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật tài khoản của bạn'**
  String get profileChangePasswordSubtitle;

  /// Profile option: courses list
  ///
  /// In vi, this message translates to:
  /// **'Danh sách khóa học'**
  String get profileCoursesList;

  /// Subtitle for the courses-list option
  ///
  /// In vi, this message translates to:
  /// **'Quản lý các khóa học của bạn'**
  String get profileCoursesListSubtitle;

  /// Profile option: help and support
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp & Hỗ trợ'**
  String get profileHelpSupport;

  /// Profile option: privacy policy
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get profilePrivacyPolicy;

  /// Confirmation message in the logout dialog
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn đăng xuất?'**
  String get profileLogoutConfirm;

  /// Generic cancel action in dialogs
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get dialogCancel;

  /// Retry button label used by ErrorRetryView
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// Title of the unsaved-changes confirmation dialog
  ///
  /// In vi, this message translates to:
  /// **'Bỏ thay đổi?'**
  String get unsavedChangesTitle;

  /// Body of the unsaved-changes confirmation dialog
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thay đổi chưa lưu. Bạn có chắc muốn thoát?'**
  String get unsavedChangesMessage;

  /// Stay-on-screen action in the unsaved-changes dialog
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục chỉnh sửa'**
  String get unsavedChangesKeepEditing;

  /// Discard-and-leave action in the unsaved-changes dialog
  ///
  /// In vi, this message translates to:
  /// **'Thoát'**
  String get unsavedChangesLeave;
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
