import 'package:bloc/bloc.dart';

import '../../domain/entities/learning_language.dart';

/// Holds the study language chosen for the learning session. `null` means the
/// user hasn't picked yet → the lessons tab shows the language picker first.
///
/// Provided at the app root (main.dart): the lessons tab drives it and other
/// features react to it (e.g. the vocabulary list filters its deck by the
/// session language). Still in-memory — persist via a repository if the choice
/// should survive restarts.
class LanguageCubit extends Cubit<LearningLanguage?> {
  LanguageCubit() : super(null);

  void select(LearningLanguage language) => emit(language);

  /// Return to the picker (e.g. the "Change" action in the app bar).
  void reset() => emit(null);
}
