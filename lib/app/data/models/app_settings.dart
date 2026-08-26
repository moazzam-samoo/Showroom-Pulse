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

  // -- NEW FIELDS FROM SETTINGS UI UPDATE --

  /// Showroom Name (General Settings)
  String showroomName = 'Showroom Pulse';

  /// Showroom Logo path (General Settings)
  String? showroomLogoPath;

  /// Showroom Address (General Settings)
  String? showroomAddress;

  /// Showroom Phone (General Settings)
  String? showroomPhone;

  /// Currency Symbol (General Settings)
  String currencySymbol = 'Rs';

  /// Date Format (General Settings)
  String dateFormat = 'dd/MM/yyyy';

  /// PDF Download Location (General Settings)
  String? pdfDownloadLocation;

  /// EMI Rounding Setting (Financials)
  /// e.g. 'Off', 'Nearest 10', 'Nearest 50', 'Nearest 100'
  String emiRounding = 'Nearest 50';

  /// Default Expense Categories (Financials, comma separated)
  String defaultExpenseCategories = 'Building Rent,Electricity,Snacks/Tea,Salaries,Maintenance';

  /// Last backup date
  DateTime? lastBackupDate;
  // -- NEW FIELDS FROM PROFILE SECTION --

  /// Owner Name
  String? ownerName;

  /// Owner Profile Picture Path
  String? ownerProfilePicPath;
  /// Custom bike brands (comma-separated)
  String bikeBrands = 'Honda,Suzuki,Yamaha,United,Road Prince,Super Power,Hi Speed,Unique,Crown,Pak Hero';

  /// Custom bike models (comma-separated)
  String bikeModels = 'CG125,CD70,GS150,CB150F,Pridor,CG125S,CB150F-SE,YBR125,GD110,GR150';

  /// Custom bike models (Year) (comma-separated)
  String bikeYears = '2024,2025,2026';
}

// Authored by: Moazzam Samoo
