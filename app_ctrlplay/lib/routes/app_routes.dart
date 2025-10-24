import 'package:flutter/material.dart';
import '../views/login/login_page.dart';
import '../views/home/home_page.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const details = '/details';

  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginPage(),
    // home: (_) => const HomePage(),
  };
}
