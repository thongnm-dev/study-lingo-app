// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StudyLingo';

  @override
  String get navLessons => 'Lessons';

  @override
  String get navProgress => 'Progress';

  @override
  String get navVocabulary => 'Vocabulary';

  @override
  String get navMore => 'More';

  @override
  String get moreProfile => 'Profile';

  @override
  String get morePronunciation => 'Pronunciation';

  @override
  String get moreVideoCall => 'Video call';

  @override
  String get morePractice => 'Practice';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPersonal => 'Personal';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsCourses => 'Courses';

  @override
  String get settingsLanguage => 'Display language';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsLogout => 'Sign out';

  @override
  String get languageSettingsDescription =>
      'Choose the app\'s display language. Lesson content is not affected.';

  @override
  String get profileTitle => 'Profile';

  @override
  String profileSignedInWith(String provider) {
    return 'Signed in with $provider';
  }

  @override
  String get vocabularyTitle => 'Vocabulary';

  @override
  String get vocabularyAllLevels => 'All';

  @override
  String get vocabularyEmpty => 'No words for this filter yet.';

  @override
  String get vocabularyError => 'Something went wrong';

  @override
  String vocabularyStudyingChip(String language) {
    return 'Studying: $language';
  }

  @override
  String get learningLanguageEnglish => 'English';

  @override
  String get learningLanguageJapanese => 'Japanese';

  @override
  String get profileStreakLabel => 'Day streak';

  @override
  String get profileTotalXpLabel => 'Total XP';

  @override
  String get profileLessonsLabel => 'Lessons';
}
