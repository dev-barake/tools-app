
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/app/screens/app_shell.dart';
import 'package:tools_app/core/theme/app_theme.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TidyToolsApp());
}

class TidyToolsApp extends StatelessWidget {
  const TidyToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'tidytools',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const AppShell(),
    );
  }
}
