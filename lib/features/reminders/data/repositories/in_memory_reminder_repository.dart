import '../../domain/entities/reminder_settings.dart';
import '../../domain/repositories/reminder_repository.dart';

class InMemoryReminderRepository implements ReminderRepository {
  ReminderSettings _settings = const ReminderSettings();

  @override
  Future<ReminderSettings> load() async => _settings;

  @override
  Future<void> save(ReminderSettings settings) async {
    _settings = settings;
  }
}
