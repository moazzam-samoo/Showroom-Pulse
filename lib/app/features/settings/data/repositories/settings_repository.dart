import 'package:isar/isar.dart';
import '../../../../core/services/isar_service.dart';
import '../../../../data/models/app_settings.dart';

class SettingsRepository {
  final IsarService _isarService;

  SettingsRepository(this._isarService);

  Future<AppSettings> getSettings() async {
    final isar = _isarService.isar;
    final settings = await isar.appSettings.where().findFirst();
    if (settings != null) {
      return settings;
    }
    
    // Create default settings if none exist
    final defaultSettings = AppSettings();
    await isar.writeTxn(() async {
      await isar.appSettings.put(defaultSettings);
    });
    return defaultSettings;
  }

  Future<void> updateSettings(AppSettings settings) async {
    final isar = _isarService.isar;
    await isar.writeTxn(() async {
      await isar.appSettings.put(settings);
    });
  }
}
