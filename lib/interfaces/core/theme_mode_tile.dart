import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/build_context_extension.dart';
import '../../settings_controller.dart';

class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final isDark = settings.themeMode == ThemeMode.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(context.words.themeMode),
      subtitle: Text(isDark ? context.words.darkMode : context.words.lightMode),
      leading: Icon(
        isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
        color: context.theme.colorScheme.primary,
      ),
      trailing: Switch(
        value: isDark,
        onChanged: (val) {
          final newMode = val ? ThemeMode.dark : ThemeMode.light;
          context.read<SettingsController>().updateThemeMode(newMode);
        },
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.dark_mode, color: Colors.white);
          }
          return const Icon(Icons.wb_sunny, color: Colors.amber);
        }),
      ),
    );
  }
}
