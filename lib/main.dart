import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';
import 'package:tahir_showroom/app/features/walkthrough/bindings/walkthrough_binding.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/views/walkthrough_view.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';

import 'app/core/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/constants/app_colors.dart';
import 'app/features/auth/presentation/views/login_view.dart';
import 'app/features/auth/data/auth_service.dart';
import 'app/features/dashboard/presentation/views/dashboard_view.dart';
import 'app/features/dashboard/presentation/bindings/dashboard_binding.dart';
import 'app/features/procurement/presentation/views/procurement_view.dart';
import 'app/features/procurement/presentation/bindings/procurement_binding.dart';
import 'app/features/inventory/presentation/views/inventory_view.dart';
import 'app/features/inventory/presentation/bindings/inventory_binding.dart';
import 'app/features/sales/presentation/views/sales_view.dart';
import 'app/features/sales/presentation/bindings/sales_binding.dart';
import 'app/features/installments/presentation/views/installments_view.dart';
import 'app/features/installments/presentation/bindings/installments_binding.dart';
import 'app/features/customers/presentation/views/customers_view.dart';
import 'app/features/customers/presentation/bindings/customers_binding.dart';
import 'app/features/reports/presentation/views/reports_view.dart';
import 'app/features/reports/presentation/bindings/reports_binding.dart';
import 'app/features/settings/presentation/views/settings_view.dart';
import 'app/features/settings/presentation/bindings/settings_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize window manager for desktop
  await windowManager.ensureInitialized();
  
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'AL-AL-TAHIR Showroom',
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    // Set taskbar icon explicitly for Windows
    if (Platform.isWindows) {
      await windowManager.setIcon('assets/app_icon.ico');
    }
    // Prevent default close so we can handle it
    await windowManager.setPreventClose(true);
  });
  
  runApp(const TahirShowroomApp());
}

class TahirShowroomApp extends StatefulWidget {
  const TahirShowroomApp({super.key});

  @override
  State<TahirShowroomApp> createState() => _TahirShowroomAppState();
}

class _TahirShowroomAppState extends State<TahirShowroomApp> with WindowListener, TrayListener {
  @override
  void initState() {
    windowManager.addListener(this);
    trayManager.addListener(this);
    _initSystemTray();
    super.initState();
  }

  Future<void> _initSystemTray() async {
    // Set tray icon (Windows relies on .ico)
    await trayManager.setIcon(
      Platform.isWindows 
          ? 'assets/app_icon.ico' 
          : '',
    );
    
    // Explicitly set tooltip to avoid garbled uninitialized memory text on Windows
    await trayManager.setToolTip('AL-AL-TAHIR Showroom');
    
    // Create tray context menu
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_app',
          label: 'Show App',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: 'Exit',
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      Get.snackbar(
        'App Minimized to Tray',
        'AL-AL-TAHIR Showroom is now hiding in your System Tray.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueGrey.shade800,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      // Hide completely from taskbar
      await windowManager.hide();
    }
  }

  @override
  void onTrayIconMouseDown() {
    windowManager.show();
    windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_app') {
      windowManager.show();
      windowManager.focus();
    } else if (menuItem.key == 'exit_app') {
      windowManager.destroy(); // Fully close app
    }
  }

  @override
  Widget build(BuildContext context) {
    // Manual setup replaces GetMaterialApp to add themeAnimationDuration: Duration.zero
    // which GetMaterialApp v4.7.3 doesn't expose. This prevents AnimatedTheme cross-fade
    // that causes GlobalKey collisions on Material ink renderers during theme switches.
    
    // Initialize GetX config and bindings
    Get.config(
      enableLog: true,
      defaultTransition: Transition.fadeIn,
      defaultDurationTransition: const Duration(milliseconds: 300),
    );
    InitialBinding().dependencies();
    
    // Register pages with GetX
    final getPages = [
      GetPage(
        name: '/login',
        page: () => const LoginView(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: '/dashboard',
        page: () => const DashboardView(),
        binding: DashboardBinding(),
      ),
      GetPage(
        name: '/procurement',
        page: () => const ProcurementView(),
        binding: ProcurementBinding(),
      ),
      GetPage(
        name: '/inventory',
        page: () => const InventoryView(),
        binding: InventoryBinding(),
      ),
      GetPage(
        name: '/sales',
        page: () => const SalesView(),
        binding: SalesBinding(),
      ),
      GetPage(
        name: '/installments',
        page: () => const InstallmentsView(),
        binding: InstallmentsBinding(),
      ),
      GetPage(
        name: '/customers',
        page: () => const CustomersView(),
        binding: CustomersBinding(),
      ),
      GetPage(
        name: '/reports',
        page: () => const ReportsView(),
        binding: ReportsBinding(),
      ),
      GetPage(
        name: '/settings',
        page: () => const SettingsView(),
        binding: SettingsBinding(),
      ),
      GetPage(
        name: '/walkthrough',
        page: () => const WalkthroughView(),
        binding: WalkthroughBinding(),
      ),
    ];
    Get.addPages(getPages);
    
    return GetBuilder<GetMaterialController>(
      init: Get.rootController,
      builder: (ctrl) => MaterialApp(
        navigatorKey: Get.key,
        title: 'AL-AL-TAHIR Showroom',
        debugShowCheckedModeBanner: false,
        
        // Theme
        theme: ctrl.theme ?? AppTheme.lightTheme,
        darkTheme: ctrl.darkTheme ?? AppTheme.darkTheme,
        themeMode: ctrl.themeMode ?? ThemeMode.dark,
        
        // Disable theme animation to prevent GlobalKey collisions
        themeAnimationDuration: Duration.zero,
        
        // Navigation
        home: const SplashScreen(),
        onGenerateRoute: (settings) {
          return PageRedirect(settings: settings).page();
        },
        navigatorObservers: [
          GetObserver(null, Get.routing),
        ],
      ),
    );
  }
}

/// Placeholder for features not yet implemented
class FeaturePlaceholder extends StatelessWidget {
  final String title;
  const FeaturePlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Get.offNamed('/dashboard'),
        ),
      ),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
            const SizedBox(height: 16),
            Text(
              '$title Feature Coming Soon',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Splash Screen - Initializes services and checks session
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize all async services
      bool isFreshDb = await initializeAsyncServices();
      
      final walkthroughService = Get.find<WalkthroughService>();
      final authService = Get.find<AuthService>();

      // 1. Detect true fresh install (No users in database)
      // This handles cases where the user deleted the database but SharedPreferences remained
      if (isFreshDb) {
        await authService.clearSession();
        await walkthroughService.resetWalkthrough();
        Get.offAllNamed('/walkthrough');
        return;
      }

      // 2. Check if walkthrough is needed (First run flag in SharedPreferences)
      if (!walkthroughService.hasCompletedWalkthrough.value) {
        Get.offAllNamed('/walkthrough');
        return;
      }

      // 3. Already completed walkthrough, check for session
      final bool hasSession = await authService.checkSavedSession();
      if (hasSession) {
        Get.offAllNamed('/dashboard');
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // On error, default to login
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark 
          ? AppColors.darkBackground 
          : AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/app_logo.jpeg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.motorcycle,
                    size: 48,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              'AL-TAHIR Showroom',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark 
                    ? AppColors.darkTextPrimary 
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 32),
            // Loading indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashboard Placeholder - Will be replaced in Phase 2 Dashboard
class DashboardPlaceholder extends StatelessWidget {
  const DashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark 
          ? AppColors.darkBackground 
          : AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dashboard,
              size: 64,
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome, ${authService.currentUser.value?.displayName ?? "User"}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark 
                    ? AppColors.darkTextPrimary 
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dashboard UI will be implemented next',
              style: TextStyle(
                fontSize: 14,
                color: isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await authService.logout();
                Get.offAllNamed('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark 
                    ? AppColors.darkPrimary 
                    : AppColors.lightPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
