import '../../domain/entities/kanji.dart';
import '../../domain/repositories/kanji_repository.dart';

/// Static set of beginner (≈JLPT N5) kanji. Replace with a bundled asset or API
/// without changing callers.
class InMemoryKanjiRepository implements KanjiRepository {
  const InMemoryKanjiRepository();

  @override
  Future<List<Kanji>> fetchAll() async => _kanji;

  static const _kanji = <Kanji>[
    Kanji(
      glyph: '一',
      meaning: 'one',
      onyomi: 'イチ',
      kunyomi: 'ひと(つ)',
      exampleWord: '一月',
      exampleReading: 'いちがつ',
      exampleMeaning: 'January',
    ),
    Kanji(
      glyph: '日',
      meaning: 'sun / day',
      onyomi: 'ニチ・ジツ',
      kunyomi: 'ひ・か',
      exampleWord: '日本',
      exampleReading: 'にほん',
      exampleMeaning: 'Japan',
    ),
    Kanji(
      glyph: '月',
      meaning: 'moon / month',
      onyomi: 'ゲツ・ガツ',
      kunyomi: 'つき',
      exampleWord: '月曜日',
      exampleReading: 'げつようび',
      exampleMeaning: 'Monday',
    ),
    Kanji(
      glyph: '水',
      meaning: 'water',
      onyomi: 'スイ',
      kunyomi: 'みず',
      exampleWord: '水曜日',
      exampleReading: 'すいようび',
      exampleMeaning: 'Wednesday',
    ),
    Kanji(
      glyph: '火',
      meaning: 'fire',
      onyomi: 'カ',
      kunyomi: 'ひ',
      exampleWord: '火山',
      exampleReading: 'かざん',
      exampleMeaning: 'volcano',
    ),
    Kanji(
      glyph: '木',
      meaning: 'tree / wood',
      onyomi: 'モク・ボク',
      kunyomi: 'き',
      exampleWord: '木曜日',
      exampleReading: 'もくようび',
      exampleMeaning: 'Thursday',
    ),
    Kanji(
      glyph: '山',
      meaning: 'mountain',
      onyomi: 'サン',
      kunyomi: 'やま',
      exampleWord: '富士山',
      exampleReading: 'ふじさん',
      exampleMeaning: 'Mt. Fuji',
    ),
    Kanji(
      glyph: '川',
      meaning: 'river',
      onyomi: 'セン',
      kunyomi: 'かわ',
      exampleWord: '川',
      exampleReading: 'かわ',
      exampleMeaning: 'river',
    ),
    Kanji(
      glyph: '人',
      meaning: 'person',
      onyomi: 'ジン・ニン',
      kunyomi: 'ひと',
      exampleWord: '日本人',
      exampleReading: 'にほんじん',
      exampleMeaning: 'Japanese person',
    ),
    Kanji(
      glyph: '大',
      meaning: 'big',
      onyomi: 'ダイ・タイ',
      kunyomi: 'おお(きい)',
      exampleWord: '大学',
      exampleReading: 'だいがく',
      exampleMeaning: 'university',
    ),
    Kanji(
      glyph: '小',
      meaning: 'small',
      onyomi: 'ショウ',
      kunyomi: 'ちい(さい)',
      exampleWord: '小学校',
      exampleReading: 'しょうがっこう',
      exampleMeaning: 'elementary school',
    ),
    Kanji(
      glyph: '口',
      meaning: 'mouth',
      onyomi: 'コウ',
      kunyomi: 'くち',
      exampleWord: '入口',
      exampleReading: 'いりぐち',
      exampleMeaning: 'entrance',
    ),
  ];
}
