import '../../../../core/constants/learning_language.dart';
import '../../domain/entities/course_unit.dart';
import '../../domain/repositories/learning_path_repository.dart';
import '../datasources/learning_path_local_data_source.dart';

class LearningPathRepositoryImpl implements LearningPathRepository {
  final LearningPathLocalDataSource _dataSource;

  const LearningPathRepositoryImpl(this._dataSource);

  @override
  Future<List<CourseUnit>> fetchUnits(LearningLanguage language) async {
    return _dataSource.getUnits(language);
  }
}
