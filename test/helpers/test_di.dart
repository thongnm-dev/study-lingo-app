import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/config/di/service_locator.dart';

/// Wires up the production stub/in-memory dependencies for widget tests so
/// pages can resolve `getIt<T>()` calls. Use in setUp/tearDown:
///
/// ```dart
/// setUp(useTestServiceLocator);
/// ```
///
/// Singletons created during a test (LocaleCubit, LanguageCubit, repositories)
/// must not leak into the next test, hence the registered tearDown.
void useTestServiceLocator() {
  setupServiceLocator();
  addTearDown(resetServiceLocator);
}
