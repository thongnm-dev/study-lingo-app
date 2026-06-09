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
  String get navStudy => 'Học';

  @override
  String get navChat => 'Trò chuyện';

  @override
  String get navProfile => 'Hồ sơ';

  @override
  String get studyTitle => 'Học';

  @override
  String get studyPickLanguagePrompt =>
      'Chọn ngôn ngữ bạn muốn học để bắt đầu một chủ đề.';

  @override
  String get studyChooseTopicHint => 'Chọn một kỹ năng để xem các chủ đề.';

  @override
  String get studyChangeLanguage => 'Đổi ngôn ngữ';

  @override
  String get studyTopicsEmpty => 'Chưa có chủ đề nào cho ngôn ngữ này.';

  @override
  String get studyTopicsError => 'Không tải được chủ đề.';

  @override
  String get studyLessonsEmpty => 'Chưa có bài học trong chủ đề này.';

  @override
  String get studyLessonsError => 'Không tải được bài học.';

  @override
  String studyLessonCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bài học',
      one: '1 bài học',
    );
    return '$_temp0';
  }

  @override
  String studyLessonQuestionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count câu hỏi',
      one: '1 câu hỏi',
    );
    return '$_temp0';
  }

  @override
  String get chatTitle => 'Trò chuyện';

  @override
  String get chatComingSoonTitle => 'Sắp ra mắt';

  @override
  String get chatComingSoonSubtitle =>
      'Trò chuyện luyện ngôn ngữ sẽ có mặt trong bản cập nhật tiếp theo.';

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
  String get settingsSectionAppearanceLanguage => 'Giao diện & ngôn ngữ';

  @override
  String get settingsSectionOther => 'Khác';

  @override
  String get settingsLanguageRow => 'Ngôn ngữ';

  @override
  String get settingsDarkMode => 'Chế độ tối';

  @override
  String get settingsDarkModeSubtitle => 'Sử dụng giao diện tối';

  @override
  String get settingsNotificationSettings => 'Cài đặt thông báo';

  @override
  String get settingsNotificationSettingsSubtitle =>
      'Nhắc nhở học tập hằng ngày';

  @override
  String get settingsEmailSummary => 'Email tổng kết';

  @override
  String get settingsEmailSummarySubtitle => 'Nhận email tổng kết tiến độ học';

  @override
  String get settingsPrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get settingsTermsOfService => 'Điều khoản dịch vụ';

  @override
  String get settingsRateApp => 'Đánh giá ứng dụng';

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

  @override
  String get profileVerified => 'Đã xác minh';

  @override
  String get profileSectionAccount => 'Tài khoản';

  @override
  String get profileSectionOther => 'Khác';

  @override
  String get profileEditProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get profileEditProfileSubtitle => 'Cập nhật thông tin cá nhân của bạn';

  @override
  String get profileChangePassword => 'Đổi mật khẩu';

  @override
  String get profileChangePasswordSubtitle => 'Bảo mật tài khoản của bạn';

  @override
  String get profileCoursesList => 'Danh sách khóa học';

  @override
  String get profileCoursesListSubtitle => 'Quản lý các khóa học của bạn';

  @override
  String get profileHelpSupport => 'Trợ giúp & Hỗ trợ';

  @override
  String get profilePrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get profileLogoutConfirm => 'Bạn có chắc chắn muốn đăng xuất?';

  @override
  String get dialogCancel => 'Hủy';

  @override
  String get retry => 'Thử lại';

  @override
  String get unsavedChangesTitle => 'Bỏ thay đổi?';

  @override
  String get unsavedChangesMessage =>
      'Bạn có thay đổi chưa lưu. Bạn có chắc muốn thoát?';

  @override
  String get unsavedChangesKeepEditing => 'Tiếp tục chỉnh sửa';

  @override
  String get unsavedChangesLeave => 'Thoát';

  @override
  String get editProfileTitle => 'Chỉnh sửa hồ sơ';

  @override
  String get editProfileNameLabel => 'Tên hiển thị';

  @override
  String get editProfileNameHint => 'Nhập tên hiển thị';

  @override
  String get editProfilePhotoLabel => 'Ảnh đại diện (URL)';

  @override
  String get editProfilePhotoHint => 'Dán đường dẫn ảnh';

  @override
  String get editProfileGenderLabel => 'Giới tính';

  @override
  String get editProfileGenderMale => 'Nam';

  @override
  String get editProfileGenderFemale => 'Nữ';

  @override
  String get editProfileGenderOther => 'Khác';

  @override
  String get editProfileSave => 'Lưu thay đổi';

  @override
  String get editProfileSaved => 'Đã lưu hồ sơ';
}
