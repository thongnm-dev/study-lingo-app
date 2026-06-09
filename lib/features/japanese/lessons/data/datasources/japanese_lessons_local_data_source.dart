import '../../../../../core/constants/learning_skill.dart';
import '../../../../quiz/domain/entities/quiz_question.dart';
import '../../domain/entities/japanese_lesson.dart';
import '../../domain/entities/japanese_topic.dart';

/// In-memory seed content for the Japanese learning track. Language-scoped so
/// the japanese/ feature can evolve its content shape independently from
/// english/. Replace this with a bundled JSON asset or remote fetch without
/// touching the repository's callers.
abstract class JapaneseLessonsLocalDataSource {
  Future<List<JapaneseTopic>> getTopics();
  Future<List<JapaneseLesson>> getLessons();
}

class InMemoryJapaneseLessonsDataSource
    implements JapaneseLessonsLocalDataSource {
  const InMemoryJapaneseLessonsDataSource();

  @override
  Future<List<JapaneseTopic>> getTopics() async => _topics;

  @override
  Future<List<JapaneseLesson>> getLessons() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _lessons;
  }
}

const _topics = <JapaneseTopic>[
  // Từ vựng (vocabulary)
  JapaneseTopic(
    id: 't_greetings',
    skill: LearningSkill.vocabulary,
    title: '挨拶',
    emoji: '👋',
    lessonCount: 2,
  ),
  JapaneseTopic(
    id: 't_food',
    skill: LearningSkill.vocabulary,
    title: '食べ物',
    emoji: '🍜',
    lessonCount: 1,
  ),
  JapaneseTopic(
    id: 't_travel',
    skill: LearningSkill.vocabulary,
    title: '旅行',
    emoji: '✈️',
    lessonCount: 1,
  ),
  // Ngữ pháp (grammar)
  JapaneseTopic(
    id: 't_grammar_basics',
    skill: LearningSkill.grammar,
    title: '文の基本',
    emoji: '🧩',
    lessonCount: 1,
  ),
  // Nghe nói (listening & speaking)
  JapaneseTopic(
    id: 't_ls_convo',
    skill: LearningSkill.listeningSpeaking,
    title: '会話',
    emoji: '💬',
    lessonCount: 1,
  ),
  // Đọc (reading)
  JapaneseTopic(
    id: 't_read_signs',
    skill: LearningSkill.reading,
    title: '標識',
    emoji: '🪧',
    lessonCount: 1,
  ),
  // Viết (writing)
  JapaneseTopic(
    id: 't_write_basics',
    skill: LearningSkill.writing,
    title: '書き方',
    emoji: '✏️',
    lessonCount: 1,
  ),
];

/// Learning Japanese: answers are Japanese words/expressions.
const _lessons = <JapaneseLesson>[
  JapaneseLesson(
    id: 'l_greet_basics',
    topicId: 't_greetings',
    title: '基本の挨拶',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: "How do you say 'Good morning' in Japanese?",
        options: ['おはよう', 'こんばんは', 'さようなら', 'ありがとう'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '「こんにちは」 means…',
        options: ['Good night', 'Hello / Good afternoon', 'Goodbye', 'Sorry'],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q3',
        prompt: "Which word means 'Thank you'?",
        options: ['すみません', 'おはよう', 'ありがとう', 'はい'],
        correctIndex: 2,
        explanation: '「ありがとう」 (arigatou) is the casual form of thanks.',
      ),
    ],
  ),
  JapaneseLesson(
    id: 'l_greet_polite',
    topicId: 't_greetings',
    title: '丁寧な表現',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: "Polite way to say 'Excuse me / Sorry'?",
        options: ['すみません', 'やった', 'おはよう', 'うん'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '「はじめまして」 is used when…',
        options: [
          'leaving a room',
          'meeting someone for the first time',
          'apologizing',
          'eating',
        ],
        correctIndex: 1,
      ),
    ],
  ),
  JapaneseLesson(
    id: 'l_food_basics',
    topicId: 't_food',
    title: 'レストランで',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: "How do you say 'water' in Japanese?",
        options: ['お茶', '水', 'ご飯', 'パン'],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '「いただきます」 is said…',
        options: [
          'before eating',
          'after eating',
          'when paying',
          'when cooking',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q3',
        prompt: '「ご飯」 means…',
        options: ['bread', 'tea', 'rice / meal', 'fish'],
        correctIndex: 2,
      ),
    ],
  ),
  JapaneseLesson(
    id: 'l_travel_basics',
    topicId: 't_travel',
    title: '移動する',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '「駅」 means…',
        options: ['airport', 'station', 'hotel', 'street'],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: "How do you ask 'Where is…?' politely?",
        options: ['…はどこですか', '…をください', '…がすきです', '…はなんですか'],
        correctIndex: 0,
      ),
    ],
  ),
  JapaneseLesson(
    id: 'l_grammar_basics',
    topicId: 't_grammar_basics',
    title: '助詞と語順',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Which particle marks the topic of a sentence?',
        options: ['は (wa)', 'を (o)', 'で (de)', 'と (to)'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'In a Japanese sentence, the verb usually comes…',
        options: ['at the end', 'at the start', 'after the topic', 'anywhere'],
        correctIndex: 0,
      ),
    ],
  ),
  JapaneseLesson(
    id: 'l_ls_convo',
    topicId: 't_ls_convo',
    title: '日常の返事',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'A natural reply to 「お元気ですか」?',
        options: ['はい、元気です', 'さようなら', 'いただきます', 'おやすみ'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'Someone says 「ありがとう」. You reply…',
        options: ['どういたしまして', 'こんにちは', 'すみません', 'はい'],
        correctIndex: 0,
      ),
    ],
  ),
  JapaneseLesson(
    id: 'l_read_signs',
    topicId: 't_read_signs',
    title: '標識を読む',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'A sign reads 「出口」. It means…',
        options: ['Exit', 'Entrance', 'Toilet', 'Stop'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '「危険」 on a sign means…',
        options: ['Danger', 'Welcome', 'Open', 'Free'],
        correctIndex: 0,
      ),
    ],
  ),
  JapaneseLesson(
    id: 'l_write_basics',
    topicId: 't_write_basics',
    title: 'かなと漢字',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Which of these is a hiragana character?',
        options: ['あ', 'A', '7', '#'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'The kanji for "mountain" is…',
        options: ['山', '川', '日', '木'],
        correctIndex: 0,
      ),
    ],
  ),
];
