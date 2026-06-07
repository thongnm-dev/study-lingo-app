/// The language the user has chosen to study. Drives which side of the
/// bilingual content is shown as the primary (target) language.
///
/// Pure Dart — no Flutter dependency. Visual representation (icon, color)
/// lives in the presentation layer; see `LearningLanguage.icon` extensions
/// in `overview_page.dart` / `practice_page.dart`. Previously had a `flag`
/// emoji field, but flag emojis render with the host OS's emoji font —
/// Apple style on iOS, Google style on Android, and not at all on some
/// older Androids — which broke the app's "looks identical everywhere"
/// goal.
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
