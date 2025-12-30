import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/dependencies.dart';
import '../../core/extensions/build_context_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/repositories/auth/auth_repository.dart';
import 'locale_selector.dart';
import 'theme_mode_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              margin: .zero,
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
                        style: context.textTheme.largeBold.copyWith(
                          color: context.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    getIt.get<AuthRepository>().user?.name ?? '',
                    style: context.textTheme.small.copyWith(
                      color: context.theme.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    getIt.get<AuthRepository>().user?.email ?? '',
                    style: context.textTheme.small.copyWith(
                      color: context.theme.colorScheme.onPrimary,
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

            ListTile(
              leading: const Icon(Icons.home),
              title: Text(context.words.home),
              onTap: () {
                context.pop();
                context.go(Routes.home);
              },
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [LocaleSelector(), ThemeModeTile()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
