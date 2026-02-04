import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth/auth_repository.dart';
import '../../domain/models/transaction_model.dart';
import '../../interfaces/screens/auth/auth_view.dart';
import '../../interfaces/screens/auth/auth_view_model.dart';
import '../../interfaces/screens/customer/customer_view.dart';
import '../../interfaces/screens/customer/customer_view_model.dart';
import '../../interfaces/screens/home/home_view.dart';
import '../../interfaces/screens/home/home_view_model.dart';
import '../../interfaces/screens/home/transaction_details_view.dart';
import '../../interfaces/screens/monetization/monetization_view.dart';
import '../../interfaces/screens/monetization/monetization_view_model.dart';
import '../../interfaces/screens/recurrence/recurrence_view.dart';
import '../../interfaces/screens/recurrence/recurrence_view_model.dart';
import '../../interfaces/screens/recurrence_template/template_view.dart';
import '../../interfaces/screens/recurrence_template/template_view_model.dart';
import '../../interfaces/screens/splash/splash_view.dart';
import '../dependencies.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: Routes.splash,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: getIt.get<AuthRepository>(),
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) {
        return const SplashView();
      },
    ),
    GoRoute(
      path: Routes.auth,
      builder: (context, state) {
        return Provider(
          create: (_) => AuthViewModel(authRepository: getIt()),
          dispose: (_, vm) => vm.dispose(),
          child: const AuthView(),
        );
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => HomeViewModel(
            repository: getIt(),
            listCustomersUseCase: getIt(),
            templateListUseCase: getIt(),
            recurrenceRepository: getIt(),
          ),
          child: const HomeView(),
        );
      },
      routes: [
        GoRoute(
          path: Routes.transactionDetails,
          builder: (context, state) {
            final transaction = state.extra as TransactionModel?;
            if (transaction == null) return const SizedBox.shrink(); //TODO erro screen
            return ChangeNotifierProvider(
              create: (_) => HomeViewModel(
                repository: getIt(),
                listCustomersUseCase: getIt(),
                templateListUseCase: getIt(),
                recurrenceRepository: getIt(),
              ),
              child: TransactionDetailsView(transaction: transaction),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: Routes.monetization,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => MonetizationViewModel(repository: getIt(), repAuth: getIt()),
          child: const MonetizationView(),
        );
      },
    ),
    GoRoute(
      path: Routes.customer,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => CustomerViewModel(repository: getIt(), listCustomersUseCase: getIt()),
          child: const CustomerView(),
        );
      },
    ),
    GoRoute(
      path: Routes.template,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => TemplateViewModel(repository: getIt(), listUseCase: getIt()),
          child: const TemplateView(),
        );
      },
    ),
    GoRoute(
      path: Routes.recurrence,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => RecurrenceViewModel(
            repository: getIt(),
          ),
          child: const RecurrenceView(),
        );
      },
    ),
  ],
);

String? _redirect(BuildContext context, GoRouterState state) {
  if (state.matchedLocation == Routes.splash) {
    return null;
  }

  if (state.matchedLocation != Routes.auth && !getIt.get<AuthRepository>().isAuthenticated) {
    return Routes.auth;
  }

  if (state.matchedLocation == Routes.auth && getIt.get<AuthRepository>().isAuthenticated) {
    return Routes.home;
  }

  return null;
}
