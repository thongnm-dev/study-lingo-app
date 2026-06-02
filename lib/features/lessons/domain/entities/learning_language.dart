/// The language the user has chosen to study. Drives which side of the
/// bilingual content is shown as the primary (target) language.
enum LearningLanguage {
  english(code: 'en', labelEn: 'English', labelVi: 'Tiếng Anh', nativeName: 'English', flag: '🇬🇧'),
  japanese(code: 'ja', labelEn: 'Japanese', labelVi: 'Tiếng Nhật', nativeName: '日本語', flag: '🇯🇵');

  const LearningLanguage({
    required this.code,
    required this.labelEn,
    required this.labelVi,
    required this.nativeName,
    required this.flag,
  });

  /// BCP-47-ish language code.
  final String code;

  /// English name of the language.
  final String labelEn;

  /// Vietnamese name of the language (for UI chrome).
  final String labelVi;

  /// The language's own name (e.g. 日本語).
  final String nativeName;

  /// Flag emoji.
  final String flag;
}
