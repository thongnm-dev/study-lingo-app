import 'package:flutter/material.dart';

/// Brand and hand-picked accent colors referenced by the theme and feature
/// widgets. The Material 3 [ColorScheme] is derived from [brandSeed]; anything
/// outside that scheme — skill accents, streak/progress badges, social brand
/// marks — lives here so feature widgets never hardcode hex literals.
abstract class AppColors {
  // ---- Brand --------------------------------------------------------------

  static const Color brandSeed = Color(0xFF3A6FF8);

  // ---- Skill-track accents -----------------------------------------------
  // Used by the Overview dashboard's skill cards and the Study lesson list.
  // `skillGrammar` intentionally matches [brandSeed] (grammar is the "primary"
  // skill in the visual hierarchy).

  static const Color skillGrammar = brandSeed;
  static const Color skillVocabulary = Color(0xFF00A86B);
  static const Color skillListeningSpeaking = Color(0xFFF59E0B);
  static const Color skillReading = Color(0xFFEF4444);
  static const Color skillWriting = Color(0xFF8B5CF6);

  // ---- Progress / gamification accents -----------------------------------
  // Streak fire orange and daily-goal green appear on the profile stats row
  // and the reminders/notifications tile in Settings (same warm orange).

  static const Color streak = Color(0xFFFF9600);
  static const Color dailyGoal = Color(0xFF58CC02);

  // ---- Settings tile accents ---------------------------------------------

  static const Color settingsLanguage = Color(0xFF2EC4B6);
  static const Color settingsEmail = Color(0xFF1CB0F6);
  static const Color settingsPrivacy = Color(0xFFA560F0);
  static const Color settingsRate = Color(0xFFFFC800);

  // ---- Social provider brand colors --------------------------------------

  static const Color googleBrand = Color(0xFFDB4437);
  static const Color facebookBrand = Color(0xFF1877F2);
}
