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
  bool _isFormatting = false;

  String _sanitizePlate(String input) {
    return input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  String _formatPlateForDisplay(String input) {
    final raw = _sanitizePlate(input);
    final limited = raw.length > 7 ? raw.substring(0, 7) : raw;

    if (limited.length <= 2) return limited;
    if (limited.length <= 5) {
      return '${limited.substring(0, 2)}-${limited.substring(2)}';
    }
    return '${limited.substring(0, 2)}-${limited.substring(2, 5)}-${limited.substring(5)}';
  }

  String? _normalizeAndValidatePlate(String input) {
    final raw = _sanitizePlate(input);
    final match = RegExp(r'^([A-Z]{2})([0-9]{3})([A-Z]{2})$').firstMatch(raw);
    if (match == null) return null;
    return '${match.group(1)}-${match.group(2)}-${match.group(3)}';
  }

  void _handleSubmit() {
    final formattedPlate = _normalizeAndValidatePlate(_controller.text);
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _error = 'Veuillez saisir votre plaque d\'immatriculation';
      });
      return;
    }
    if (formattedPlate == null) {
      setState(() {
        _error = 'Format invalide (attendu: XX-123-XX)';
      });
      return;
    }
    _controller.text = formattedPlate;
    _controller.selection = TextSelection.collapsed(offset: formattedPlate.length);
    widget.onNext(formattedPlate);
  }

  void _handlePlateChanged(String value) {
    if (_isFormatting) return;

    final formatted = _formatPlateForDisplay(value);
    if (formatted != value) {
      _isFormatting = true;
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      _isFormatting = false;
    }

    if (_error != null) {
      setState(() => _error = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppTheme.textPrimary(context);
    final textSecondary = AppTheme.textSecondary(context);
    final textHint = AppTheme.textHint(context);

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
        Text(
          'Bienvenue !',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Commencons par votre plaque d\'immatriculation',
          style: TextStyle(
            fontSize: 16,
            color: textSecondary,
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
          onChanged: _handlePlateChanged,
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Continuer',
          onPressed: _handleSubmit,
          fullWidth: true,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Vos donnees sont securisees et confidentielles',
            style: TextStyle(
              fontSize: 12,
              color: textHint,
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
