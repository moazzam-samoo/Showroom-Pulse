import 'package:get/get.dart';
import '../services/file_service.dart';
import '../services/isar_service.dart';
import '../services/theme_service.dart';
import '../../features/auth/presentation/controllers/login_controller.dart';
import '../../features/auth/data/auth_service.dart';
import '../services/notification_service.dart';
import '../services/report_pdf_service.dart';
import '../services/checkpoint_service.dart';
import '../services/customer_export_service.dart';
import '../services/walkthrough_service.dart';
import '../../features/settings/data/repositories/settings_repository.dart';
import '../../features/settings/presentation/controllers/settings_controller.dart';/// InitialBinding - Registers all global services
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Theme Service (immediately available)
    Get.put(ThemeService());
  }
}

/// Initialize async services
/// Call this in splash screen or app startup
Future<bool> initializeAsyncServices() async {
  // Initialize FileService first (creates directory structure)
  final fileService = await FileService().init();
  Get.put(fileService);
  
  // Initialize IsarService (database)
  final isarService = await IsarService().init();
  Get.put(isarService);
  
  // Initialize Settings (depends on IsarService)
  final settingsRepo = SettingsRepository(isarService);
  Get.put(settingsRepo);
  final settingsController = SettingsController(settingsRepo);
  Get.put(settingsController, permanent: true);

  // Initialize CheckpointService (auto-snapshots)
  final checkpointService = CheckpointService(fileService, isarService);
  Get.put(checkpointService);
  await checkpointService.autoCheckpoint();
  
  // Initialize AuthService (authentication + session)
  final authService = await AuthService().init();
  Get.put(authService);
  
  // Initialize WalkthroughService
  final walkthroughService = await WalkthroughService().init();
  Get.put(walkthroughService);
  
  // Ensure default admin user exists
  bool isFreshDb = await authService.ensureDefaultUser();
  
  // Initialize NotificationService
  final notificationService = NotificationService();
  await notificationService.init();
  Get.put(notificationService, permanent: true);

  // Initialize ReportPdfService
  Get.put(ReportPdfService()); // Added ReportPdfService initialization
  
  // Initialize CustomerExportService (depends on FileService + ReportPdfService)
  Get.put(CustomerExportService());
  
  // Initial check and start timer
  await notificationService.checkAndNotify();
  notificationService.startPeriodicCheck();

  return isFreshDb;
}

/// Register Login page dependencies
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

// Authored by: Moazzam Samoo
