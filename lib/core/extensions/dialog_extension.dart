import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'build_context_extension.dart';

extension DialogExtension on BuildContext {
  Future<bool?> showConfirmationDialog({
    String? title,
    required Widget content,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: Padding(
          padding: EdgeInsets.only(top: title != null ? 0 : 16),
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
}
