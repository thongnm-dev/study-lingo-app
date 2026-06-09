import '../../domain/entities/japanese_vocabulary_word.dart';

/// Local, in-memory source of Japanese vocabulary. Swap the body for a real
/// source (bundled JSON, sqlite, remote API) without touching the repository's
/// callers.
abstract class JapaneseVocabularyLocalDataSource {
  Future<List<JapaneseVocabularyWord>> getWords();
}

class InMemoryJapaneseVocabularyDataSource
    implements JapaneseVocabularyLocalDataSource {
  const InMemoryJapaneseVocabularyDataSource();

  @override
  Future<List<JapaneseVocabularyWord>> getWords() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      JapaneseVocabularyWord(
        id: 'w_water',
        japanese: '水',
        vietnamese: 'nước',
        furigana: 'みず',
        romaji: 'mizu',
        jlptLevel: 5,
        exampleJapanese: '毎朝水を飲みます。',
        exampleVietnamese: 'Mỗi sáng tôi uống nước.',
      ),
      JapaneseVocabularyWord(
        id: 'w_school',
        japanese: '学校',
        vietnamese: 'trường học',
        furigana: 'がっこう',
        romaji: 'gakkou',
        jlptLevel: 5,
        exampleJapanese: '私の学校は駅の近くです。',
        exampleVietnamese: 'Trường tôi gần ga.',
      ),
      JapaneseVocabularyWord(
        id: 'w_promise',
        japanese: '約束',
        vietnamese: 'lời hứa',
        furigana: 'やくそく',
        romaji: 'yakusoku',
        jlptLevel: 4,
        exampleJapanese: '約束を守ります。',
        exampleVietnamese: 'Tôi sẽ giữ lời hứa.',
      ),
      JapaneseVocabularyWord(
        id: 'w_experience',
        japanese: '経験',
        vietnamese: 'kinh nghiệm',
        furigana: 'けいけん',
        romaji: 'keiken',
        jlptLevel: 3,
        exampleJapanese: 'それは貴重な経験でした。',
        exampleVietnamese: 'Đó là một kinh nghiệm quý giá.',
      ),
    ];
  }
}
