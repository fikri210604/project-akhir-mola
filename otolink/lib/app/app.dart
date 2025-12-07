import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/routes.dart';
import 'routes/bindings.dart';
import '../ui/widgets/splash_screen_view.dart';

class OtolinkApp extends StatelessWidget {
  const OtolinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Otolink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
      home: const SplashScreen(),
      getPages: AppRoutes.pages,
      initialBinding: AppBinding(),
    );
  }
}
