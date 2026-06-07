import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'config/di/service_locator.dart';
import 'core/bloc/app_bloc_observer.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  setupServiceLocator();
  runApp(const StudyLingoApp());
}
