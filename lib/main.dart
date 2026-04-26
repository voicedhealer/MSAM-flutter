import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Suivi Auto Moto',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      home: const OnboardingFlow(),
    );
  }
}

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 1;
  bool _isExpressive = false;
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
          vehicle: Vehicle(
            plate: _plate,
            brand: _vehicle?.brand ?? 'Peugeot',
            model: _vehicle?.model ?? '308 GT',
            year: _vehicle?.year ?? 2023,
            currentMileage: 128500,
            type: 'car',
            fuelType: 'thermal',
          ),
        ),
      ),
    );
  }

  void _toggleVariant() {
    setState(() {
      _isExpressive = !_isExpressive;
    });
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.autoSurface,
            AppColors.autoSurfaceElevated,
          ],
        ),
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
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: AppColors.autoTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Votre compte est pret. Commencez a suivre votre ${_vehicle?.brand ?? ''} ${_vehicle?.model ?? ''}.',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.autoTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.autoSurface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: AppColors.autoBorder),
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
                        const Text(
                          'Vehicule',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.autoTextSecondary,
                          ),
                        ),
                        Text(
                          _plate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.autoTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: AppColors.autoBorder),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.autoTextSecondary,
                          ),
                        ),
                        Text(
                          _identity?.email ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.autoTextPrimary,
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
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _toggleVariant,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: AppColors.autoTextHint,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Basculer en variante ${_isExpressive ? "A (Minimal)" : "B (Expressive)"}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.autoTextHint,
                      ),
                    ),
                  ],
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
          isExpressive: _isExpressive,
        );
      case 2:
        return Step2VehicleInfo(
          plate: _plate,
          onNext: _handleStep2Next,
          onBack: () => setState(() => _currentStep = 1),
          isExpressive: _isExpressive,
        );
      case 3:
        return Step3Identity(
          onNext: _handleStep3Next,
          onBack: () => setState(() => _currentStep = 2),
          isExpressive: _isExpressive,
        );
      case 4:
        return Step4Profile(
          onNext: _handleStep4Next,
          onBack: () => setState(() => _currentStep = 3),
          isExpressive: _isExpressive,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      return Scaffold(
        body: _buildCompletionScreen(),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.autoSurface,
              AppColors.autoSurfaceElevated,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.autoSurface.withValues(alpha: 0.95),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.autoBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: ProgressBar(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  variant: _isExpressive ? ProgressVariant.expressive : ProgressVariant.minimal,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _isExpressive
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.autoSurface,
                            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                            border: Border.all(color: AppColors.autoBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _buildCurrentStep(),
                        )
                      : _buildCurrentStep(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.autoSurface.withValues(alpha: 0.95),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.autoBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: _toggleVariant,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: AppColors.autoTextHint,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Variante ${_isExpressive ? "B (Expressive)" : "A (Minimal)"} - Cliquer pour basculer',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.autoTextHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
