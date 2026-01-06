import 'package:flutter/material.dart';

import '../langs/app_localization.dart';
import '../theme/app_typography.dart';

extension ThemeExtension on BuildContext {
  AppLocalization get words => AppLocalization.of(this);
  ThemeData get theme => Theme.of(this);
  AppTypography get textTheme => theme.extension<AppTypography>()!;
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
  double get viewInsetsBottom => MediaQuery.viewInsetsOf(this).bottom;
  String get locale => Localizations.localeOf(this).toString();
}
