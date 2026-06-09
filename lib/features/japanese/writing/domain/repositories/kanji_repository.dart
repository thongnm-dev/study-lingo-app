import '../entities/kanji.dart';

/// Supplies the kanji available in the learning feature.
abstract class KanjiRepository {
  Future<List<Kanji>> fetchAll();
}
