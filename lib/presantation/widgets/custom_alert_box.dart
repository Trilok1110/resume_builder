import 'package:flutter/material.dart';
import '../../core/theme.dart';

class CustomAlertBox extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const CustomAlertBox({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: theme.cardColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: screenHeight * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingMedium,
                  horizontal: AppTheme.spacingLarge),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: content,
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: isDesktop
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: actions
                    .map((btn) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: btn,
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
