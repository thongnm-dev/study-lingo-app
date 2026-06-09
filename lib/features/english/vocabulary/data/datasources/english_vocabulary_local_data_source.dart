import '../../domain/entities/english_vocabulary_word.dart';

/// Local, in-memory source of English vocabulary. Swap the body for a real
/// source (bundled JSON, sqlite, remote API) without touching the repository's
/// callers.
abstract class EnglishVocabularyLocalDataSource {
  Future<List<EnglishVocabularyWord>> getWords();
}

class InMemoryEnglishVocabularyDataSource
    implements EnglishVocabularyLocalDataSource {
  const InMemoryEnglishVocabularyDataSource();

  @override
  Future<List<EnglishVocabularyWord>> getWords() async {
    // Simulate I/O latency so loading states are exercised in the UI.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      EnglishVocabularyWord(
        id: 'w_breakfast',
        english: 'breakfast',
        vietnamese: 'bữa sáng',
        exampleEnglish: 'I eat breakfast at seven.',
        exampleVietnamese: 'Tôi ăn sáng lúc bảy giờ.',
      ),
      EnglishVocabularyWord(
        id: 'w_weather',
        english: 'weather',
        vietnamese: 'thời tiết',
        exampleEnglish: 'The weather is nice today.',
        exampleVietnamese: 'Hôm nay thời tiết đẹp.',
      ),
      EnglishVocabularyWord(
        id: 'w_library',
        english: 'library',
        vietnamese: 'thư viện',
        exampleEnglish: 'She studies at the library.',
        exampleVietnamese: 'Cô ấy học ở thư viện.',
      ),
      EnglishVocabularyWord(
        id: 'w_journey',
        english: 'journey',
        vietnamese: 'chuyến đi',
        exampleEnglish: 'It was a long journey home.',
        exampleVietnamese: 'Đó là một chuyến về nhà rất dài.',
      ),
    ];
  }
}
