/// The language the user has chosen to study. Used to route between the
/// english/japanese feature slices, drive the session-aware vocabulary deck
/// filter, and label cross-language entry points like the practice picker.
///
/// Pure Dart — no Flutter dependency. The visual representation (icon, color)
/// lives in the presentation layer (see `core/icons/learning_language_icon.dart`).
enum LearningLanguage {
  english(
    code: 'en',
    labelEn: 'English',
    labelVi: 'Tiếng Anh',
    nativeName: 'English',
  ),
  japanese(
    code: 'ja',
    labelEn: 'Japanese',
    labelVi: 'Tiếng Nhật',
    nativeName: '日本語',
  );

  const LearningLanguage({
    required this.code,
    required this.labelEn,
    required this.labelVi,
    required this.nativeName,
  });

  /// BCP-47-ish language code.
  final String code;

  /// English name of the language.
  final String labelEn;

  /// Vietnamese name of the language (for UI chrome).
  final String labelVi;

  /// The language's own name (e.g. 日本語).
  final String nativeName;
}
