import 'package:flutter/foundation.dart';

import '../../../core/utils/result.dart';
import '../../../domain/enum/monetization_enum.dart';
import '../../../domain/models/user_model.dart';

abstract class AuthRepository extends ChangeNotifier {
  UserModel? get user;
  bool get isAuthenticated;
  Future<void> initAuth();
  Future<Result<void>> login({required String email, required String password});
  Future<void> logout();
  Future<void> updatePremium({required MonetizationPlan plan, required DateTime currentPeriodEnd});
  Future<Result<void>> register({
    required String email,
    required String password,
    required String name,
  });
  Future<Result<void>> forgotPassword({required String email});
}
