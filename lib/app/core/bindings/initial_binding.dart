import 'package:get/get.dart';
import '../services/file_service.dart';
import '../services/isar_service.dart';
import '../services/theme_service.dart';

/// InitialBinding - Registers all global services
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Theme Service (immediately available)
    Get.put(ThemeService());
    
    // Async services will be initialized in splash/startup
    // FileService and IsarService need async initialization
  }
}

/// Initialize async services
/// Call this in splash screen or app startup
Future<void> initializeAsyncServices() async {
  // Initialize FileService first (creates directory structure)
  final fileService = await FileService().init();
  Get.put(fileService);
  
  // Initialize IsarService (opens database)
  final isarService = await IsarService().init();
  Get.put(isarService);
}

// Authored by: Moazzam Samoo
