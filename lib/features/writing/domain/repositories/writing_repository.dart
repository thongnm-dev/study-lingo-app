import '../entities/japanese_script.dart';
import '../entities/writing_character.dart';

/// Supplies the characters to practice for a given [JapaneseScript].
abstract class WritingRepository {
  Future<List<WritingCharacter>> charactersFor(JapaneseScript script);
}
