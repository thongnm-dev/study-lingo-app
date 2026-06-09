import '../../../../core/constants/learning_language.dart';
import '../../../quiz/domain/entities/quiz_question.dart';
import '../../domain/entities/study_lesson.dart';
import '../../domain/entities/study_lesson_focus.dart';
import '../../domain/entities/study_topic.dart';

/// In-memory seed for themed study content. The shape mirrors what a backend
/// would return so swapping in a real database is a one-line change in the
/// service locator (replace [InMemoryStudyTopicsDataSource] with a remote
/// implementation).
abstract class StudyTopicsLocalDataSource {
  Future<List<StudyTopic>> getTopics();
  Future<List<StudyLesson>> getLessons();
}

class InMemoryStudyTopicsDataSource implements StudyTopicsLocalDataSource {
  const InMemoryStudyTopicsDataSource();

  @override
  Future<List<StudyTopic>> getTopics() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _topics;
  }

  @override
  Future<List<StudyLesson>> getLessons() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _lessons;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Topics
// ────────────────────────────────────────────────────────────────────────────

const _topics = <StudyTopic>[
  // English deck
  StudyTopic(
    id: 'en_daily_conversation',
    language: LearningLanguage.english,
    title: 'Daily Conversation',
    subtitle: 'Hội thoại hằng ngày',
    emoji: '💬',
    lessonCount: 3,
  ),
  StudyTopic(
    id: 'en_office',
    language: LearningLanguage.english,
    title: 'Office',
    subtitle: 'Giao tiếp văn phòng',
    emoji: '💼',
    lessonCount: 3,
  ),
  StudyTopic(
    id: 'en_health',
    language: LearningLanguage.english,
    title: 'Health & Wellness',
    subtitle: 'Sức khỏe & lối sống lành mạnh',
    emoji: '🩺',
    lessonCount: 3,
  ),
  StudyTopic(
    id: 'en_travel',
    language: LearningLanguage.english,
    title: 'Travel',
    subtitle: 'Du lịch',
    emoji: '✈️',
    lessonCount: 2,
  ),
  StudyTopic(
    id: 'en_food',
    language: LearningLanguage.english,
    title: 'Food & Drink',
    subtitle: 'Ăn uống',
    emoji: '🍜',
    lessonCount: 2,
  ),
  // Japanese deck
  StudyTopic(
    id: 'ja_daily_conversation',
    language: LearningLanguage.japanese,
    title: '日常会話',
    subtitle: 'Hội thoại hằng ngày',
    emoji: '💬',
    lessonCount: 3,
  ),
  StudyTopic(
    id: 'ja_office',
    language: LearningLanguage.japanese,
    title: 'オフィス',
    subtitle: 'Giao tiếp văn phòng',
    emoji: '💼',
    lessonCount: 3,
  ),
  StudyTopic(
    id: 'ja_health',
    language: LearningLanguage.japanese,
    title: '健康',
    subtitle: 'Sức khỏe',
    emoji: '🩺',
    lessonCount: 2,
  ),
  StudyTopic(
    id: 'ja_travel',
    language: LearningLanguage.japanese,
    title: '旅行',
    subtitle: 'Du lịch',
    emoji: '✈️',
    lessonCount: 2,
  ),
  StudyTopic(
    id: 'ja_food',
    language: LearningLanguage.japanese,
    title: '食事',
    subtitle: 'Ăn uống',
    emoji: '🍜',
    lessonCount: 2,
  ),
];

// ────────────────────────────────────────────────────────────────────────────
// Lessons
// ────────────────────────────────────────────────────────────────────────────

const _lessons = <StudyLesson>[
  // ── English · Daily Conversation ─────────────────────────────────────
  StudyLesson(
    id: 'en_daily_grammar',
    topicId: 'en_daily_conversation',
    title: 'Ngữ pháp: chào hỏi & câu hỏi cơ bản',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Cách hỏi tên đúng trong tiếng Anh là…',
        options: [
          "What's your name?",
          'How you name?',
          'Where is your name?',
          'Who you?',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '"Bạn khỏe không?" trong tiếng Anh là…',
        options: [
          'You good?',
          'How are you?',
          'You are how?',
          'How you doing be?',
        ],
        correctIndex: 1,
      ),
      QuizQuestion(
        id: 'q3',
        prompt: 'Trả lời lịch sự cho "How are you?" là…',
        options: [
          'I am fine, thank you.',
          'Yes, I am.',
          'My name is Lan.',
          'Goodbye.',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'en_daily_vocab',
    topicId: 'en_daily_conversation',
    title: 'Từ vựng giao tiếp thường ngày',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Hẹn gặp lại" trong tiếng Anh là…',
        options: ['See you later', 'Goodbye forever', 'Hello again', 'Nice'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '"Cảm ơn rất nhiều" trong tiếng Anh là…',
        options: [
          'Thank you very much',
          'Please very much',
          'Sorry very much',
          'You welcome very',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'en_daily_pron',
    topicId: 'en_daily_conversation',
    title: 'Phát âm: âm /θ/ và /ð/',
    focus: StudyLessonFocus.pronunciation,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Từ nào có âm /θ/ (vô thanh, như trong "think")?',
        options: ['thank', 'this', 'that', 'they'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'Từ nào có âm /ð/ (hữu thanh, như trong "this")?',
        options: ['three', 'thin', 'mother', 'thick'],
        correctIndex: 2,
      ),
    ],
  ),

  // ── English · Office ─────────────────────────────────────────────────
  StudyLesson(
    id: 'en_office_grammar',
    topicId: 'en_office',
    title: 'Ngữ pháp: lời đề nghị lịch sự (would/could)',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Yêu cầu lịch sự nhất là…',
        options: [
          'Could you send me the report, please?',
          'Send me report.',
          'You send report now.',
          'Report send to me.',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'Lời mời họp đúng là…',
        options: [
          'Would you like to join the meeting?',
          'You join meeting?',
          'Meeting you come?',
          'Join meeting do you?',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'en_office_vocab',
    topicId: 'en_office',
    title: 'Từ vựng văn phòng',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Cuộc họp" trong tiếng Anh là…',
        options: ['meeting', 'meet', 'metting', 'meetting'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '"Hạn chót" trong tiếng Anh là…',
        options: ['deadline', 'finish line', 'end day', 'limit time'],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'en_office_pron',
    topicId: 'en_office',
    title: 'Phát âm: trọng âm trong từ ghép',
    focus: StudyLessonFocus.pronunciation,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Trọng âm của "DEADline" rơi vào âm tiết nào?',
        options: ['Âm tiết 1 (DEAD)', 'Âm tiết 2 (line)', 'Cả hai', 'Không có'],
        correctIndex: 0,
      ),
    ],
  ),

  // ── English · Health & Wellness ──────────────────────────────────────
  StudyLesson(
    id: 'en_health_grammar',
    topicId: 'en_health',
    title: 'Ngữ pháp: should / shouldn\'t',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Lời khuyên đúng là…',
        options: [
          'You should drink more water.',
          'You drink should water more.',
          'You should drink waters more.',
          'You should to drink water.',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'en_health_vocab',
    topicId: 'en_health',
    title: 'Từ vựng sức khỏe',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Đau đầu" trong tiếng Anh là…',
        options: ['headache', 'headhurt', 'headpain', 'headsick'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '"Tập thể dục" trong tiếng Anh là…',
        options: ['exercise', 'workout time', 'sport play', 'do strong'],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'en_health_pron',
    topicId: 'en_health',
    title: 'Phát âm: âm /ɪ/ và /iː/',
    focus: StudyLessonFocus.pronunciation,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Từ "sick" có âm…',
        options: ['/ɪ/ ngắn', '/iː/ dài', '/aɪ/', '/eɪ/'],
        correctIndex: 0,
      ),
    ],
  ),

  // ── English · Travel ─────────────────────────────────────────────────
  StudyLesson(
    id: 'en_travel_grammar',
    topicId: 'en_travel',
    title: 'Ngữ pháp: hỏi đường',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Câu hỏi đường đúng là…',
        options: [
          'Where is the train station?',
          'Train station where?',
          'The station where is train?',
          'Is train station the where?',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'en_travel_vocab',
    topicId: 'en_travel',
    title: 'Từ vựng du lịch',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Hộ chiếu" trong tiếng Anh là…',
        options: ['passport', 'travel paper', 'ID card', 'visa'],
        correctIndex: 0,
      ),
    ],
  ),

  // ── English · Food & Drink ───────────────────────────────────────────
  StudyLesson(
    id: 'en_food_vocab',
    topicId: 'en_food',
    title: 'Từ vựng món ăn',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Bữa sáng" trong tiếng Anh là…',
        options: ['breakfast', 'morningmeal', 'firstfood', 'sunrise food'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '"Đặt món" trong tiếng Anh là…',
        options: ['order', 'book food', 'ask plate', 'send menu'],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'en_food_grammar',
    topicId: 'en_food',
    title: 'Ngữ pháp: gọi món lịch sự',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Cách gọi món đúng là…',
        options: [
          "I'd like a coffee, please.",
          'Coffee one give me.',
          'You bring coffee.',
          'Coffee is mine please.',
        ],
        correctIndex: 0,
      ),
    ],
  ),

  // ── Japanese · 日常会話 ───────────────────────────────────────────────
  StudyLesson(
    id: 'ja_daily_grammar',
    topicId: 'ja_daily_conversation',
    title: 'Ngữ pháp: です／ます cơ bản',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Tôi là sinh viên." dịch lịch sự là…',
        options: [
          '私は学生です。',
          '私の学生です。',
          '私が学生だ。',
          '学生は私です。',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'Cách hỏi tên lịch sự là…',
        options: [
          'お名前は何ですか。',
          'お前は名前だ。',
          '名前を何ですか。',
          '名前で何ですか。',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'ja_daily_vocab',
    topicId: 'ja_daily_conversation',
    title: 'Từ vựng chào hỏi',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Chào buổi sáng" trong tiếng Nhật là…',
        options: [
          'おはようございます',
          'こんばんは',
          'おやすみなさい',
          'さようなら',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '"Cảm ơn" lịch sự trong tiếng Nhật là…',
        options: [
          'ありがとうございます',
          'すみません',
          'おねがいします',
          'いただきます',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'ja_daily_pron',
    topicId: 'ja_daily_conversation',
    title: 'Phát âm: trường âm',
    focus: StudyLessonFocus.pronunciation,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Từ nào có trường âm?',
        options: ['おばあさん', 'いえ', 'ねこ', 'みず'],
        correctIndex: 0,
      ),
    ],
  ),

  // ── Japanese · オフィス ─────────────────────────────────────────────
  StudyLesson(
    id: 'ja_office_grammar',
    topicId: 'ja_office',
    title: 'Ngữ pháp: kính ngữ cơ bản (お／ご)',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Lịch sự nhất là…',
        options: [
          'お名前をお願いします。',
          '名前をください。',
          '名前を出して。',
          '名前は何だ。',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'ja_office_vocab',
    topicId: 'ja_office',
    title: 'Từ vựng văn phòng',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Cuộc họp" trong tiếng Nhật là…',
        options: ['会議', '会話', '集合', '面接'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: '"Báo cáo" trong tiếng Nhật là…',
        options: ['報告', '広告', '保護', '放送'],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'ja_office_pron',
    topicId: 'ja_office',
    title: 'Phát âm: âm cao thấp (アクセント)',
    focus: StudyLessonFocus.pronunciation,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Từ "はし" mang nghĩa "đôi đũa" có trọng âm rơi vào…',
        options: ['Âm đầu (HA)', 'Âm sau (shi)', 'Cả hai', 'Không có'],
        correctIndex: 0,
      ),
    ],
  ),

  // ── Japanese · 健康 ────────────────────────────────────────────────
  StudyLesson(
    id: 'ja_health_vocab',
    topicId: 'ja_health',
    title: 'Từ vựng sức khỏe',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Bệnh viện" trong tiếng Nhật là…',
        options: ['病院', '医者', '薬局', '看護'],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'ja_health_grammar',
    topicId: 'ja_health',
    title: 'Ngữ pháp: ～た方がいい (nên…)',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Bạn nên uống nhiều nước" dịch là…',
        options: [
          '水をたくさん飲んだ方がいいです。',
          '水を飲みたかったです。',
          '水を飲んでください。',
          '水が好きです。',
        ],
        correctIndex: 0,
      ),
    ],
  ),

  // ── Japanese · 旅行 ────────────────────────────────────────────────
  StudyLesson(
    id: 'ja_travel_vocab',
    topicId: 'ja_travel',
    title: 'Từ vựng du lịch',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Vé" trong tiếng Nhật là…',
        options: ['切符', '紙', '本', '票紙'],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'ja_travel_grammar',
    topicId: 'ja_travel',
    title: 'Ngữ pháp: hỏi đường (どこ／どう)',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Nhà ga ở đâu?" dịch là…',
        options: [
          '駅はどこですか。',
          '駅で何ですか。',
          '駅にどうしますか。',
          '駅をどこですか。',
        ],
        correctIndex: 0,
      ),
    ],
  ),

  // ── Japanese · 食事 ────────────────────────────────────────────────
  StudyLesson(
    id: 'ja_food_vocab',
    topicId: 'ja_food',
    title: 'Từ vựng món ăn',
    focus: StudyLessonFocus.vocabulary,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: '"Cơm" trong tiếng Nhật là…',
        options: ['ご飯', 'パン', '麺', '肉'],
        correctIndex: 0,
      ),
    ],
  ),
  StudyLesson(
    id: 'ja_food_grammar',
    topicId: 'ja_food',
    title: 'Ngữ pháp: gọi món (～をください)',
    focus: StudyLessonFocus.grammar,
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'Gọi "Cho tôi một cốc cà phê" là…',
        options: [
          'コーヒーを一つください。',
          'コーヒーで一つお願い。',
          'コーヒーが一つだ。',
          'コーヒーに一つする。',
        ],
        correctIndex: 0,
      ),
    ],
  ),
];
