import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ProgressVariant { minimal, expressive }

class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final ProgressVariant variant;

  const ProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.variant = ProgressVariant.minimal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    if (variant == ProgressVariant.minimal) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Etape $currentStep/$totalSteps',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.autoTextHint,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.autoTextHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.autoBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.autoAccent),
              minHeight: 4,
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
              color: isCompleted ? AppColors.autoSuccess : AppColors.autoBorder,
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
                      : AppColors.autoBorder,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNumber',
              style: TextStyle(
                fontSize: 14,
                color: isCompleted || isActive ? Colors.white : AppColors.autoTextHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
      }),
    );
  }
}
