import 'package:flutter/material.dart';
import 'package:sample_cubit/features/splash/splash_screen.dart';

const root = '/';

PageRoute routeGeneration(RouteSettings settings) {
  late WidgetBuilder builder;
  switch (settings.name) {
    case root:
      builder = (_) => const SplashScreen();
      break;
  }
  return MaterialPageRoute(builder: builder, settings: settings);
}
