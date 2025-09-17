import 'package:flutter/material.dart';
import '../../core/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth; // New: Control full-width behavior

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Padding(
      padding: EdgeInsets.only(top: AppTheme.spacingMedium),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = isFullWidth || !isDesktop
              ? double.infinity
              : constraints.maxWidth > 300
              ? 300.0 // Max width on desktop for better UX
              : double.infinity;

          return Center(
            child: SizedBox(
              width: buttonWidth,
              height: kMinInteractiveDimension, // Ensures touch target size (48dp min)
              child: ElevatedButton(
                onPressed: isLoading || onPressed == null ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMedium,
                    vertical: AppTheme.spacingSmall,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.spacingSmall),
                  ),
                  elevation: isDesktop ? 2 : 4, // Subtle shadow on desktop
                ),
                child: isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                )
                    : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}