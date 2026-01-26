import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'app/core/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'app/features/auth/presentation/views/login_view.dart';

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
      
      // Initial Route - Login Screen
      home: const LoginView(),
    );
  }
}

// Authored by: Moazzam Samoo
