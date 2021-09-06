import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_cubit/core/router.dart';
import 'package:sample_cubit/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureInjection();

  await runZonedGuarded(() async {
    runApp(
      MyApp(),
    );
  }, (error, stack) {
    print(stack);
    print(error);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: routeGeneration,
        ),
      );
}
