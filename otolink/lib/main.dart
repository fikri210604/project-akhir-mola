import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'app/routes/routes.dart';
import 'app/routes/root_gate.dart';
import 'app/routes/bindings.dart';
import 'app/services/auth_service.dart';
import 'app/services/impl/firebase_auth_service.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/services/log_service.dart';
import 'app/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  LogService.init();

  await Get.putAsync(() => SharedPreferences.getInstance());
  Get.put<ThemeController>(ThemeController());
  Get.put<AuthService>(FirebaseAuthService());
  Get.put<AuthController>(AuthController(Get.find()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
      title: 'Otolink',
      debugShowCheckedModeBanner: false,
      
      translations: AppTranslations(),
      locale: const Locale('id', 'ID'), 
      fallbackLocale: const Locale('en', 'US'),
      
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: themeCtrl.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

      initialBinding: AppBinding(),
      initialRoute: AppRoutes.welcome,
      getPages: AppRoutes.pages,
      home: const RootGate(),
    ));
  }

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0A2C6C),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black87,
      surfaceContainerHighest: Color(0xFFF5F5F5),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0A2C6C),
      elevation: 0.5,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF0A2C6C),
      unselectedItemColor: Colors.grey,
    ),
    useMaterial3: true,
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: Colors.grey.shade800,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF5E81AC),
      onPrimary: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
      surfaceContainerHighest: Color(0xFF2C2C2C),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFF5E81AC),
      unselectedItemColor: Colors.grey,
    ),
    useMaterial3: true,
  );
}