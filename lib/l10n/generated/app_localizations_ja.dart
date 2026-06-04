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
}
