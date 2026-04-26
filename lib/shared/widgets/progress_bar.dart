import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ProgressVariant { minimal, expressive }
enum VehicleIndicatorStyle { minimal, sport, suv, moto }

class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final ProgressVariant variant;
  final bool showVehicleIndicator;
  final VehicleIndicatorStyle indicatorStyle;

  const ProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.variant = ProgressVariant.minimal,
    this.showVehicleIndicator = true,
    this.indicatorStyle = VehicleIndicatorStyle.minimal,
  }) : super(key: key);

  IconData _vehicleIcon() {
    switch (indicatorStyle) {
      case VehicleIndicatorStyle.sport:
        return Icons.sports_motorsports;
      case VehicleIndicatorStyle.suv:
        return Icons.airport_shuttle;
      case VehicleIndicatorStyle.moto:
        return Icons.two_wheeler;
      case VehicleIndicatorStyle.minimal:
        return Icons.directions_car_filled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textHint = AppTheme.textHint(context);
    final border = AppTheme.border(context);
    final progress = currentStep / totalSteps;

    if (variant == ProgressVariant.minimal) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Etape $currentStep/$totalSteps',
                style: TextStyle(
                  fontSize: 14,
                  color: textHint,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 14,
                  color: textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: showVehicleIndicator ? 28 : 8,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final clampedProgress = progress.clamp(0.0, 1.0);
                final indicatorSize = 18.0;
                final indicatorLeft = (width - indicatorSize) * clampedProgress;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: showVehicleIndicator ? 14 : 2,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: border,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Positioned(
                      top: showVehicleIndicator ? 14 : 2,
                      left: 0,
                      child: Container(
                        width: width * clampedProgress,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: AppTheme.ctaGradient,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    if (showVehicleIndicator)
                      Positioned(
                        top: 0,
                        left: indicatorLeft,
                        child: Icon(
                          _vehicleIcon(),
                          size: indicatorSize,
                          color: AppColors.autoAccentPurple,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          final stepNumber = (index ~/ 2) + 1;
          final isCompleted = stepNumber < currentStep;
          return Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.autoSuccess : border,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        } else {
          final stepNumber = (index ~/ 2) + 1;
          final isActive = stepNumber == currentStep;
          final isCompleted = stepNumber < currentStep;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 36 : 32,
            height: isActive ? 36 : 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.autoSuccess
                  : isActive
                      ? AppColors.autoAccent
                      : border,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNumber',
              style: TextStyle(
                fontSize: 14,
                color: isCompleted || isActive ? Colors.white : textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
      }),
    );
  }
}
