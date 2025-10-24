import "package:flutter/material.dart";
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const CtrlPlayApp());
}

class CtrlPlayApp extends StatelessWidget {
  const CtrlPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTRL+Play',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
