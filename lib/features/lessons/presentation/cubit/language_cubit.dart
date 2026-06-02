import 'package:bloc/bloc.dart';

import '../../domain/entities/learning_language.dart';

/// Holds the study language chosen for the lessons flow. `null` means the user
/// hasn't picked yet → the lessons tab shows the language picker first.
///
/// Scoped to the lessons tab for now; lift to the app root (and persist) if
/// other features need to react to the chosen language.
class LanguageCubit extends Cubit<LearningLanguage?> {
  LanguageCubit() : super(null);

  void select(LearningLanguage language) => emit(language);

  /// Return to the picker (e.g. the "Change" action in the app bar).
  void reset() => emit(null);
}
