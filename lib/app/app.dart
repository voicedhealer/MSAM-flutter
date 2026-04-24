import 'package:flutter/material.dart';

import '../core/router/app_router.dart';
import '../shared/theme/app_theme.dart';

class MSAMApp extends StatelessWidget {
  const MSAMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon-Suivi-Auto-Moto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.onboarding,
    );
  }
}
