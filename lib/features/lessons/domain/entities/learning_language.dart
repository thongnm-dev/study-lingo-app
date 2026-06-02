/// The language the user has chosen to study. Drives which side of the
/// bilingual content is shown as the primary (target) language.
enum LearningLanguage {
  english(code: 'en', labelEn: 'English', nativeName: 'English', flag: '🇬🇧'),
  japanese(code: 'ja', labelEn: 'Japanese', nativeName: '日本語', flag: '🇯🇵');

  const LearningLanguage({
    required this.code,
    required this.labelEn,
    required this.nativeName,
    required this.flag,
  });

  /// BCP-47-ish language code.
  final String code;

  /// English name of the language (for app-chrome labels).
  final String labelEn;

  /// The language's own name (e.g. 日本語).
  final String nativeName;

  /// Flag emoji used on selection cards.
  final String flag;
}
