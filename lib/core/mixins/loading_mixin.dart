import 'package:flutter/material.dart';

mixin LoadingMixin<S extends StatefulWidget> on State<S> {
  OverlayEntry? _loadingOverlay;

  void showGlobalLoader() {
    if (_loadingOverlay != null) return;

    _loadingOverlay = OverlayEntry(
      builder: (_) => SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.black54)),
            const Center(child: CircularProgressIndicator.adaptive()),
          ],
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_loadingOverlay!);
  }

  void hideGlobalLoader() {
    _loadingOverlay?.remove();
    _loadingOverlay = null;
  }
}
