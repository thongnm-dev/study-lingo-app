import '../../../../core/constants/learning_language.dart';
import '../../../quiz/domain/entities/quiz_question.dart';
import '../../domain/entities/course_unit.dart';
import '../../domain/entities/lesson_node.dart';

abstract class LearningPathLocalDataSource {
  List<CourseUnit> getUnits(LearningLanguage language);
}

class InMemoryLearningPathDataSource implements LearningPathLocalDataSource {
  const InMemoryLearningPathDataSource();

  @override
  List<CourseUnit> getUnits(LearningLanguage language) => switch (language) {
    LearningLanguage.english => _englishUnits,
    LearningLanguage.japanese => _japaneseUnits,
  };
}

// ── Helpers ────────────────────────────────────────────────────────────────

LessonNode _lesson(String id, NodeState s, String t,
        [List<QuizQuestion> q = const []]) =>
    LessonNode(id: id, kind: NodeKind.lesson, state: s, title: t, questions: q);

LessonNode _chest(String id, NodeState s) => LessonNode(
      id: id,
      kind: NodeKind.chest,
      state: s,
      title: 'Rương phần thưởng',
    );

LessonNode _trophy(String id, NodeState s,
        [List<QuizQuestion> q = const []]) =>
    LessonNode(
      id: id,
      kind: NodeKind.trophy,
      state: s,
      title: 'Bài kiểm tra đơn vị',
      questions: q,
    );

QuizQuestion _q(String id, String prompt, List<String> opts, int correct,
        [String? explanation]) =>
    QuizQuestion(
      id: id,
      prompt: prompt,
      options: opts,
      correctIndex: correct,
      explanation: explanation,
    );

// ── English seed data ──────────────────────────────────────────────────────

final _englishUnits = <CourseUnit>[
  CourseUnit(
    id: 'en_u1',
    index: 1,
    title: 'Chào hỏi & Làm quen',
    emoji: '👋',
    nodes: [
      _lesson('en_u1_l1', NodeState.done, 'Xin chào & Tạm biệt', [
        _q('en1_1', '"Good morning" nghĩa là gì?',
            ['Chào buổi sáng', 'Chào buổi tối', 'Tạm biệt', 'Cảm ơn'], 0),
        _q('en1_2', 'Dịch: "Goodbye"',
            ['Xin chào', 'Tạm biệt', 'Xin lỗi', 'Cảm ơn'], 1),
        _q('en1_3', '"Hello" dùng khi nào?',
            ['Chào hỏi', 'Tạm biệt', 'Xin lỗi', 'Cảm ơn'], 0),
      ]),
      _lesson('en_u1_l2', NodeState.done, 'Bạn tên là gì?', [
        _q('en2_1', '"What is your name?" nghĩa là gì?',
            ['Bạn bao nhiêu tuổi?', 'Bạn tên gì?', 'Bạn ở đâu?', 'Bạn khoẻ không?'], 1),
        _q('en2_2', 'Trả lời: "My name is ___"',
            ['I am', 'My name is', 'You are', 'He is'], 1),
        _q('en2_3', '"Nice to meet you" nghĩa là gì?',
            ['Tạm biệt', 'Rất vui được gặp bạn', 'Cảm ơn bạn', 'Xin lỗi'], 1),
      ]),
      _lesson('en_u1_l3', NodeState.done, 'Lịch sự & Cảm ơn', [
        _q('en3_1', '"Thank you" nghĩa là gì?',
            ['Xin lỗi', 'Cảm ơn', 'Xin chào', 'Tạm biệt'], 1),
        _q('en3_2', '"Please" trong tiếng Việt là gì?',
            ['Làm ơn', 'Cảm ơn', 'Xin lỗi', 'Tạm biệt'], 0),
        _q('en3_3', '"Excuse me" dùng khi nào?',
            ['Xin phép / Xin lỗi', 'Cảm ơn', 'Chào hỏi', 'Tạm biệt'], 0),
      ]),
      _lesson('en_u1_l4', NodeState.done, 'Ôn tập chào hỏi', [
        _q('en4_1', 'Chọn câu chào đúng buổi tối:',
            ['Good morning', 'Good evening', 'Good night', 'Goodbye'], 1),
        _q('en4_2', '"See you later" nghĩa là gì?',
            ['Hẹn gặp lại', 'Xin chào', 'Cảm ơn', 'Rất vui'], 0),
        _q('en4_3', '"How are you?" dùng để:',
            ['Hỏi thăm sức khoẻ', 'Tạm biệt', 'Cảm ơn', 'Xin lỗi'], 0),
      ]),
      _chest('en_u1_c', NodeState.done),
    ],
  ),
  CourseUnit(
    id: 'en_u2',
    index: 2,
    title: 'Gia đình & Bạn bè',
    emoji: '👨‍👩‍👧',
    nodes: [
      _lesson('en_u2_l1', NodeState.done, 'Thành viên gia đình', [
        _q('en5_1', '"Mother" nghĩa là gì?',
            ['Bố', 'Mẹ', 'Anh trai', 'Chị gái'], 1),
        _q('en5_2', '"Brother" là gì?',
            ['Chị gái', 'Em gái', 'Anh/em trai', 'Bố'], 2),
        _q('en5_3', '"Family" nghĩa là gì?',
            ['Bạn bè', 'Gia đình', 'Trường học', 'Công ty'], 1),
      ]),
      _lesson('en_u2_l2', NodeState.done, 'Đại từ sở hữu', [
        _q('en6_1', '"My" nghĩa là gì?',
            ['Của tôi', 'Của bạn', 'Của anh ấy', 'Của cô ấy'], 0),
        _q('en6_2', 'Chọn đúng: "This is ___ book" (tôi)',
            ['my', 'your', 'his', 'her'], 0),
        _q('en6_3', '"Their" nghĩa là gì?',
            ['Của tôi', 'Của bạn', 'Của họ', 'Của chúng tôi'], 2),
      ]),
      _lesson('en_u2_l3', NodeState.current, 'Giới thiệu gia đình', [
        _q('en7_1', '"This is my sister" nghĩa là gì?',
            ['Đây là anh tôi', 'Đây là chị/em gái tôi', 'Đây là mẹ tôi', 'Đây là bố tôi'], 1),
        _q('en7_2', 'Dịch: "I have two brothers"',
            ['Tôi có hai chị gái', 'Tôi có hai anh/em trai', 'Tôi có hai bạn', 'Tôi có hai con'], 1),
        _q('en7_3', '"She is my grandmother" nghĩa là gì?',
            ['Bà nội/ngoại tôi', 'Mẹ tôi', 'Chị tôi', 'Cô tôi'], 0),
      ]),
      _lesson('en_u2_l4', NodeState.locked, 'Miêu tả người thân'),
      _lesson('en_u2_l5', NodeState.locked, 'Bạn bè & đồng nghiệp'),
      _trophy('en_u2_t', NodeState.locked),
    ],
  ),
  CourseUnit(
    id: 'en_u3',
    index: 3,
    title: 'Đồ ăn & Thức uống',
    emoji: '🍜',
    nodes: [
      _lesson('en_u3_l1', NodeState.locked, 'Món ăn yêu thích'),
      _lesson('en_u3_l2', NodeState.locked, 'Gọi món ở nhà hàng'),
      _chest('en_u3_c', NodeState.locked),
      _lesson('en_u3_l3', NodeState.locked, 'Đồ uống & tráng miệng'),
      _trophy('en_u3_t', NodeState.locked),
    ],
  ),
  CourseUnit(
    id: 'en_u4',
    index: 4,
    title: 'Du lịch & Phương hướng',
    emoji: '✈️',
    nodes: [
      _lesson('en_u4_l1', NodeState.locked, 'Hỏi & chỉ đường'),
      _lesson('en_u4_l2', NodeState.locked, 'Phương tiện di chuyển'),
      _trophy('en_u4_t', NodeState.locked),
    ],
  ),
];

// ── Japanese seed data ─────────────────────────────────────────────────────

final _japaneseUnits = <CourseUnit>[
  CourseUnit(
    id: 'ja_u1',
    index: 1,
    title: 'Hiragana cơ bản',
    emoji: 'あ',
    nodes: [
      _lesson('ja_u1_l1', NodeState.done, 'Hàng あ (a-i-u-e-o)', [
        _q('ja1_1', 'Chữ「あ」đọc là gì?', ['a', 'i', 'u', 'e'], 0),
        _q('ja1_2', 'Chữ「う」đọc là gì?', ['a', 'i', 'u', 'e'], 2),
        _q('ja1_3', 'Chữ nào đọc là "e"?', ['あ', 'い', 'う', 'え'], 3),
      ]),
      _lesson('ja_u1_l2', NodeState.done, 'Hàng か & さ', [
        _q('ja2_1', 'Chữ「か」đọc là gì?', ['ka', 'sa', 'ta', 'na'], 0),
        _q('ja2_2', 'Chữ「し」đọc là gì?', ['ki', 'shi', 'chi', 'ni'], 1),
        _q('ja2_3', 'Chữ nào đọc là "su"?', ['く', 'す', 'つ', 'ぬ'], 1),
      ]),
      _lesson('ja_u1_l3', NodeState.done, 'Hàng た & な', [
        _q('ja3_1', 'Chữ「た」đọc là gì?', ['ta', 'na', 'ha', 'ma'], 0),
        _q('ja3_2', 'Chữ「に」đọc là gì?', ['ti', 'ni', 'hi', 'mi'], 1),
        _q('ja3_3', 'Chữ nào đọc là "no"?', ['と', 'の', 'ほ', 'も'], 1),
      ]),
      _lesson('ja_u1_l4', NodeState.done, 'Ôn tập Hiragana', [
        _q('ja4_1', '「おはよう」viết bằng chữ gì?',
            ['Hiragana', 'Katakana', 'Kanji', 'Romaji'], 0),
        _q('ja4_2', 'Chữ「き」đọc là gì?', ['ka', 'ki', 'ku', 'ke'], 1),
        _q('ja4_3', 'Chữ nào đọc là "te"?', ['た', 'て', 'と', 'つ'], 1),
      ]),
      _chest('ja_u1_c', NodeState.done),
    ],
  ),
  CourseUnit(
    id: 'ja_u2',
    index: 2,
    title: 'Chào hỏi (Aisatsu)',
    emoji: 'こ',
    nodes: [
      _lesson('ja_u2_l1', NodeState.done, 'Konnichiwa & Sayōnara', [
        _q('ja5_1', '「こんにちは」dùng khi nào?',
            ['Buổi sáng', 'Ban ngày', 'Buổi tối', 'Khi đi ngủ'], 1),
        _q('ja5_2', '「さようなら」nghĩa là gì?',
            ['Xin chào', 'Tạm biệt', 'Cảm ơn', 'Xin lỗi'], 1),
        _q('ja5_3', '「おはようございます」là gì?',
            ['Chào buổi sáng (lịch sự)', 'Chào buổi tối', 'Tạm biệt', 'Xin lỗi'], 0),
      ]),
      _lesson('ja_u2_l2', NodeState.current, 'Giới thiệu bản thân', [
        _q('ja6_1', '「わたしは＿＿です」dùng để:',
            ['Giới thiệu tên', 'Hỏi tuổi', 'Hỏi đường', 'Tạm biệt'], 0),
        _q('ja6_2', '「はじめまして」nghĩa là gì?',
            ['Tạm biệt', 'Rất vui được gặp bạn', 'Cảm ơn', 'Xin lỗi'], 1),
        _q('ja6_3', '「よろしくおねがいします」dùng khi:',
            ['Nhờ vả ai đó', 'Gặp gỡ lần đầu', 'Tạm biệt', 'Cả A và B'], 3),
      ]),
      _lesson('ja_u2_l3', NodeState.locked, 'Arigatō & lịch sự'),
      _lesson('ja_u2_l4', NodeState.locked, 'Hỏi thăm sức khoẻ'),
      _lesson('ja_u2_l5', NodeState.locked, 'Ôn tập chào hỏi'),
      _trophy('ja_u2_t', NodeState.locked),
    ],
  ),
  CourseUnit(
    id: 'ja_u3',
    index: 3,
    title: 'Số đếm & Thời gian',
    emoji: '数',
    nodes: [
      _lesson('ja_u3_l1', NodeState.locked, 'Số đếm 1–10'),
      _lesson('ja_u3_l2', NodeState.locked, 'Số đếm 11–100'),
      _chest('ja_u3_c', NodeState.locked),
      _lesson('ja_u3_l3', NodeState.locked, 'Giờ & ngày tháng'),
      _trophy('ja_u3_t', NodeState.locked),
    ],
  ),
  CourseUnit(
    id: 'ja_u4',
    index: 4,
    title: 'Gia đình (Kazoku)',
    emoji: '家',
    nodes: [
      _lesson('ja_u4_l1', NodeState.locked, 'Thành viên gia đình'),
      _lesson('ja_u4_l2', NodeState.locked, 'Miêu tả người thân'),
      _trophy('ja_u4_t', NodeState.locked),
    ],
  ),
];
