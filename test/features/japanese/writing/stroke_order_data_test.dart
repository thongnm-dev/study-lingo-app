import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/japanese/writing/presentation/widgets/stroke_order_data.dart';

void main() {
  group('stroke order data', () {
    test('authored glyphs return stroke paths, others return null', () {
      expect(strokeOrderFor('山'), isNotNull);
      expect(strokeOrderFor('し'), isNotNull);
      expect(strokeOrderFor('あ'), isNull); // not authored
    });

    test('stroke counts match the character', () {
      expect(strokeOrderFor('一')!.length, 1);
      expect(strokeOrderFor('二')!.length, 2);
      expect(strokeOrderFor('三')!.length, 3);
      expect(strokeOrderFor('川')!.length, 3);
    });

    test('every stroke has at least one point', () {
      for (final strokes in kStrokeOrder.values) {
        expect(strokes, isNotEmpty);
        expect(strokes.every((s) => s.isNotEmpty), isTrue);
      }
    });
  });
}
