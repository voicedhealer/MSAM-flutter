import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/theme/app_theme.dart';

class IdentityData {
  final String firstName;
  final String email;

  IdentityData({required this.firstName, required this.email});
}

class Step3Identity extends StatefulWidget {
  final Function(IdentityData) onNext;
  final VoidCallback onBack;
  final bool isExpressive;

  const Step3Identity({
    Key? key,
    required this.onNext,
    required this.onBack,
    required this.isExpressive,
  }) : super(key: key);

  @override
  State<Step3Identity> createState() => _Step3IdentityState();
}

class _Step3IdentityState extends State<Step3Identity> {
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _firstNameError;
  String? _emailError;

  bool _validateEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  void _handleSubmit() {
    setState(() {
      _firstNameError = null;
      _emailError = null;
    });

    final firstName = _firstNameController.text.trim();
    final email = _emailController.text.trim();

    bool hasError = false;

    if (firstName.isEmpty) {
      setState(() => _firstNameError = 'Prenom requis');
      hasError = true;
    }

    if (email.isEmpty) {
      setState(() => _emailError = 'Email requis');
      hasError = true;
    } else if (!_validateEmail(email)) {
      setState(() => _emailError = 'Format email invalide');
      hasError = true;
    }

    if (!hasError) {
      widget.onNext(IdentityData(firstName: firstName, email: email));
    }
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
                Icons.person,
                color: AppColors.autoAccent,
                size: 32,
              ),
            ),
          ),
        ],
        const Text(
          'Presque termine',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: AppColors.autoTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Creez votre compte en quelques secondes',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.autoTextSecondary,
          ),
        ),
        const SizedBox(height: 24),
        CustomInput(
          controller: _firstNameController,
          placeholder: 'Prenom',
          icon: Icons.person,
          error: _firstNameError,
          autofocus: true,
          onChanged: (_) {
            if (_firstNameError != null) {
              setState(() => _firstNameError = null);
            }
          },
        ),
        const SizedBox(height: 16),
        CustomInput(
          controller: _emailController,
          placeholder: 'email@exemple.com',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          hint: 'Nous ne partagerons jamais votre email',
          error: _emailError,
          onChanged: (_) {
            if (_emailError != null) {
              setState(() => _emailError = null);
            }
          },
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Creer mon compte',
          onPressed: _handleSubmit,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Retour',
          onPressed: widget.onBack,
          variant: ButtonVariant.ghost,
          fullWidth: true,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
