import 'package:flutter/material.dart';
import '../../../config/theme.dart';

enum CinaButtonType {
  primary,
  secondary,
  outline,
  text,
}

class CinaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final CinaButtonType type;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isDisabled;

  const CinaButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = CinaButtonType.primary,
    this.isFullWidth = true,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine button style based on type
    Color? buttonColor;
    Color? buttonTextColor;
    Color? borderColor;
    
    switch (type) {
      case CinaButtonType.primary:
        buttonColor = backgroundColor ?? theme.colorScheme.primary;
        buttonTextColor = textColor ?? Colors.white;
        borderColor = backgroundColor ?? theme.colorScheme.primary;
        break;
      case CinaButtonType.secondary:
        buttonColor = backgroundColor ?? theme.colorScheme.secondary;
        buttonTextColor = textColor ?? Colors.black;
        borderColor = backgroundColor ?? theme.colorScheme.secondary;
        break;
      case CinaButtonType.outline:
        buttonColor = Colors.transparent;
        buttonTextColor = textColor ?? theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        break;
      case CinaButtonType.text:
        buttonColor = Colors.transparent;
        buttonTextColor = textColor ?? theme.colorScheme.primary;
        borderColor = Colors.transparent;
        break;
    }
    
    // Handle disabled state
    if (isDisabled) {
      buttonColor = theme.disabledColor.withOpacity(0.5);
      buttonTextColor = theme.disabledColor;
      borderColor = theme.disabledColor.withOpacity(0.5);
    }
    
    // Build button content
    Widget buttonContent = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == CinaButtonType.primary ? Colors.white : theme.colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: buttonTextColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: buttonTextColor,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          );
    
    // Return the appropriate button widget based on type
    if (type == CinaButtonType.outline) {
      return SizedBox(
        width: isFullWidth ? double.infinity : width,
        height: height,
        child: OutlinedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: borderColor!),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          ),
          child: buttonContent,
        ),
      );
    } else if (type == CinaButtonType.text) {
      return SizedBox(
        width: isFullWidth ? double.infinity : width,
        height: height,
        child: TextButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          ),
          child: buttonContent,
        ),
      );
    } else {
      return SizedBox(
        width: isFullWidth ? double.infinity : width,
        height: height,
        child: ElevatedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: borderColor!),
            ),
            padding: padding,
            elevation: 0,
          ),
          child: buttonContent,
        ),
      );
    }
  }
}

// Example usage in your code:
/*
CinaButton(
  text: 'Click Me',
  onPressed: () {
    // Handle button press
  },
  type: CinaButtonType.primary,
  isFullWidth: true,
  icon: Icons.add,
)
*/

// For a secondary button:
/*
CinaButton(
  text: 'Secondary',
  onPressed: () {},
  type: CinaButtonType.secondary,
)
*/

// For an outline button:
/*
CinaButton(
  text: 'Outline',
  onPressed: () {},
  type: CinaButtonType.outline,
)
*/

// For a text button:
/*
CinaButton(
  text: 'Text Button',
  onPressed: () {},
  type: CinaButtonType.text,
)
*/

// For a disabled button:
/*
CinaButton(
  text: 'Disabled',
  onPressed: () {},
  isDisabled: true,
)
*/

// For a loading button:
/*
CinaButton(
  text: 'Loading...',
  onPressed: () {},
  isLoading: true,
)
*/

// For a custom size button:
/*
CinaButton(
  text: 'Custom Size',
  onPressed: () {},
  width: 200,
  height: 60,
)
*/
