import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../core/extensions/build_context_extension.dart';
import '../../core/theme/app_theme.dart';

@Preview(name: 'Typography Inspector')
Widget typographyInspectorPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: const Scaffold(body: _TypographyInspector()),
  );
}

class _TypographyInspector extends StatelessWidget {
  const _TypographyInspector();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildItem('VeryLarge', context.textTheme.veryLarge),
        _buildItem('VeryLargeBold', context.textTheme.veryLargeBold),
        const Divider(),
        _buildItem('Large', context.textTheme.large),
        _buildItem('LargeBold', context.textTheme.largeBold),
        const Divider(),
        _buildItem('Medium', context.textTheme.medium),
        _buildItem('MediumBold', context.textTheme.mediumBold),
        const Divider(),
        _buildItem('Small', context.textTheme.small),
        _buildItem('SmallBold', context.textTheme.smallBold),
        const Divider(),
        _buildItem('VerySmall', context.textTheme.verySmall),
        _buildItem('VerySmallBold', context.textTheme.verySmallBold),
        const Divider(),
        _buildItem('ErrorForm', context.textTheme.errorForm),
      ],
    );
  }

  Widget _buildItem(String name, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(name, style: style)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Size: ${style?.fontSize?.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 15, color: Colors.amber),
                ),
                Text(
                  'Weight: w${style?.fontWeight?.value}',
                  style: const TextStyle(fontSize: 15, color: Colors.amber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
