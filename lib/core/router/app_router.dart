import 'package:flutter/material.dart';

import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/maintenance/presentation/screens/add_maintenance_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  const AppRouter._();

  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const addMaintenance = '/add-maintenance';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case addMaintenance:
        return MaterialPageRoute(builder: (_) => const AddMaintenanceScreen());
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    }
  }
}
