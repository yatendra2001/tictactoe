import 'package:flutter/material.dart';

import '../screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appNamedRoutesMap = {
  '/': (_) => const SplashScreen(),
  LoginScreen.routeName: (_) => const LoginScreen(),
  GamePage.routeName: (_) => const GamePage(),
};
