import '../../../../../core/constants/learning_skill.dart';
import '../../../../quiz/domain/entities/quiz_question.dart';
import '../../domain/entities/english_lesson.dart';
import '../../domain/entities/english_topic.dart';

/// In-memory seed content for the English learning track. The data source is
/// language-scoped so the english/ feature can evolve its content shape
/// independently from japanese/. Replace this with a bundled JSON asset or
/// remote fetch without touching the repository's callers.
abstract class EnglishLessonsLocalDataSource {
  Future<List<EnglishTopic>> getTopics();
  Future<List<EnglishLesson>> getLessons();
}

class InMemoryEnglishLessonsDataSource implements EnglishLessonsLocalDataSource {
  const InMemoryEnglishLessonsDataSource();

  @override
  Future<List<EnglishTopic>> getTopics() async => _topics;

  @override
  Future<List<EnglishLesson>> getLessons() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _lessons;
  }
}

const _topics = <EnglishTopic>[
  // Từ vựng (vocabulary)
  EnglishTopic(
    id: 't_greetings',
    skill: LearningSkill.vocabulary,
    title: 'Greetings',
    emoji: '👋',
    lessonCount: 2,
  ),
  EnglishTopic(
    id: 't_food',
    skill: LearningSkill.vocabulary,
    title: 'Food & Drink',
    emoji: '🍜',
    lessonCount: 1,
  ),
  EnglishTopic(
    id: 't_travel',
    skill: LearningSkill.vocabulary,
    title: 'Travel',
    emoji: '✈️',
    lessonCount: 1,
  ),
  // Ngữ pháp (grammar)
  EnglishTopic(
    id: 't_grammar_basics',
    skill: LearningSkill.grammar,
    title: 'Sentence basics',
    emoji: '🧩',
    lessonCount: 1,
  ),
  // Nghe nói (listening & speaking)
  EnglishTopic(
    id: 't_ls_convo',
    skill: LearningSkill.listeningSpeaking,
    title: 'Conversations',
    emoji: '💬',
    lessonCount: 1,
  ),
  // Đọc (reading)
  EnglishTopic(
    id: 't_read_signs',
    skill: LearningSkill.reading,
    title: 'Signs',
    emoji: '🪧',
    lessonCount: 1,
  ),
  // Viết (writing)
  EnglishTopic(
    id: 't_write_basics',
    skill: LearningSkill.writing,
    title: 'Writing basics',
    emoji: '✏️',
    lessonCount: 1,
  ),
];

/// Learning English: answers are English words; prompts lean on the Japanese
/// the learner already knows (Vietnamese gloss could replace this — see the
/// `mother-tongue-vietnamese` memory; left as-is for now to match the existing
/// seed).
const _lessons = <EnglishLesson>[
  EnglishLesson(
    id: 'l_greet_basics',
    topicId: 't_greetings',
    title: 'Basic greetings',
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
  EnglishLesson(
    id: 'l_greet_polite',
    topicId: 't_greetings',
    title: 'Polite expressions',
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
  EnglishLesson(
    id: 'l_food_basics',
    topicId: 't_food',
    title: 'At the restaurant',
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
  EnglishLesson(
    id: 'l_travel_basics',
    topicId: 't_travel',
    title: 'Getting around',
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
  EnglishLesson(
    id: 'l_grammar_basics',
    topicId: 't_grammar_basics',
    title: 'Plurals & verb agreement',
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
  EnglishLesson(
    id: 'l_ls_convo',
    topicId: 't_ls_convo',
    title: 'Everyday replies',
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
  EnglishLesson(
    id: 'l_read_signs',
    topicId: 't_read_signs',
    title: 'Reading signs',
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
  EnglishLesson(
    id: 'l_write_basics',
    topicId: 't_write_basics',
    title: 'Spelling & capitals',
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
