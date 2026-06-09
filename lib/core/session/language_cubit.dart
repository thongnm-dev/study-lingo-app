import 'package:bloc/bloc.dart';

import '../constants/learning_language.dart';

/// Holds the study language chosen for the learning session. `null` means the
/// user hasn't picked yet → the home dashboard shows the language picker first.
///
/// App-wide singleton: the home dashboard drives it and other features react to
/// it (e.g. the vocabulary list filters its deck by the session language). Still
/// in-memory — persist via a repository if the choice should survive restarts.
class LanguageCubit extends Cubit<LearningLanguage?> {
  LanguageCubit() : super(null);

  void select(LearningLanguage language) => emit(language);

  /// Return to the picker (e.g. the "Change" action in the app bar).
  void reset() => emit(null);
}
