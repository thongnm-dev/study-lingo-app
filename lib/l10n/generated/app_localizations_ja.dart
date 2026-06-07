// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'StudyLingo';

  @override
  String get navLessons => '概要';

  @override
  String get navProgress => '進捗';

  @override
  String get navVocabulary => '単語';

  @override
  String get navMore => 'その他';

  @override
  String get moreProfile => 'プロフィール';

  @override
  String get morePronunciation => '発音';

  @override
  String get moreVideoCall => 'ビデオ通話';

  @override
  String get morePractice => '練習';

  @override
  String get comingSoon => '近日公開';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsPersonal => 'アカウント';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsCourses => 'コース';

  @override
  String get settingsLanguage => '表示言語';

  @override
  String get settingsPrivacy => 'プライバシー';

  @override
  String get settingsLogout => 'ログアウト';

  @override
  String get settingsSectionAppearanceLanguage => '外観と言語';

  @override
  String get settingsSectionOther => 'その他';

  @override
  String get settingsLanguageRow => '言語';

  @override
  String get settingsDarkMode => 'ダークモード';

  @override
  String get settingsDarkModeSubtitle => 'ダークテーマを使用する';

  @override
  String get settingsNotificationSettings => '通知設定';

  @override
  String get settingsNotificationSettingsSubtitle => '毎日の学習リマインダー';

  @override
  String get settingsEmailSummary => 'メール要約';

  @override
  String get settingsEmailSummarySubtitle => '週次の進捗メールを受け取る';

  @override
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsTermsOfService => '利用規約';

  @override
  String get settingsRateApp => 'アプリを評価する';

  @override
  String get languageSettingsDescription =>
      'アプリの表示言語を選択してください。学習コンテンツには影響しません。';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String profileSignedInWith(String provider) {
    return '$providerでログイン中';
  }

  @override
  String get vocabularyTitle => '単語';

  @override
  String get vocabularyAllLevels => 'すべて';

  @override
  String get vocabularyEmpty => 'この条件の単語はまだありません。';

  @override
  String get vocabularyError => 'エラーが発生しました';

  @override
  String vocabularyStudyingChip(String language) {
    return '学習中: $language';
  }

  @override
  String get learningLanguageEnglish => '英語';

  @override
  String get learningLanguageJapanese => '日本語';

  @override
  String get profileStreakLabel => '連続日数';

  @override
  String get profileTotalXpLabel => '合計XP';

  @override
  String get profileLessonsLabel => 'レッスン';

  @override
  String get profileVerified => '認証済み';

  @override
  String get profileSectionAccount => 'アカウント';

  @override
  String get profileSectionOther => 'その他';

  @override
  String get profileEditProfile => 'プロフィールを編集';

  @override
  String get profileEditProfileSubtitle => '個人情報を更新する';

  @override
  String get profileChangePassword => 'パスワードを変更';

  @override
  String get profileChangePasswordSubtitle => 'アカウントを安全に保つ';

  @override
  String get profileCoursesList => 'コース一覧';

  @override
  String get profileCoursesListSubtitle => '受講中のコースを管理する';

  @override
  String get profileHelpSupport => 'ヘルプ＆サポート';

  @override
  String get profilePrivacyPolicy => 'プライバシーポリシー';

  @override
  String get profileLogoutConfirm => 'ログアウトしてもよろしいですか？';

  @override
  String get dialogCancel => 'キャンセル';

  @override
  String get retry => '再試行';

  @override
  String get unsavedChangesTitle => '変更を破棄しますか？';

  @override
  String get unsavedChangesMessage => '保存していない変更があります。本当に画面を離れますか？';

  @override
  String get unsavedChangesKeepEditing => '編集を続ける';

  @override
  String get unsavedChangesLeave => '離れる';
}
