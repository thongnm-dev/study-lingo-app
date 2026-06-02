import '../../domain/entities/learning_language.dart';
import '../../domain/entities/learning_skill.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/topic.dart';

/// In-memory seed content. The quiz set depends on the study language:
/// learning Japanese asks for Japanese answers; learning English asks for
/// English answers (prompts lean on the learner's other language). Lesson
/// metadata (id/topic/titles) is shared across both directions — only the
/// questions differ. Topics are tagged with a [LearningSkill] so the lessons
/// tab can split content into grammar / vocabulary / listening-speaking /
/// reading / writing. Replace these tables with a bundled JSON asset or remote
/// fetch without touching the repository's callers.
abstract class LessonsLocalDataSource {
  Future<List<Lesson>> getLessons(LearningLanguage language);
}

class InMemoryLessonsDataSource implements LessonsLocalDataSource {
  const InMemoryLessonsDataSource();

  @override
  Future<List<Lesson>> getLessons(LearningLanguage language) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return switch (language) {
      LearningLanguage.japanese => _japaneseTargetLessons,
      LearningLanguage.english => _englishTargetLessons,
    };
  }
}

/// Topics are language-agnostic (titles carry both sides) and each belongs to
/// one [LearningSkill]. Same list regardless of study language.
const seedTopics = <Topic>[
  // Từ vựng (vocabulary)
  Topic(
    id: 't_greetings',
    skill: LearningSkill.vocabulary,
    titleEn: 'Greetings',
    titleJa: '挨拶',
    emoji: '👋',
    lessonCount: 2,
  ),
  Topic(
    id: 't_food',
    skill: LearningSkill.vocabulary,
    titleEn: 'Food & Drink',
    titleJa: '食べ物',
    emoji: '🍜',
    lessonCount: 1,
  ),
  Topic(
    id: 't_travel',
    skill: LearningSkill.vocabulary,
    titleEn: 'Travel',
    titleJa: '旅行',
    emoji: '✈️',
    lessonCount: 1,
  ),
  // Ngữ pháp (grammar)
  Topic(
    id: 't_grammar_basics',
    skill: LearningSkill.grammar,
    titleEn: 'Sentence basics',
    titleJa: '文の基本',
    emoji: '🧩',
    lessonCount: 1,
  ),
  // Nghe nói (listening & speaking)
  Topic(
    id: 't_ls_convo',
    skill: LearningSkill.listeningSpeaking,
    titleEn: 'Conversations',
    titleJa: '会話',
    emoji: '💬',
    lessonCount: 1,
  ),
  // Đọc (reading)
  Topic(
    id: 't_read_signs',
    skill: LearningSkill.reading,
    titleEn: 'Signs',
    titleJa: '標識',
    emoji: '🪧',
    lessonCount: 1,
  ),
  // Viết (writing)
  Topic(
    id: 't_write_basics',
    skill: LearningSkill.writing,
    titleEn: 'Writing basics',
    titleJa: '書き方',
    emoji: '✏️',
    lessonCount: 1,
  ),
];

/// Learning Japanese: answers are Japanese words/expressions.
const _japaneseTargetLessons = <Lesson>[
  Lesson(
    id: 'l_greet_basics',
    topicId: 't_greetings',
    titleEn: 'Basic greetings',
    titleJa: '基本の挨拶',
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
  Lesson(
    id: 'l_greet_polite',
    topicId: 't_greetings',
    titleEn: 'Polite expressions',
    titleJa: '丁寧な表現',
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
  Lesson(
    id: 'l_food_basics',
    topicId: 't_food',
    titleEn: 'At the restaurant',
    titleJa: 'レストランで',
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
  Lesson(
    id: 'l_travel_basics',
    topicId: 't_travel',
    titleEn: 'Getting around',
    titleJa: '移動する',
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
  Lesson(
    id: 'l_grammar_basics',
    topicId: 't_grammar_basics',
    titleEn: 'Particles & word order',
    titleJa: '助詞と語順',
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
  Lesson(
    id: 'l_ls_convo',
    topicId: 't_ls_convo',
    titleEn: 'Everyday replies',
    titleJa: '日常の返事',
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
  Lesson(
    id: 'l_read_signs',
    topicId: 't_read_signs',
    titleEn: 'Reading signs',
    titleJa: '標識を読む',
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
  Lesson(
    id: 'l_write_basics',
    topicId: 't_write_basics',
    titleEn: 'Kana & kanji',
    titleJa: 'かなと漢字',
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

/// Learning English: answers are English words; prompts lean on the Japanese
/// the learner already knows. Mirrors [_japaneseTargetLessons] one-for-one.
const _englishTargetLessons = <Lesson>[
  Lesson(
    id: 'l_greet_basics',
    topicId: 't_greetings',
    titleEn: 'Basic greetings',
    titleJa: '基本の挨拶',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '「おはよう」 in English is…',
        options: ['Good morning', 'Good evening', 'Goodbye', 'Thank you'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'How do you say 「こんにちは」 in English?',
        options: ['Good night', 'Hello / Good afternoon', 'Goodbye', 'Sorry'],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q3',
        prompt: 'Which word means 「ありがとう」?',
        options: ['Excuse me', 'Good morning', 'Thank you', 'Yes'],
        correctIndex: 2,
        explanation: "'Thank you' is how you express gratitude in English.",
      ),
    ],
  ),
  Lesson(
    id: 'l_greet_polite',
    topicId: 't_greetings',
    titleEn: 'Polite expressions',
    titleJa: '丁寧な表現',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Polite English for 「すみません」?',
        options: ['Excuse me / Sorry', 'Yay', 'Good morning', 'Yeah'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: "When do you say 'Nice to meet you'?",
        options: [
          'when leaving a room',
          'when meeting someone for the first time',
          'when apologizing',
          'when eating',
        ],
        correctIndex: 1,
      ),
    ],
  ),
  Lesson(
    id: 'l_food_basics',
    topicId: 't_food',
    titleEn: 'At the restaurant',
    titleJa: 'レストランで',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'How do you say 「水」 in English?',
        options: ['Tea', 'Water', 'Rice', 'Bread'],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: "When do you say 'Let's eat / Thanks for the meal' (「いただきます」)?",
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
        prompt: '「ご飯」 in English means…',
        options: ['bread', 'tea', 'rice / meal', 'fish'],
        correctIndex: 2,
      ),
    ],
  ),
  Lesson(
    id: 'l_travel_basics',
    topicId: 't_travel',
    titleEn: 'Getting around',
    titleJa: '移動する',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '「駅」 in English is…',
        options: ['airport', 'station', 'hotel', 'street'],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: "How do you ask for a location 「…はどこですか」 in English?",
        options: ['Where is …?', 'Please give me …', 'I like …', 'What is …?'],
        correctIndex: 0,
      ),
    ],
  ),
  Lesson(
    id: 'l_grammar_basics',
    topicId: 't_grammar_basics',
    titleEn: 'Plurals & verb agreement',
    titleJa: '複数形と動詞',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: "What is the plural of 'child'?",
        options: ['childs', 'children', 'childes', 'child'],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: "Choose the correct form: 'She ___ to school every day.'",
        options: ['go', 'goes', 'going', 'gone'],
        correctIndex: 1,
      ),
    ],
  ),
  Lesson(
    id: 'l_ls_convo',
    topicId: 't_ls_convo',
    titleEn: 'Everyday replies',
    titleJa: '日常の返事',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: "Someone asks 'How are you?'. A natural reply is…",
        options: [
          "I'm fine, thanks",
          'Goodbye',
          "You're welcome",
          'Good night',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: "Someone says 'Thank you.' You reply…",
        options: ["You're welcome", 'Hello', 'Sorry', 'Yes'],
        correctIndex: 0,
      ),
    ],
  ),
  Lesson(
    id: 'l_read_signs',
    topicId: 't_read_signs',
    titleEn: 'Reading signs',
    titleJa: '標識を読む',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'A sign reads 「出口」. In English it is…',
        options: ['Exit', 'Entrance', 'Toilet', 'Stop'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'A sign reads 「危険」. In English it is…',
        options: ['Danger', 'Welcome', 'Open', 'Free'],
        correctIndex: 0,
      ),
    ],
  ),
  Lesson(
    id: 'l_write_basics',
    topicId: 't_write_basics',
    titleEn: 'Spelling & capitals',
    titleJa: 'スペルと大文字',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Which sentence is capitalized correctly?',
        options: [
          'the dog runs.',
          'The dog runs.',
          'the Dog Runs.',
          'THE dog runs.',
        ],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'Pick the correctly spelled word:',
        options: ['recieve', 'receive', 'receeve', 'receve'],
        correctIndex: 1,
      ),
    ],
  ),
];
