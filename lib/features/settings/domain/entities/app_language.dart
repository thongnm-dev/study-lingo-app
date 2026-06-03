/// The app's display (chrome) languages — distinct from the *learning*
/// languages in the lessons feature. [nativeLabel] is each language's own name
/// (endonym), shown as-is in the picker regardless of the current locale.
enum AppLanguage {
  vietnamese('vi', 'Tiếng Việt'),
  english('en', 'English'),
  japanese('ja', '日本語');

  const AppLanguage(this.code, this.nativeLabel);

  /// ISO 639-1 language code, matching the ARB locales in `lib/l10n/`.
  final String code;
  final String nativeLabel;
}
