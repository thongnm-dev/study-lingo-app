// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'StudyLingo';

  @override
  String get navLessons => 'Tổng quan';

  @override
  String get navProgress => 'Tiến độ';

  @override
  String get navVocabulary => 'Từ vựng';

  @override
  String get navMore => 'Thêm';

  @override
  String get moreProfile => 'Hồ sơ';

  @override
  String get morePronunciation => 'Phát âm';

  @override
  String get moreVideoCall => 'Cuộc gọi video';

  @override
  String get morePractice => 'Luyện tập';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsPersonal => 'Cá nhân';

  @override
  String get settingsNotifications => 'Thông báo';

  @override
  String get settingsCourses => 'Khóa học';

  @override
  String get settingsLanguage => 'Ngôn ngữ hiển thị';

  @override
  String get settingsPrivacy => 'Quyền riêng tư';

  @override
  String get settingsLogout => 'Đăng xuất';

  @override
  String get languageSettingsDescription =>
      'Chọn ngôn ngữ hiển thị của ứng dụng. Nội dung bài học không bị ảnh hưởng.';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String profileSignedInWith(String provider) {
    return 'Đăng nhập bằng $provider';
  }

  @override
  String get vocabularyTitle => 'Từ vựng';

  @override
  String get vocabularyAllLevels => 'Tất cả';

  @override
  String get vocabularyEmpty => 'Chưa có từ nào cho bộ lọc này.';

  @override
  String get vocabularyError => 'Đã xảy ra lỗi';

  @override
  String vocabularyStudyingChip(String language) {
    return 'Đang học: $language';
  }

  @override
  String get learningLanguageEnglish => 'Tiếng Anh';

  @override
  String get learningLanguageJapanese => 'Tiếng Nhật';

  @override
  String get profileStreakLabel => 'Chuỗi ngày';

  @override
  String get profileTotalXpLabel => 'Tổng XP';

  @override
  String get profileLessonsLabel => 'Bài học';
}
