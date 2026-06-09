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
  String get navLessons => 'Overview';

  @override
  String get navStudy => 'Study';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profile';

  @override
  String get studyTitle => 'Study';

  @override
  String get studyPickLanguagePrompt =>
      'Pick the language you want to study to start a topic.';

  @override
  String get studyChooseTopicHint => 'Choose a skill to see its topics.';

  @override
  String get studyChangeLanguage => 'Change language';

  @override
  String get studyTopicsEmpty => 'No topics for this language yet.';

  @override
  String get studyTopicsError => 'Couldn\'t load topics.';

  @override
  String get studyLessonsEmpty => 'No lessons in this topic yet.';

  @override
  String get studyLessonsError => 'Couldn\'t load lessons.';

  @override
  String studyLessonCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lessons',
      one: '1 lesson',
    );
    return '$_temp0';
  }

  @override
  String studyLessonQuestionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatComingSoonTitle => 'Coming soon';

  @override
  String get chatComingSoonSubtitle =>
      'Conversational practice is on the way in a future update.';

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
  String get settingsSectionAppearanceLanguage => 'Appearance & Language';

  @override
  String get settingsSectionOther => 'Other';

  @override
  String get settingsLanguageRow => 'Language';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsDarkModeSubtitle => 'Use the dark theme';

  @override
  String get settingsNotificationSettings => 'Notification settings';

  @override
  String get settingsNotificationSettingsSubtitle => 'Daily study reminders';

  @override
  String get settingsEmailSummary => 'Email summary';

  @override
  String get settingsEmailSummarySubtitle => 'Receive a weekly progress email';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsTermsOfService => 'Terms of service';

  @override
  String get settingsRateApp => 'Rate the app';

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

  @override
  String get profileVerified => 'Verified';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileSectionOther => 'Other';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get profileEditProfileSubtitle => 'Update your personal information';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileChangePasswordSubtitle => 'Keep your account secure';

  @override
  String get profileCoursesList => 'My courses';

  @override
  String get profileCoursesListSubtitle => 'Manage your enrolled courses';

  @override
  String get profileHelpSupport => 'Help & Support';

  @override
  String get profilePrivacyPolicy => 'Privacy policy';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get unsavedChangesTitle => 'Discard changes?';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get unsavedChangesKeepEditing => 'Keep editing';

  @override
  String get unsavedChangesLeave => 'Leave';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get editProfileNameLabel => 'Display name';

  @override
  String get editProfileNameHint => 'Enter your display name';

  @override
  String get editProfilePhotoLabel => 'Avatar (URL)';

  @override
  String get editProfilePhotoHint => 'Paste an image URL';

  @override
  String get editProfileGenderLabel => 'Gender';

  @override
  String get editProfileGenderMale => 'Male';

  @override
  String get editProfileGenderFemale => 'Female';

  @override
  String get editProfileGenderOther => 'Other';

  @override
  String get editProfileSave => 'Save changes';

  @override
  String get editProfileSaved => 'Profile saved';
}
