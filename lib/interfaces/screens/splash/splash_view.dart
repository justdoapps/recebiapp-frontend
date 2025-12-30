import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dependencies.dart';
import '../../../core/routing/routes.dart';
import '../../../data/repositories/auth/auth_repository.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getIt.get<AuthRepository>().initAuth();
    if (!mounted) return;
    if (getIt.get<AuthRepository>().isAuthenticated) {
      context.go(Routes.home);
    } else {
      context.go(Routes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(color: Colors.red, child: const Text('Splash')),
      ),
    );
  }
}
