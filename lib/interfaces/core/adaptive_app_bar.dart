import 'package:flutter/material.dart';
import '../../core/extensions/build_context_extension.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onLeadingPressed;

  const AdaptiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.onLeadingPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 2,
      scrolledUnderElevation: 10,
      leading: leading,
      actions: actions,
      backgroundColor: context.theme.colorScheme.primary,
      foregroundColor: context.theme.colorScheme.onPrimary,
      shadowColor: context.theme.colorScheme.primary,
    );
  }
}
