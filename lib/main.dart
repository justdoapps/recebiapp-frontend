import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'core/dependencies.dart';
import 'core/langs/app_localization.dart';
import 'core/routing/router.dart';
import 'core/theme/app_theme.dart';
import 'data/services/preferences_service.dart';
import 'interfaces/core/config/app_scroll_behavior.dart';
import 'settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final initialTheme = getIt<PreferencesService>().getThemeMode();
  final initialLocale = getIt<PreferencesService>().getLocale();

  Stripe.publishableKey =
      'pk_test_51SikvOBNVficuVZna9RzahG3iMdESw5CPmfKFK1pmYX6W3Nr6aMm5DH1MCmj1n6svDTKmS2PJcdyvzSgVd0TzV7100lMj8T6Sk';
  Stripe.merchantIdentifier = 'RecebiApp';
  await Stripe.instance.applySettings();

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
      supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
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
