import 'package:flutter/widgets.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Single source of truth for every icon in the app.
///
/// We deliberately do not use Flutter's `Icons.*` (Material) anywhere —
/// those carry the Android look-and-feel. Phosphor is a platform-neutral
/// icon family so the UI looks identical on Android and iOS. To swap the
/// icon family later (Lucide, Iconsax, …), change the right-hand side here
/// and the whole app follows.
///
/// Uses `phosphoricons_flutter` (a Dart-3-compatible fork of the official
/// `phosphor_flutter` package, which still extends Flutter's now-`final`
/// `IconData` and fails to compile).
///
/// Outlined ("regular") variants are the default; the `*Filled` suffix
/// picks the filled weight, used for selected nav states and visual
/// emphasis.
class AppIcons {
  AppIcons._();

  // Bottom navigation
  static const IconData homeOutlined = PhosphorIconsRegular.house;
  static const IconData homeFilled = PhosphorIconsFill.house;
  static const IconData studyOutlined = PhosphorIconsRegular.graduationCap;
  static const IconData studyFilled = PhosphorIconsFill.graduationCap;
  static const IconData chatOutlined = PhosphorIconsRegular.chatCircle;
  static const IconData chatFilled = PhosphorIconsFill.chatCircle;
  static const IconData more = PhosphorIconsRegular.dotsThree;

  // Common chrome
  static const IconData chevronRight = PhosphorIconsRegular.caretRight;
  static const IconData arrowBack = PhosphorIconsRegular.arrowLeft;
  static const IconData arrowForward = PhosphorIconsRegular.arrowRight;
  static const IconData check = PhosphorIconsRegular.check;
  static const IconData checkCircle = PhosphorIconsFill.checkCircle;
  static const IconData cancel = PhosphorIconsFill.xCircle;
  static const IconData errorOutline = PhosphorIconsRegular.warningCircle;
  static const IconData refresh = PhosphorIconsRegular.arrowsClockwise;
  static const IconData replay = PhosphorIconsRegular.arrowCounterClockwise;

  // Auth / forms
  static const IconData email = PhosphorIconsRegular.envelope;
  static const IconData phone = PhosphorIconsRegular.phone;
  static const IconData at = PhosphorIconsRegular.at;
  static const IconData password = PhosphorIconsRegular.key;
  static const IconData lock = PhosphorIconsRegular.lock;
  static const IconData visibility = PhosphorIconsRegular.eye;
  static const IconData visibilityOff = PhosphorIconsRegular.eyeSlash;
  static const IconData google = PhosphorIconsFill.googleLogo;
  static const IconData facebook = PhosphorIconsFill.facebookLogo;
  static const IconData school = PhosphorIconsRegular.graduationCap;
  static const IconData schoolFilled = PhosphorIconsFill.graduationCap;

  // Settings / profile
  static const IconData person = PhosphorIconsRegular.user;
  static const IconData personFilled = PhosphorIconsFill.user;
  static const IconData settings = PhosphorIconsRegular.gear;
  static const IconData notifications = PhosphorIconsRegular.bell;
  static const IconData language = PhosphorIconsRegular.globe;
  static const IconData logout = PhosphorIconsRegular.signOut;
  static const IconData verified = PhosphorIconsFill.sealCheck;
  static const IconData schedule = PhosphorIconsRegular.clock;
  static const IconData darkMode = PhosphorIconsRegular.moon;
  static const IconData shield = PhosphorIconsRegular.shield;
  static const IconData fileText = PhosphorIconsRegular.fileText;
  static const IconData starOutline = PhosphorIconsRegular.star;

  // Progress / gamification
  static const IconData fire = PhosphorIconsFill.fire;
  static const IconData star = PhosphorIconsFill.star;
  static const IconData trophy = PhosphorIconsFill.trophy;
  static const IconData bookOpen = PhosphorIconsRegular.bookOpen;
  static const IconData stories = PhosphorIconsFill.bookOpenText;

  // Lessons / skills
  static const IconData grammar = PhosphorIconsRegular.listChecks;
  static const IconData vocabulary = PhosphorIconsRegular.translate;
  static const IconData listening = PhosphorIconsRegular.headphones;
  static const IconData reading = PhosphorIconsRegular.bookOpen;
  static const IconData writing = PhosphorIconsRegular.pencilSimple;
  static const IconData edit = PhosphorIconsRegular.pencilSimple;
  static const IconData play = PhosphorIconsFill.play;
  static const IconData tap = PhosphorIconsRegular.handTap;
  static const IconData bookmark = PhosphorIconsRegular.bookmark;

  // More-menu actions
  static const IconData speaking = PhosphorIconsFill.microphoneStage;
  static const IconData video = PhosphorIconsFill.videoCamera;
  static const IconData exercise = PhosphorIconsFill.barbell;

  // Lesson-topic emoji fallbacks
  static const IconData greet = PhosphorIconsFill.hand;
  static const IconData food = PhosphorIconsFill.forkKnife;
  static const IconData travel = PhosphorIconsFill.airplane;
  static const IconData puzzle = PhosphorIconsFill.puzzlePiece;
  static const IconData chat = PhosphorIconsFill.chats;
  static const IconData article = PhosphorIconsFill.article;

  // Writing practice
  static const IconData gesture = PhosphorIconsRegular.scribble;
}
