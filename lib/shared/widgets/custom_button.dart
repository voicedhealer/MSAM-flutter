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
    final textSecondary = AppTheme.textSecondary(context);
    final textPrimary = AppTheme.textPrimary(context);
    final surfaceElevated = AppTheme.surfaceElevated(context);
    final border = AppTheme.border(context);

    if (variant == ButtonVariant.primary) {
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

      final button = DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? LinearGradient(
                  colors: [
                    AppColors.autoBorder,
                    AppColors.autoBorder,
                  ],
                )
              : AppTheme.ctaGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: verticalPadding,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusButton),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

      return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
    }

    Color backgroundColor;
    Color textColor;
    BorderSide? borderSide;

    switch (variant) {
      case ButtonVariant.secondary:
        backgroundColor = surfaceElevated;
        textColor = textPrimary;
        borderSide = BorderSide(color: border, width: 2);
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = textSecondary;
        borderSide = null;
        break;
      case ButtonVariant.primary:
        backgroundColor = AppColors.autoAccent;
        textColor = Colors.white;
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
