import '../../domain/entities/vocabulary_word.dart';

/// Local, in-memory source of vocabulary. This is seed/placeholder data — swap
/// the body for a real source (bundled JSON asset, sqlite, or a remote API)
/// without touching the repository's callers.
abstract class VocabularyLocalDataSource {
  Future<List<VocabularyWord>> getWords();
}

class InMemoryVocabularyDataSource implements VocabularyLocalDataSource {
  const InMemoryVocabularyDataSource();

  @override
  Future<List<VocabularyWord>> getWords() async {
    // Simulate I/O latency so loading states are exercised in the UI.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      VocabularyWord(
        id: 'w_water',
        english: 'water',
        japanese: '水',
        furigana: 'みず',
        romaji: 'mizu',
        jlptLevel: 5,
        exampleEnglish: 'I drink water every morning.',
        exampleJapanese: '毎朝水を飲みます。',
      ),
      VocabularyWord(
        id: 'w_school',
        english: 'school',
        japanese: '学校',
        furigana: 'がっこう',
        romaji: 'gakkou',
        jlptLevel: 5,
        exampleEnglish: 'My school is near the station.',
        exampleJapanese: '私の学校は駅の近くです。',
      ),
      VocabularyWord(
        id: 'w_promise',
        english: 'promise',
        japanese: '約束',
        furigana: 'やくそく',
        romaji: 'yakusoku',
        jlptLevel: 4,
        exampleEnglish: 'I will keep my promise.',
        exampleJapanese: '約束を守ります。',
      ),
      VocabularyWord(
        id: 'w_experience',
        english: 'experience',
        japanese: '経験',
        furigana: 'けいけん',
        romaji: 'keiken',
        jlptLevel: 3,
        exampleEnglish: 'It was a valuable experience.',
        exampleJapanese: 'それは貴重な経験でした。',
      ),
    ];
  }
}
