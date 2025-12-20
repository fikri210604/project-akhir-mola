import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/bindings.dart';
import 'routes/routes.dart';

class OtolinkApp extends StatelessWidget {
  const OtolinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Otolink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A2C6C)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      initialRoute: AppRoutes.welcome,
      getPages: AppRoutes.pages,
      initialBinding: AppBindings(),
    );
  }
}