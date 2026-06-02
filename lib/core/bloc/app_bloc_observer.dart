import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';

/// Logs every Bloc transition and error in debug. Wire it up in main() via
/// `Bloc.observer = const AppBlocObserver();` to get a free audit trail of
/// state changes while developing.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    developer.log('${bloc.runtimeType} $change', name: 'bloc');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log(
      '${bloc.runtimeType} error',
      name: 'bloc',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
