import 'package:flutter/material.dart';
import '../../core/theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final bool autofocus;
  final VoidCallback? onSuffixTap;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.validator,
    this.onChanged,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isError = false; // Can be dynamic if needed (e.g., from validator)

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppTheme.spacingMedium,
        left: MediaQuery.of(context).size.width > 600 ? AppTheme.spacingLarge : AppTheme.spacingMedium,
        right: MediaQuery.of(context).size.width > 600 ? AppTheme.spacingLarge : AppTheme.spacingMedium,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        autofocus: autofocus,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText ?? 'Enter ${label.toLowerCase()}',
          prefixIcon: prefixIcon != null
              ? Icon(
            prefixIcon,
            color: theme.colorScheme.primary.withOpacity(0.7),
          )
              : null,
          suffixIcon: suffixIcon != null
              ? GestureDetector(
            onTap: onSuffixTap,
            child: Icon(
              suffixIcon,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.spacingSmall),
            borderSide: BorderSide(
              color: theme.colorScheme.outline,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.spacingSmall),
            borderSide: BorderSide(
              color: theme.colorScheme.outline,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.spacingSmall),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.spacingSmall),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.spacingSmall),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.1),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMedium,
            vertical: AppTheme.spacingSmall,
          ),
          errorStyle: TextStyle(
            color: theme.colorScheme.error,
            fontSize: 12,
          ),
          labelStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}