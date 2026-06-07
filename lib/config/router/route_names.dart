/// Single source of truth for route paths and names. Use these constants
/// everywhere instead of string literals so a rename is a one-line change.
abstract class RouteNames {
  const RouteNames._();

  // Auth flow
  static const String auth = '/auth';
  static const String forgotPassword = '/auth/forgot';

  // Home shell + branches (one path per bottom-nav tab)
  static const String home = '/home';
  static const String overview = '/home/overview';
  static const String progress = '/home/progress';
  static const String vocabulary = '/home/vocabulary';

  // Lessons / practice
  static const String topics = '/topics';
  static const String lessons = '/lessons';
  static const String quiz = '/quiz';
  static const String practice = '/practice';

  // Profile + settings
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String languageSettings = '/settings/language';
  static const String settingsPlaceholder = '/settings/placeholder';

  // Other feature pages
  static const String reminders = '/reminders';
  static const String writingHome = '/writing';
  static const String characterTracing = '/writing/tracing';
  static const String kanjiList = '/kanji';
  static const String kanjiDetail = '/kanji/detail';
  static const String moreDestination = '/more';
}
