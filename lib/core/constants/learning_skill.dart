/// The five skill tracks each language is split into. Pure Dart (no Flutter):
/// the UI maps these to icons/colors. [label] is the Vietnamese display name.
enum LearningSkill {
  grammar(label: 'Ngữ pháp', emoji: '📝'),
  vocabulary(label: 'Từ vựng', emoji: '🔤'),
  listeningSpeaking(label: 'Nghe nói', emoji: '🗣️'),
  reading(label: 'Đọc', emoji: '📖'),
  writing(label: 'Viết', emoji: '✍️');

  const LearningSkill({required this.label, required this.emoji});

  final String label;
  final String emoji;
}
