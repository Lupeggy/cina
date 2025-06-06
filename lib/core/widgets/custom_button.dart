import 'package:flutter/material.dart';
import 'package:cina/core/constants/app_colors.dart';
import 'package:cina/core/constants/app_typography.dart';

enum ButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget? icon;
  final double borderRadius;
  final Color? textColor;
  final Color? buttonColor;
  final double? elevation;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.width,
    this.height = 48.0,
    this.icon,
    this.borderRadius = 12.0,
    this.textColor,
    this.buttonColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine button colors and styles based on type
    late final Color backgroundColor;
    late final Color foregroundColor;
    late final Color borderColor;
    
    switch (type) {
      case ButtonType.primary:
        backgroundColor = buttonColor ?? theme.colorScheme.primary;
        foregroundColor = textColor ?? theme.colorScheme.onPrimary;
        borderColor = buttonColor ?? theme.colorScheme.primary;
        break;
      case ButtonType.secondary:
        backgroundColor = buttonColor ?? theme.colorScheme.secondary;
        foregroundColor = textColor ?? theme.colorScheme.onSecondary;
        borderColor = buttonColor ?? theme.colorScheme.secondary;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = textColor ?? theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        foregroundColor = textColor ?? theme.colorScheme.primary;
        borderColor = Colors.transparent;
        break;
      case ButtonType.danger:
        backgroundColor = buttonColor ?? theme.colorScheme.error;
        foregroundColor = textColor ?? theme.colorScheme.onError;
        borderColor = buttonColor ?? theme.colorScheme.error;
        break;
    }
    
    // Determine button style based on type
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: AppColors.disabled,
      disabledForegroundColor: AppColors.disabledText,
      elevation: elevation ?? (type == ButtonType.text ? 0.0 : 2.0),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: type == ButtonType.outline 
            ? BorderSide(color: borderColor, width: 1.5)
            : BorderSide.none,
      ),
      minimumSize: Size(
        isFullWidth ? double.infinity : (width ?? 0.0),
        height ?? 48.0,
      ),
    );
    
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: _buildChild(theme),
    );
  }
  
  Widget _buildChild(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.primary || type == ButtonType.secondary || type == ButtonType.danger
                ? Colors.white
                : theme.colorScheme.primary,
          ),
          strokeWidth: 2.5,
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTypography.button.copyWith(
              color: textColor ?? (type == ButtonType.primary || type == ButtonType.secondary || type == ButtonType.danger
                  ? Colors.white
                  : theme.colorScheme.primary),
            ),
          ),
        ],
      );
    }
    
    return Text(
      text,
      style: AppTypography.button.copyWith(
        color: textColor ?? (type == ButtonType.primary || type == ButtonType.secondary || type == ButtonType.danger
            ? Colors.white
            : theme.colorScheme.primary),
      ),
    );
  }
}
