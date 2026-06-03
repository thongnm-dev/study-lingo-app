import '../../../lessons/domain/entities/learning_language.dart';
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
      // Japanese-target deck (JLPT-classified, with furigana/romaji).
      VocabularyWord(
        id: 'w_water',
        target: LearningLanguage.japanese,
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
        target: LearningLanguage.japanese,
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
        target: LearningLanguage.japanese,
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
        target: LearningLanguage.japanese,
        english: 'experience',
        japanese: '経験',
        furigana: 'けいけん',
        romaji: 'keiken',
        jlptLevel: 3,
        exampleEnglish: 'It was a valuable experience.',
        exampleJapanese: 'それは貴重な経験でした。',
      ),
      // English-target deck (no JLPT — that classification is Japanese-only).
      VocabularyWord(
        id: 'w_breakfast',
        target: LearningLanguage.english,
        english: 'breakfast',
        japanese: '朝食',
        exampleEnglish: 'I eat breakfast at seven.',
        exampleJapanese: '七時に朝食を食べます。',
      ),
      VocabularyWord(
        id: 'w_weather',
        target: LearningLanguage.english,
        english: 'weather',
        japanese: '天気',
        exampleEnglish: 'The weather is nice today.',
        exampleJapanese: '今日は天気がいいです。',
      ),
      VocabularyWord(
        id: 'w_library',
        target: LearningLanguage.english,
        english: 'library',
        japanese: '図書館',
        exampleEnglish: 'She studies at the library.',
        exampleJapanese: '彼女は図書館で勉強します。',
      ),
      VocabularyWord(
        id: 'w_journey',
        target: LearningLanguage.english,
        english: 'journey',
        japanese: '旅',
        exampleEnglish: 'It was a long journey home.',
        exampleJapanese: '家までの長い旅でした。',
      ),
    ];
  }
}
