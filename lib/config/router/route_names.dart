/// Single source of truth for route paths and names. Use these constants
/// everywhere instead of string literals so a rename is a one-line change.
abstract class RouteNames {
  const RouteNames._();

  // Auth flow
  static const String auth = '/auth';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot';

  // Home shell + branches (one path per bottom-nav tab)
  static const String home = '/home';
  static const String overview = '/home/overview';
  static const String study = '/home/study';
  static const String chat = '/home/chat';
  static const String profile = '/home/profile';
  static const String editProfile = '/profile/edit';

  // English learning flow
  static const String englishTopics = '/english/topics';
  static const String englishLessons = '/english/lessons';

  // Japanese learning flow
  static const String japaneseTopics = '/japanese/topics';
  static const String japaneseLessons = '/japanese/lessons';

  // Themed Study tab (DB-backed topics across languages)
  static const String studyLessons = '/study/lessons';

  // Shared quiz + practice
  static const String quiz = '/quiz';
  static const String practice = '/practice';

  // Settings
  static const String settings = '/settings';
  static const String languageSettings = '/settings/language';
  static const String settingsPlaceholder = '/settings/placeholder';

  // Other feature pages
  static const String reminders = '/reminders';

  // Japanese writing (hiragana / katakana / kanji)
  static const String japaneseWritingHome = '/japanese/writing';
  static const String japaneseTracing = '/japanese/writing/tracing';
  static const String japaneseKanjiList = '/japanese/writing/kanji';
  static const String japaneseKanjiDetail = '/japanese/writing/kanji/detail';
}
