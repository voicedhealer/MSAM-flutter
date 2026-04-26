import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/theme/app_theme.dart';

class ProfileData {
  final String? mileage;
  final String? usage;
  final bool reminders;

  ProfileData({this.mileage, this.usage, required this.reminders});
}

class Step4Profile extends StatefulWidget {
  final Function(ProfileData?) onNext;
  final VoidCallback onBack;
  final bool isExpressive;

  const Step4Profile({
    Key? key,
    required this.onNext,
    required this.onBack,
    required this.isExpressive,
  }) : super(key: key);

  @override
  State<Step4Profile> createState() => _Step4ProfileState();
}

class _Step4ProfileState extends State<Step4Profile> {
  final _mileageController = TextEditingController();
  String? _selectedUsage;
  bool _reminders = false;

  void _handleSubmit() {
    widget.onNext(ProfileData(
      mileage: _mileageController.text.trim(),
      usage: _selectedUsage,
      reminders: _reminders,
    ));
  }

  void _handleSkip() {
    widget.onNext(null);
  }

  Widget _buildUsageButton(String type) {
    final isSelected = _selectedUsage == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedUsage = type);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.autoAccent.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.autoAccent : AppColors.autoBorder,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          ),
          alignment: Alignment.center,
          child: Text(
            type,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? AppColors.autoAccent : AppColors.autoTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isExpressive) ...[
          Center(
            child: Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                color: AppColors.autoWarning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.speed,
                color: AppColors.autoWarning,
                size: 32,
              ),
            ),
          ),
        ],
        const Text(
          'Personnalisez votre suivi',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: AppColors.autoTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Optionnel - vous pourrez le faire plus tard',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.autoTextSecondary,
          ),
        ),
        const SizedBox(height: 24),
        CustomInput(
          controller: _mileageController,
          placeholder: '125 000',
          icon: Icons.speed,
          label: 'Kilometrage actuel (km)',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        const Text(
          'Type d\'usage',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.autoTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildUsageButton('Personnel'),
            const SizedBox(width: 8),
            _buildUsageButton('Professionnel'),
            const SizedBox(width: 8),
            _buildUsageButton('Mixte'),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            setState(() => _reminders = !_reminders);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.autoSurfaceElevated,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _reminders ? AppColors.autoAccent : AppColors.autoBorder,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: _reminders ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 16,
                            color: AppColors.autoTextSecondary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Rappels d\'entretien',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.autoTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Soyez notifie des echeances importantes',
                        style: TextStyle(
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
        const SizedBox(height: 32),
        CustomButton(
          text: 'Terminer',
          onPressed: _handleSubmit,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Plus tard',
          onPressed: _handleSkip,
          variant: ButtonVariant.ghost,
          fullWidth: true,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mileageController.dispose();
    super.dispose();
  }
}
