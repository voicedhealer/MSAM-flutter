import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? error;
  final String? placeholder;
  final IconData? icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool autofocus;
  final Function(String)? onChanged;

  const CustomInput({
    Key? key,
    this.label,
    this.hint,
    this.error,
    this.placeholder,
    this.icon,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.autofocus = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.autoTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.autoSurfaceElevated,
            borderRadius: BorderRadius.circular(AppTheme.radiusInput),
            border: Border.all(
              color: error != null ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            autofocus: autofocus,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: AppColors.autoTextHint),
              prefixIcon: icon != null
                  ? Icon(icon, color: AppColors.autoTextHint, size: 20)
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: icon != null ? 12 : 16,
                vertical: 16,
              ),
              counterText: '',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                borderSide: const BorderSide(
                  color: AppColors.autoBorderFocus,
                  width: 2,
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.autoTextPrimary,
            ),
          ),
        ),
        if (hint != null && error == null) ...[
          const SizedBox(height: 8),
          Text(
            hint!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.autoTextHint,
            ),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
