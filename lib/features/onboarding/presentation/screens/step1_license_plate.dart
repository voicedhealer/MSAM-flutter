import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/theme/app_theme.dart';

class Step1LicensePlate extends StatefulWidget {
  final Function(String) onNext;
  final bool isExpressive;

  const Step1LicensePlate({
    Key? key,
    required this.onNext,
    required this.isExpressive,
  }) : super(key: key);

  @override
  State<Step1LicensePlate> createState() => _Step1LicensePlateState();
}

class _Step1LicensePlateState extends State<Step1LicensePlate> {
  final _controller = TextEditingController();
  String? _error;

  void _handleSubmit() {
    final plate = _controller.text.trim();
    if (plate.isEmpty) {
      setState(() {
        _error = 'Veuillez saisir votre plaque d\'immatriculation';
      });
      return;
    }
    if (plate.length < 5) {
      setState(() {
        _error = 'Format invalide';
      });
      return;
    }
    widget.onNext(plate.toUpperCase());
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
                color: AppColors.autoAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.tag,
                color: AppColors.autoAccent,
                size: 32,
              ),
            ),
          ),
        ],
        const Text(
          'Bienvenue !',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: AppColors.autoTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Commencons par votre plaque d\'immatriculation',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.autoTextSecondary,
          ),
        ),
        const SizedBox(height: 24),
        CustomInput(
          controller: _controller,
          placeholder: 'AB-123-CD',
          icon: Icons.tag,
          hint: 'Format francais standard',
          error: _error,
          maxLength: 20,
          autofocus: true,
          onChanged: (value) {
            if (_error != null) {
              setState(() => _error = null);
            }
          },
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Continuer',
          onPressed: _handleSubmit,
          fullWidth: true,
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Vos donnees sont securisees et confidentielles',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.autoTextHint,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
