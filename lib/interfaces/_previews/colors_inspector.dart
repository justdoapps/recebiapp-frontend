import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../core/extensions/build_context_extension.dart';
import '../../core/theme/app_theme.dart';

@Preview(name: 'Colors Inspector')
Widget colorsInspectorPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: const Scaffold(body: ColorsInspector()),
  );
}

class ColorsInspector extends StatelessWidget {
  const ColorsInspector({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(context, 'Primary Palette'),
        _buildColorItem('Primary', scheme.primary),
        _buildColorItem('On Primary', scheme.onPrimary),
        _buildColorItem('Primary Container', scheme.primaryContainer),
        _buildColorItem('On Primary Container', scheme.onPrimaryContainer),
        _buildColorItem('Inverse Primary', scheme.inversePrimary),

        _buildHeader(context, 'Secondary Palette'),
        _buildColorItem('Secondary', scheme.secondary),
        _buildColorItem('On Secondary', scheme.onSecondary),
        _buildColorItem('Secondary Container', scheme.secondaryContainer),
        _buildColorItem('On Secondary Container', scheme.onSecondaryContainer),

        _buildHeader(context, 'Tertiary Palette'),
        _buildColorItem('Tertiary', scheme.tertiary),
        _buildColorItem('On Tertiary', scheme.onTertiary),
        _buildColorItem('Tertiary Container', scheme.tertiaryContainer),
        _buildColorItem('On Tertiary Container', scheme.onTertiaryContainer),

        _buildHeader(context, 'Error Palette'),
        _buildColorItem('Error', scheme.error),
        _buildColorItem('On Error', scheme.onError),
        _buildColorItem('Error Container', scheme.errorContainer),
        _buildColorItem('On Error Container', scheme.onErrorContainer),

        _buildHeader(context, 'Surface & Background'),
        _buildColorItem('Surface', scheme.surface),
        _buildColorItem('On Surface', scheme.onSurface),
        _buildColorItem('Surface Variant', scheme.surfaceContainerHighest),
        _buildColorItem('On Surface Variant', scheme.onSurfaceVariant),
        _buildColorItem('Inverse Surface', scheme.inverseSurface),
        _buildColorItem('On Inverse Surface', scheme.onInverseSurface),
        _buildColorItem('Surface Tint', scheme.surfaceTint),

        _buildHeader(context, 'Utilities'),
        _buildColorItem('Outline', scheme.outline),
        _buildColorItem('Outline Variant', scheme.outlineVariant),
        _buildColorItem('Shadow', scheme.shadow),
        _buildColorItem('Scrim', scheme.scrim),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      child: Text(title, style: context.textTheme.mediumBold),
    );
  }

  Widget _buildColorItem(String name, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(name, style: const TextStyle(color: Colors.white)),
          Text(name, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
