import 'dart:ui';

import 'package:flutter/material.dart';

import 'build_context_extension.dart';

enum MessagePosition { top, bottom }

enum MessageType { info, error, warning }

extension MessageExtension on BuildContext {
  void showMessage({
    String? message,
    String? title,
    MessagePosition position = MessagePosition.bottom,
    MessageType type = MessageType.info,
    String? actionLabel,
    VoidCallback? onAction,
    String? cancelLabel,
    VoidCallback? onCancel,
    Duration? duration,
  }) {
    duration ??= type == MessageType.error
        ? const Duration(seconds: 4)
        : type == MessageType.warning
        ? const Duration(seconds: 3)
        : const Duration(seconds: 2);

    final widget = _AppMessage(
      message: message,
      title: title,
      actionLabel: actionLabel,
      onAction: onAction,
      cancelLabel: cancelLabel,
      onCancel: onCancel,
      type: type,
    );

    if (position == MessagePosition.bottom) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: widget,
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: duration,
        ),
      );
      return;
    }

    final overlay = Overlay.of(this);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(color: Colors.transparent, child: widget),
      ),
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      if (entry.mounted) entry.remove();
    });
  }
}

class _AppMessage extends StatelessWidget {
  final String? message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final MessageType type;

  const _AppMessage({
    this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.cancelLabel,
    this.onCancel,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      switch (type) {
        case MessageType.info:
          return context.theme.colorScheme.primary;
        case MessageType.error:
          return context.theme.colorScheme.error;
        case MessageType.warning:
          return Colors.grey;
      }
    }

    Color getTextColor() {
      switch (type) {
        case MessageType.info:
          return context.theme.colorScheme.onPrimary;
        case MessageType.error:
          return context.theme.colorScheme.onError;
        case MessageType.warning:
          return Colors.black;
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: getBackgroundColor().withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: getBackgroundColor(), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: context.textTheme.mediumBold.copyWith(
                    color: getTextColor(),
                  ),
                ),
              ],
              if (message != null) ...[
                Text(
                  message!,
                  style: context.textTheme.small.copyWith(
                    color: getTextColor(),
                  ),
                ),
              ],
              if (onAction != null || onCancel != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onCancel != null)
                      TextButton(
                        onPressed: onCancel,
                        child: Text(
                          cancelLabel ?? context.words.cancel,
                          style: context.textTheme.smallBold.copyWith(
                            color: getTextColor(),
                          ),
                        ),
                      ),
                    if (onAction != null)
                      TextButton(
                        onPressed: onAction,
                        child: Text(
                          actionLabel ?? context.words.confirm,
                          style: context.textTheme.smallBold.copyWith(
                            color: getTextColor(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
