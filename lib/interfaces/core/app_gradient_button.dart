import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extension.dart';

class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.height = 50,
  });

  final VoidCallback onPressed;
  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: context.theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 4,
            colors: [
              context.theme.colorScheme.primary,
              context.theme.colorScheme.primary.withValues(alpha: .8),
            ],
            // begin: Alignment.topLeft,
            // end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: Center(
            child: Text(
              label,
              style: context.textTheme.mediumBold.copyWith(
                color: context.theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
