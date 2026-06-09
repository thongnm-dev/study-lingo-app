/// The aspect a Study lesson reviews. A topic typically has one lesson per
/// focus (grammar / pronunciation / vocabulary). The chip on the lesson card
/// uses [label] (Vietnamese display string).
enum StudyLessonFocus {
  grammar(label: 'Ngữ pháp'),
  pronunciation(label: 'Phát âm'),
  vocabulary(label: 'Từ vựng');

  const StudyLessonFocus({required this.label});

  final String label;
}
