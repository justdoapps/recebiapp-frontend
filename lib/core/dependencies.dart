import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/repositories/customer/customer_repository.dart';
import '../data/repositories/customer/customer_repository_impl.dart';
import '../data/repositories/monetization/monetization_repository.dart';
import '../data/repositories/monetization/monetization_repository_impl.dart';
import '../data/repositories/recurrence/recurrence_repository.dart';
import '../data/repositories/recurrence/recurrence_repository_impl.dart';
import '../data/repositories/recurrence_template/template_repository.dart';
import '../data/repositories/recurrence_template/template_tepository_impl.dart';
import '../data/repositories/transaction/transaction_repository.dart';
import '../data/repositories/transaction/transaction_repository_impl.dart';
import '../data/services/http_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/preferences_service.dart';
import '../domain/use_cases/list_customers_use_case.dart';
import '../domain/use_cases/recurrence_list_use_case.dart';
import '../domain/use_cases/template_list_use_case.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  //services
  getIt.registerSingleton(PreferencesService(prefs));
  getIt.registerSingleton(HttpService(getIt()));
  getIt.registerSingleton(NotificationService());

  //repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(http: getIt(), localData: getIt()),
  );
  getIt.registerLazySingleton<MonetizationRepository>(
    () => MonetizationRepositoryImpl(http: getIt()),
  );
  getIt.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(http: getIt()),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(http: getIt()),
  );
  getIt.registerLazySingleton<TemplateRepository>(
    () => TemplateTepositoryImpl(http: getIt()),
  );
  getIt.registerLazySingleton<RecurrenceRepository>(
    () => RecurrenceRepositoryImpl(http: getIt()),
  );

  //use cases
  getIt.registerLazySingleton<ListCustomersUseCase>(
    () => ListCustomersUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<TemplateListUseCase>(
    () => TemplateListUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<RecurrenceListUseCase>(
    () => RecurrenceListUseCase(repository: getIt()),
  );
}
