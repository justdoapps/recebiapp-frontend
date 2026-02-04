import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dependencies.dart';
import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/formatters_extension.dart';
import '../../../core/routing/routes.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../domain/enum/monetization_enum.dart';
import '../../screens/customer/lang/customer_localization_ext.dart';
import '../../screens/recurrence_template/lang/template_localization_ext.dart';
import 'locale_selector.dart';
import 'theme_mode_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    if (location.startsWith(Routes.home)) return 0;
    if (location.startsWith(Routes.monetization)) return 1;
    if (location.startsWith(Routes.customer)) return 2;

    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    Scaffold.of(context).closeDrawer();

    switch (index) {
      case 0:
        context.go(Routes.home);
        break;
      case 1:
        context.go(Routes.monetization);
        break;
      case 2:
        context.go(Routes.customer);
        break;
      case 3:
        context.go(Routes.recurrence);
        break;
      case 4:
        context.go(Routes.template);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NavigationDrawer(
        selectedIndex: _getSelectedIndex(context),
        onDestinationSelected: (index) => _onDestinationSelected(context, index),
        header: DrawerHeader(
          margin: .zero,
          padding: const .only(left: 16, top: 16, right: 16, bottom: 0),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primary,
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    context.words.appName,
                    style: context.textTheme.mediumBold.copyWith(
                      color: context.theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                getIt.get<AuthRepository>().user?.name ?? '',
                style: context.textTheme.verySmall.copyWith(
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
              Text(
                getIt.get<AuthRepository>().user?.email ?? '',
                style: context.textTheme.verySmall.copyWith(
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
              Text(
                getIt.get<AuthRepository>().user?.plan.getPlanName(
                      context,
                    ) ??
                    '',
                style: context.textTheme.verySmall.copyWith(
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
              Visibility(
                visible: getIt.get<AuthRepository>().user?.plan != MonetizationPlan.FREE,
                child: Text(
                  getIt.get<AuthRepository>().user?.currentPeriodEnd.toLocaleDayDate(context.locale) ?? '',
                  style: context.textTheme.verySmall.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: .end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      getIt.get<AuthRepository>().logout();
                    },
                    label: Text(
                      context.words.logout,
                      style: context.textTheme.verySmall.copyWith(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                    icon: Icon(
                      Icons.logout,
                      size: 20,
                      color: context.theme.colorScheme.onPrimary,
                    ),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),

        footer: const Column(
          children: [LocaleSelector(), ThemeModeTile()],
        ),

        children: [
          const SizedBox(height: 20),
          NavigationDrawerDestination(
            icon: const Icon(Icons.home_outlined, size: 20),
            selectedIcon: Icon(Icons.home, size: 20, color: context.theme.colorScheme.primary),
            label: Text(context.words.home),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.monetization_on_outlined, size: 20),
            selectedIcon: Icon(Icons.monetization_on, size: 20, color: context.theme.colorScheme.primary),
            label: Text(context.words.monetizationPage),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.people_outline, size: 20),
            selectedIcon: Icon(Icons.people, size: 20, color: context.theme.colorScheme.primary),
            label: Text(context.words.customerAndSupplier),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.abc, size: 20),
            selectedIcon: Icon(Icons.abc, size: 20, color: context.theme.colorScheme.primary),
            label: Text(context.words.templates),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.repeat, size: 20),
            selectedIcon: Icon(Icons.repeat, size: 20, color: context.theme.colorScheme.primary),
            label: Text(context.words.recurrence),
          ),
        ],
      ),
    );
  }
}
