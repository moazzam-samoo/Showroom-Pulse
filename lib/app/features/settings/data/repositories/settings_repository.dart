import 'package:isar/isar.dart';
import '../../../../data/models/app_settings.dart';

class SettingsRepository {
  final Isar _isar;

  SettingsRepository(this._isar);

  Future<AppSettings> getSettings() async {
    final settings = await _isar.appSettings.where().findFirst();
    if (settings != null) {
      return settings;
    }
    
    // Create default settings if none exist
    final defaultSettings = AppSettings();
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(defaultSettings);
    });
    return defaultSettings;
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(settings);
    });
  }
}
