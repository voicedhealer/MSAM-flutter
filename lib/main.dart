import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/progress_bar.dart';
import 'features/onboarding/presentation/screens/step1_license_plate.dart';
import 'features/onboarding/presentation/screens/step2_vehicle_info.dart';
import 'features/onboarding/presentation/screens/step3_identity.dart';
import 'features/onboarding/presentation/screens/step4_profile.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/vehicle/domain/models/vehicle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  static const _themeModeKey = 'theme_mode';

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt(_themeModeKey);
      if (savedIndex == null) return;
      final modes = ThemeMode.values;
      if (savedIndex < 0 || savedIndex >= modes.length) return;
      if (!mounted) return;
      setState(() {
        _themeMode = modes[savedIndex];
      });
    } on MissingPluginException {
      // Plugin non encore enregistre pendant un hot restart.
      // Le mode retombe proprement sur ThemeMode.system.
    }
  }

  void _updateThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    _persistThemeMode(mode);
  }

  Future<void> _persistThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
    } on MissingPluginException {
      // Ignore temporairement tant que le plugin n'est pas disponible.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Suivi Auto Moto',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      home: OnboardingFlow(
        currentThemeMode: _themeMode,
        onThemeModeChanged: _updateThemeMode,
      ),
    );
  }
}

class OnboardingFlow extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const OnboardingFlow({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  }) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 1;
  final int _totalSteps = 4;

  String _plate = '';
  dynamic _vehicle;
  dynamic _identity;
  bool _isComplete = false;

  void _handleStep1Next(String plate) {
    setState(() {
      _plate = plate;
      _currentStep = 2;
    });
  }

  void _handleStep2Next(dynamic vehicle) {
    setState(() {
      _vehicle = vehicle;
      _currentStep = 3;
    });
  }

  void _handleStep3Next(dynamic identity) {
    setState(() {
      _identity = identity;
      _currentStep = 4;
    });
  }

  void _handleStep4Next(dynamic profile) {
    setState(() {
      _isComplete = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          currentThemeMode: widget.currentThemeMode,
          onThemeModeChanged: widget.onThemeModeChanged,
          vehicle: Vehicle(
            plate: _plate,
            brand: _vehicle?.brand ?? 'Peugeot',
            model: _vehicle?.model ?? '308 GT',
            year: _vehicle?.year ?? 2023,
            currentMileage: 128500,
            type: 'car',
            fuelType: 'thermal',
            catalogImageUrl: _vehicle?.catalogImageUrl,
            userImageUrl: _vehicle?.userImageUrl,
          ),
        ),
      ),
    );
  }

  void _showThemeModeSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Apparence',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('Choisir Clair, Sombre ou Systeme'),
              ),
              ListTile(
                title: const Text('Mode clair'),
                trailing: widget.currentThemeMode == ThemeMode.light
                    ? const Icon(Icons.check, color: AppColors.autoAccent)
                    : null,
                onTap: () {
                  widget.onThemeModeChanged(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Mode sombre'),
                trailing: widget.currentThemeMode == ThemeMode.dark
                    ? const Icon(Icons.check, color: AppColors.autoAccent)
                    : null,
                onTap: () {
                  widget.onThemeModeChanged(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Suivre l appareil'),
                trailing: widget.currentThemeMode == ThemeMode.system
                    ? const Icon(Icons.check, color: AppColors.autoAccent)
                    : null,
                onTap: () {
                  widget.onThemeModeChanged(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _resetOnboarding() {
    setState(() {
      _currentStep = 1;
      _plate = '';
      _vehicle = null;
      _identity = null;
      _isComplete = false;
    });
  }

  Widget _buildCompletionScreen() {
    final surface = AppTheme.surface(context);
    final surfaceElevated = AppTheme.surfaceElevated(context);
    final textPrimary = AppTheme.textPrimary(context);
    final textSecondary = AppTheme.textSecondary(context);
    final border = AppTheme.border(context);

    return Container(
      decoration: BoxDecoration(
        color: surface,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.autoSuccess,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Bienvenue, ${_identity?.firstName ?? ''} !',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Votre compte est pret. Commencez a suivre votre ${_vehicle?.brand ?? ''} ${_vehicle?.model ?? ''}.',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: surfaceElevated,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vehicule',
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondary,
                          ),
                        ),
                        Text(
                          _plate,
                          style: TextStyle(
                            fontSize: 16,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: border),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondary,
                          ),
                        ),
                        Text(
                          _identity?.email ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _resetOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.autoAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                    ),
                  ),
                  child: const Text(
                    'Recommencer le flow',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return Step1LicensePlate(
          onNext: _handleStep1Next,
          isExpressive: false,
        );
      case 2:
        return Step2VehicleInfo(
          plate: _plate,
          onNext: _handleStep2Next,
          onBack: () => setState(() => _currentStep = 1),
          isExpressive: false,
        );
      case 3:
        return Step3Identity(
          onNext: _handleStep3Next,
          onBack: () => setState(() => _currentStep = 2),
          isExpressive: false,
        );
      case 4:
        return Step4Profile(
          onNext: _handleStep4Next,
          onBack: () => setState(() => _currentStep = 3),
          isExpressive: false,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppTheme.surface(context);
    final border = AppTheme.border(context);

    if (_isComplete) {
      return Scaffold(
        body: _buildCompletionScreen(),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: surface,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: surface,
                  border: Border(
                    bottom: BorderSide(
                      color: border,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _showThemeModeSheet,
                          icon: const Icon(Icons.brightness_6_outlined, size: 18),
                          label: const Text('Apparence'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.autoAccent,
                            side: const BorderSide(color: AppColors.autoAccent),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ProgressBar(
                      currentStep: _currentStep,
                      totalSteps: _totalSteps,
                      variant: ProgressVariant.minimal,
                      showVehicleIndicator: true,
                      indicatorStyle: VehicleIndicatorStyle.suv,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildCurrentStep(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
