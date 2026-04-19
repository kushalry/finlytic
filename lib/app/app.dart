import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class FinlyticApp extends StatelessWidget {
  const FinlyticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Finlytic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}