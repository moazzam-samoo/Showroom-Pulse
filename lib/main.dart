import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

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
import 'app/features/sales/presentation/views/sales_view.dart';
import 'app/features/sales/presentation/bindings/sales_binding.dart';
import 'app/features/installments/presentation/views/installments_view.dart';
import 'app/features/installments/presentation/bindings/installments_binding.dart';
import 'app/features/customers/presentation/views/customers_view.dart';
import 'app/features/customers/presentation/bindings/customers_binding.dart';

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
    title: 'Tahir Showroom',
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  
  runApp(const TahirShowroomApp());
}

class TahirShowroomApp extends StatelessWidget {
  const TahirShowroomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tahir Showroom',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration - Dark Theme as Default
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Dark theme is default
      
      // Initial Bindings
      initialBinding: InitialBinding(),
      
      // Start with Splash Screen
      home: const SplashScreen(),
      
      // Named Routes
      getPages: [
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
        GetPage(name: '/inventory', page: () => const InventoryView()),
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
      ],
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
      await initializeAsyncServices();
      
      // Check for saved session ("Keep me logged in")
      final authService = Get.find<AuthService>();
      final hasSession = await authService.checkSavedSession();
      
      if (hasSession) {
        // User is already logged in, go to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        // No session, go to login
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // On error, go to login
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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.motorcycle,
                size: 48,
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              'Tahir Showroom',
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
