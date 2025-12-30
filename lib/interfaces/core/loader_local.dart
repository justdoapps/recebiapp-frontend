import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extension.dart';

class LoadingLocal extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;

  const LoadingLocal({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Stack(
      children: [
        IgnorePointer(child: Opacity(opacity: 0.5, child: child)),

        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator.adaptive(),
                if (loadingText != null) ...[
                  const SizedBox(height: 16),
                  Text(loadingText!, style: context.textTheme.medium),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
