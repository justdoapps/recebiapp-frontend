import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/dependencies.dart';
import 'core/langs/app_localization.dart';
import 'core/routing/router.dart';
import 'core/theme/app_theme.dart';
import 'data/services/preferences_service.dart';
import 'interfaces/core/app_scroll_behavior.dart';
import 'settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final initialTheme = getIt<PreferencesService>().getThemeMode();
  final initialLocale = getIt<PreferencesService>().getLocale();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsController(
        service: getIt<PreferencesService>(),
        initialTheme: initialTheme,
        initialLocale: initialLocale,
      ),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    return MaterialApp.router(
      supportedLocales: const [Locale('en'), Locale('pt')],
      locale: settingsController.locale,
      localizationsDelegates: [
        AppLocalizationDelegate(),
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      scrollBehavior: AppScrollBehavior(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsController.themeMode,
      routerConfig: appRouter,
    );
  }
}
