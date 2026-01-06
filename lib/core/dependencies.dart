import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/repositories/monetization/monetization_repository.dart';
import '../data/repositories/monetization/monetization_repository_impl.dart';
import '../data/services/http_service.dart';
import '../data/services/preferences_service.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  //services
  getIt.registerSingleton(PreferencesService(prefs));
  getIt.registerSingleton(HttpService(getIt()));

  //repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(http: getIt(), localData: getIt()),
  );
  getIt.registerLazySingleton<MonetizationRepository>(
    () => MonetizationRepositoryImpl(http: getIt()),
  );

  //viewmodels
  // if(getIt.isRegistered<AuthViewModel>()) {
  //   getIt.unregister<AuthViewModel>();
  // }
  // getIt.registerFactory<AuthViewModel>(
  //   () => AuthViewModel(authRepository: getIt()),
  // );
  // getIt.registerFactory<HomeViewModel>(() => HomeViewModel());
}
