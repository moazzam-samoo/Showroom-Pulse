import 'package:get/get.dart';
import '../services/file_service.dart';
import '../services/isar_service.dart';
import '../services/theme_service.dart';
import '../../features/auth/presentation/controllers/login_controller.dart';
import '../../features/auth/data/auth_service.dart';
import '../services/notification_service.dart';

/// InitialBinding - Registers all global services
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Theme Service (immediately available)
    Get.put(ThemeService());
  }
}

/// Initialize async services
/// Call this in splash screen or app startup
Future<void> initializeAsyncServices() async {
  // Initialize FileService first (creates directory structure)
  final fileService = await FileService().init();
  Get.put(fileService);
  
  // Initialize IsarService (database)
  final isarService = await IsarService().init();
  Get.put(isarService);
  
  // Initialize AuthService (authentication + session)
  final authService = await AuthService().init();
  Get.put(authService);
  
  // Ensure default admin user exists
  await authService.ensureDefaultUser();
  
  // Initialize NotificationService
  final notificationService = NotificationService();
  await notificationService.init();
  Get.put(notificationService, permanent: true);
  
  // Initial check and start timer
  await notificationService.checkAndNotify();
  notificationService.startPeriodicCheck();
}

/// Register Login page dependencies
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

// Authored by: Moazzam Samoo
