import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'build_context_extension.dart';

extension ModalsExtension on BuildContext {
  Future<bool?> showConfirmationDialog({
    Widget? title,
    required Widget content,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: barrierDismissible,

      builder: (_) => AlertDialog.adaptive(
        iconColor: theme.colorScheme.onSurface,
        title: title,
        content: Padding(
          padding: .only(top: title != null ? 0 : 16),
          child: content,
        ),
        actions: [
          TextButton(
            onPressed: () => pop(false),
            child: Text(cancelText ?? words.cancel),
          ),
          TextButton(
            onPressed: () => pop(true),
            child: Text(confirmText ?? words.confirm),
          ),
        ],
      ),
    );
  }

  Future<bool?> showInformationDialog({
    Widget? title,
    required Widget content,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (_) => AlertDialog.adaptive(
        title: title,
        content: Padding(
          padding: .only(top: title != null ? 0 : 16),
          child: content,
        ),
        actions: [
          TextButton(
            onPressed: () => pop(),
            child: Text(words.back),
          ),
        ],
      ),
    );
  }

  Future<void> showBottomSheet({
    required Widget child,
  }) {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => child,
    );
  }
}
