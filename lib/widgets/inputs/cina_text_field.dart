import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class CinaTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool isRequired;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool showCounter;
  final String? helperText;
  final double borderRadius;
  final bool expands;

  const CinaTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.isRequired = false,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.focusNode,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.onTap,
    this.contentPadding,
    this.fillColor,
    this.showCounter = false,
    this.helperText,
    this.borderRadius = 8.0,
    this.expands = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Row(
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                Text(
                  '*',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          autofocus: autofocus,
          focusNode: focusNode,
          validator: validator,
          textCapitalization: textCapitalization,
          readOnly: readOnly,
          onTap: onTap,
          expands: expands,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: prefixIcon,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: suffixIcon,
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            filled: true,
            fillColor: fillColor ?? theme.cardColor,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: theme.disabledColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            errorText: errorText,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontSize: 12,
            ),
            errorMaxLines: 2,
            counterText: showCounter ? null : '',
            helperText: helperText,
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// Example usage in your code:
/*
CinaTextField(
  controller: _emailController,
  label: 'Email',
  hintText: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).hintColor),
  isRequired: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  },
)
*/

// For a password field:
/*
CinaTextField(
  controller: _passwordController,
  label: 'Password',
  hintText: 'Enter your password',
  obscureText: true,
  prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).hintColor),
  suffixIcon: IconButton(
    icon: Icon(
      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      color: Theme.of(context).hintColor,
    ),
    onPressed: () {
      setState(() {
        _obscurePassword = !_obscurePassword;
      });
    },
  ),
  isRequired: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  },
)
*/

// For a search field:
/*
CinaTextField(
  controller: _searchController,
  label: 'Search',
  hintText: 'Search for movies, locations...',
  prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
  onChanged: (value) {
    // Handle search
  },
  textInputAction: TextInputAction.search,
  onSubmitted: (value) {
    // Handle search submission
  },
)
*/
