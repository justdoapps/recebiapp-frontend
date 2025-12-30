import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings_controller.dart';

class LocaleSelector extends StatelessWidget {
  const LocaleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    final currentSelection = {settings.locale?.languageCode ?? 'pt'};

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.comfortable,
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              segments: const [
                ButtonSegment<String>(
                  value: 'pt',
                  label: Text('Português'),
                  icon: Text('🇧🇷', style: TextStyle(fontSize: 18)),
                ),
                ButtonSegment<String>(
                  value: 'en',
                  label: Text('English'),
                  icon: Text('🇺🇸', style: TextStyle(fontSize: 18)),
                ),
              ],
              selected: currentSelection,
              onSelectionChanged: (Set<String> newSelection) {
                final langCode = newSelection.first;
                final newLocale = langCode == 'pt'
                    ? const Locale('pt', 'BR')
                    : const Locale('en', 'US');

                context.read<SettingsController>().updateLocale(newLocale);
              },
            ),
          ),
        ],
      ),
    );
  }
}
