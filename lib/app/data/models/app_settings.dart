import 'package:isar/isar.dart';

part 'app_settings.g.dart';

/// App Settings Collection - Stores application settings
/// 
/// Only one record should exist (singleton pattern)
@collection
class AppSettings {
  Id id = Isar.autoIncrement;

  /// Default installment markup percentage
  double defaultMarkupPercentage = 40.0;

  /// Is automatic late fee enabled?
  bool automaticLateFeeEnabled = true;

  /// Late fee percentage
  double lateFeePercentage = 5.0;

  /// Is cloud sync enabled?
  bool cloudSyncEnabled = false;

  /// Current theme (dark/light)
  bool isDarkTheme = true;

  /// Last backup date
  DateTime? lastBackupDate;
}

// Authored by: Moazzam Samoo
