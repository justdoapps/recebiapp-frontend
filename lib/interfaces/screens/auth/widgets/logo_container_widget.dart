import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extension.dart';

class LogoContainerWidget extends StatelessWidget {
  const LogoContainerWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .only(top: 40),
      width: .infinity,
      height: context.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.theme.colorScheme.primary,
            context.theme.colorScheme.primary.withValues(alpha: .8),
          ],
          begin: .topCenter,
          end: .bottomRight,
        ),
        borderRadius: const .only(bottomLeft: .circular(50)),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 18),
        child: Column(
          spacing: 20,
          mainAxisAlignment: .center,
          children: [
            Container(
              padding: const .all(15),
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: .circular(30),
                border: .all(
                  width: 3,
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
              child: Image.asset('assets/images/logo.png', fit: .contain),
            ),
            Text(
              title,
              textAlign: .center,
              style: context.textTheme.veryLarge.copyWith(
                color: context.theme.colorScheme.onPrimary,
              ),
            ),
            Text(
              context.words.appDescription,
              textAlign: .center,
              style: context.textTheme.mediumBold.copyWith(
                color: context.theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
