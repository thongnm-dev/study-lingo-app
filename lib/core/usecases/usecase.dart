import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../utils/failure.dart';

/// Single-purpose business operation invoked by Blocs/Cubits.
///
/// `T` is the success payload, `P` is the input. Use [NoParams] when the
/// operation takes no arguments. Returning `Either<Failure, T>` keeps error
/// handling explicit at the call site instead of leaking exceptions into the
/// presentation layer.
abstract class UseCase<T, P> {
  const UseCase();

  Future<Either<Failure, T>> call(P params);
}

/// Like [UseCase] but for streams (e.g. progress watchers). The stream itself
/// is the success payload; setup errors land in Left.
abstract class StreamUseCase<T, P> {
  const StreamUseCase();

  Either<Failure, Stream<T>> call(P params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
