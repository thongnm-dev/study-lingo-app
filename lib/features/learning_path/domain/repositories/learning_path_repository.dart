import '../../../../core/constants/learning_language.dart';
import '../entities/course_unit.dart';

abstract class LearningPathRepository {
  Future<List<CourseUnit>> fetchUnits(LearningLanguage language);
}
