import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/core/constants/learning_language.dart';
import 'package:study_lingo/core/utils/failure.dart';
import 'package:study_lingo/features/study/domain/entities/study_topic.dart';
import 'package:study_lingo/features/study/domain/usecases/fetch_study_topics.dart';
import 'package:study_lingo/features/study/presentation/bloc/study_topics_cubit.dart';

class MockFetchStudyTopicsUseCase extends Mock
    implements FetchStudyTopicsUseCase {}

void main() {
  const topic = StudyTopic(
    id: 'en_daily',
    language: LearningLanguage.english,
    title: 'Daily Conversation',
    subtitle: 'Hội thoại',
    emoji: '💬',
    lessonCount: 2,
  );

  late MockFetchStudyTopicsUseCase fetchTopics;

  setUpAll(() {
    registerFallbackValue(LearningLanguage.english);
  });

  setUp(() {
    fetchTopics = MockFetchStudyTopicsUseCase();
  });

  blocTest<StudyTopicsCubit, StudyTopicsState>(
    'load() emits [loading, success] with topics for the requested language',
    setUp: () {
      when(() => fetchTopics(any())).thenAnswer(
        (_) async => const Right<Failure, List<StudyTopic>>([topic]),
      );
    },
    build: () => StudyTopicsCubit(fetchTopics),
    act: (cubit) => cubit.load(LearningLanguage.english),
    expect: () => [
      const StudyTopicsState(
        status: StudyTopicsStatus.loading,
        language: LearningLanguage.english,
      ),
      const StudyTopicsState(
        status: StudyTopicsStatus.success,
        language: LearningLanguage.english,
        topics: [topic],
      ),
    ],
  );

  blocTest<StudyTopicsCubit, StudyTopicsState>(
    'load() emits [loading, failure] when the use case returns a Failure',
    setUp: () {
      when(() => fetchTopics(any())).thenAnswer(
        (_) async => const Left<Failure, List<StudyTopic>>(UnknownFailure('x')),
      );
    },
    build: () => StudyTopicsCubit(fetchTopics),
    act: (cubit) => cubit.load(LearningLanguage.japanese),
    expect: () => [
      const StudyTopicsState(
        status: StudyTopicsStatus.loading,
        language: LearningLanguage.japanese,
      ),
      const StudyTopicsState(
        status: StudyTopicsStatus.failure,
        language: LearningLanguage.japanese,
      ),
    ],
  );
}
