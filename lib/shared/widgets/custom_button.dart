import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonVariant { primary, secondary, ghost }
enum ButtonSize { sm, md, lg }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool fullWidth;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.lg,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    BorderSide? borderSide;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = AppColors.autoAccent;
        textColor = Colors.white;
        borderSide = null;
        break;
      case ButtonVariant.secondary:
        backgroundColor = AppColors.autoSurfaceElevated;
        textColor = AppColors.autoTextPrimary;
        borderSide = const BorderSide(color: AppColors.autoBorder, width: 2);
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = AppColors.autoTextSecondary;
        borderSide = null;
        break;
    }

    double verticalPadding;
    double fontSize;

    switch (size) {
      case ButtonSize.sm:
        verticalPadding = 8;
        fontSize = 14;
        break;
      case ButtonSize.md:
        verticalPadding = 12;
        fontSize = 16;
        break;
      case ButtonSize.lg:
        verticalPadding = 16;
        fontSize = 16;
        break;
    }

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: verticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          side: borderSide ?? BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
